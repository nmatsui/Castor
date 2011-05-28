//
//  HomeView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeView.h"

@interface HomeView (Private)
- (void)_startIndicator:(id)sender;
- (void)_reloadHomeTimelineInBackground:(id)arg;
- (void)_nextPage:(id)sender;
- (void)_headerClick:(id)sender;
- (void)_moveToCommentViewWithOrigin:(NSArray *)origin;
- (void)_markReadWithOrigin:(NSArray *)origin;
- (void)_viewAttachmentWithOrigin:(NSArray *)origin;
- (void)_cancelWithOrigin:(NSArray *)origin;
- (void)_markReadInBackground:(id)arg;
@end

@implementation HomeView

@synthesize homeTable = _homeTable;
@synthesize homeList = _homeList;
@synthesize factory = _factory;
@synthesize cellBuilder = _cellBuilder;
@synthesize targetRoom = _targetRoom;
@synthesize targetEntry = _targetEntry;
@synthesize selectors = _selectors;
@synthesize indicator = _indicator;
@synthesize triggerHeader = _triggerHeader;
@synthesize triggerFooter = _triggerFooter;
@synthesize container = _container;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
            container:(ContainerView *)container
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _page = 1;
        self.factory = factory;
        self.homeList = [self.factory getHomeTimelineFromCache];
        self.cellBuilder = [[CellBuilder alloc] initWithDataFactory:self.factory];
        self.selectors = [[NSMutableArray alloc] init];
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.indicator];
        _headerON = NO;
        _footerON = NO;
        self.container = container;
    }
    return self;
}

- (void)dealloc
{
    self.homeTable = nil;
    self.homeList = nil;
    self.factory = nil;
    self.cellBuilder = nil;
    self.targetRoom = nil;
    self.targetEntry = nil;
    self.selectors = nil;
    self.indicator = nil;
    self.triggerHeader = nil;
    self.triggerFooter = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.factory == nil) {
        NSLog(@"DataFactory disappeared");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Homeへ移動します" 
                                                            message:@"メモリ不足のためキャッシュが破棄されました"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        ContainerView *containerView = [[[ContainerView alloc] initWithNibName:@"ContainerView" bundle:nil
                                                                       factory:[[DataFactory alloc] init]] autorelease];
        [self.container.navigationController pushViewController:containerView animated:YES];
    }
    NSLog(@"HomeView Will appear");
    self.container.navigationController.navigationBar.hidden = NO;
    [self.homeTable deselectRowAtIndexPath:[self.homeTable indexPathForSelectedRow] animated:YES];
    if (self.triggerHeader == nil) {
        self.triggerHeader = [self.cellBuilder getTriggerHeader:self.homeTable.bounds portrate:_portrate];
        [self.homeTable addSubview:self.triggerHeader];
    }
    if (self.triggerFooter == nil) {
        self.triggerFooter = [self.cellBuilder getTriggerFooter:self.homeTable.bounds portrate:_portrate];
        self.homeTable.tableFooterView = self.triggerFooter;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"HomeView loaded");
    self.title = @"Home";
    [self.container.navigationItem.backBarButtonItem setEnabled:NO];
    self.container.navigationItem.hidesBackButton = YES;
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadHomeTimelineInBackground:) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.homeTable = nil;
    self.homeList = nil;
    self.factory = nil;
    self.cellBuilder = nil;
    self.targetRoom = nil;
    self.targetEntry = nil;
    self.selectors = nil;
    self.indicator = nil;
    self.triggerHeader = nil;
    self.triggerFooter = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        _portrate = NO;
        [self.homeTable reloadData];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown || interfaceOrientation == UIDeviceOrientationPortrait) {
        _portrate = YES;
        [self.homeTable reloadData];
    }
    return YES;
}

//// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.homeList count];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.cellBuilder getRoomHeaderView:[self.homeList objectAtIndex:section] 
                                        target:self 
                                        action:@selector(_headerClick:) 
                                       section:section
                                      portrate:_portrate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.homeList objectAtIndex:section] entries] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellBuilder getEntryCellHeight:[[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row] portrate:_portrate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if ([self.homeList count] <= indexPath.section && [[[self.homeList objectAtIndex:indexPath.section] entries] count] <= indexPath.row) return cell;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EntryData *entry = [[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row];
    [cell.contentView addSubview:[self.cellBuilder getEntryCellView:entry portrate:_portrate]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [pool release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"HomeView %d section %d row tapped", indexPath.section, indexPath.row);
    [self.selectors removeAllObjects];
    if (self.targetRoom != nil) self.targetRoom = nil;
    if (self.targetEntry != nil ) self.targetEntry = nil;
    self.targetRoom = [self.homeList objectAtIndex:indexPath.section];
    self.targetEntry = [[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row];
    UIActionSheet *menu = [[UIActionSheet alloc] init];
    [menu setDelegate:self];
    
    // View Commentsボタンは必ず表示
    [menu addButtonWithTitle:@"View Comments"];
    [self.selectors addObject:@"_moveToCommentViewWithOrigin:"];
    
    // Mark Readボタンは必ず表示
    [menu addButtonWithTitle:@"Mark read"];
    [self.selectors addObject:@"_markReadWithOrigin:"];
    
    // View Attachmentボタンの表示判定
    if ([@"Text" isEqualToString:self.targetEntry.attachmentType] || [@"Image" isEqualToString:self.targetEntry.attachmentType] || [@"Link" isEqualToString:self.targetEntry.attachmentType]) {
        [menu addButtonWithTitle:@"View Attachment"];
        [self.selectors addObject:@"_viewAttachmentWithOrigin:"];
    }
    
    // Cancelボタンは必ず表示
    [menu addButtonWithTitle:@"Cancel"];
    [self.selectors addObject:@"_cancelWithOrigin:"];
    
    [menu showInView:self.view];
    [menu release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory button %d section %d row clicked", indexPath.section, indexPath.row);
    RoomData *room = [self.homeList objectAtIndex:indexPath.section];
    EntryData *entry = [room.entries objectAtIndex:indexPath.row];
    [self performSelector:@selector(_moveToCommentViewWithOrigin:) withObject:[[NSArray alloc] initWithObjects:room, entry, nil]];
}

//// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect r = self.homeTable.bounds;
    if ((r.origin.y < -1 * [self.cellBuilder getTriggerBounds]) && (_headerON == NO)) {
		_headerON = YES;
		[(UILabel *)[self.triggerHeader viewWithTag:1] setText:@"手を離すと更新"];
        UIImageView *imageView = (UIImageView *)[self.triggerHeader viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14);
		[UIView commitAnimations];
	}
	else if ((r.origin.y == 0) && (_headerON == YES)) {
		_headerON = NO;
		[(UILabel *)[self.triggerHeader viewWithTag:1] setText:@"プルダウンすると更新"];
        UIImageView *imageView = (UIImageView *)[self.triggerHeader viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_reloadHomeTimelineInBackground:) withObject:nil];
	}
    
    
    double tableTail = r.origin.y + r.size.height;
    double triggerTail = self.triggerFooter.frame.origin.y + self.triggerFooter.frame.size.height;
    if ((tableTail > triggerTail + [self.cellBuilder getTriggerBounds]) && (_footerON == NO)) {
        _footerON = YES;
        [(UILabel *)[self.triggerFooter viewWithTag:1] setText:@"手を離すと次ページを表示"];
        UIImageView *imageView = (UIImageView *)[self.triggerFooter viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14);
		[UIView commitAnimations];
    }
    else if ((tableTail == triggerTail) && (_footerON == YES)) {
		_footerON = NO;
		[(UILabel *)[self.triggerFooter viewWithTag:1] setText:@"プルアップすると次ページを表示"];
        UIImageView *imageView = (UIImageView *)[self.triggerFooter viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
        [self _nextPage:self];
	}
}

//// UIActionSheet Callback
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet button clicked[%d]", buttonIndex);
    [self performSelector:NSSelectorFromString([self.selectors objectAtIndex:buttonIndex]) withObject:[[NSArray alloc] initWithObjects:self.targetRoom, self.targetEntry, nil]];
    self.targetRoom = nil;
    self.targetEntry = nil;
    [self.selectors removeAllObjects];
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadHome");
    _page = 1;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadHomeTimelineInBackground:) withObject:nil];
    [pool release];
}

//// Alertable
- (void)alertException:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setMessage:message];
    [alert addButtonWithTitle:@"OK"];
	[alert show];
	[alert release];
}

//// IBAction
//- (IBAction)callSetting:(id)sender
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSLog(@"move to SettingView");
//    SettingView *settingView = [[[SettingView alloc] initWithNibName:@"SettingView" bundle:nil 
//                                                             factory:self.factory] autorelease];
//    [self.container.navigationController pushViewController:settingView animated:YES];
//    [pool release];
//}

//- (IBAction)moveToGroup:(id)sender
//{
////    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
////    NSLog(@"move to GroupView");
////    GroupView *groupView = [[[GroupView alloc] initWithNibName:@"GroupView" bundle:nil 
////                                                       factory:self.factory] autorelease];
////    [self.navigationController pushViewController:groupView animated:NO];
////    [pool release];
//    
//    [self.container tggleView];
//}

//// Private
- (void)_startIndicator:(id)sender
{
    CGRect viewSize = self.view.bounds;
    [self.indicator setFrame:CGRectMake(viewSize.size.width/2-25, viewSize.size.height/2-25, 50, 50)];
    [self.indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_reloadHomeTimelineInBackground:(id)arg
{
    NSLog(@"reload homeList In Background");
    NSLog(@"self.factory %@", self.factory);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.factory.gateway.pDic = nil;
    NSMutableArray *list = [self.factory getHomeTimelineWithPage:_page sender:self];
    if (list != nil && [list count] != 0) {
        self.homeList = list;
        [self.homeTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

- (void)_nextPage:(id)sender
{
    _page++;
    NSLog(@"nextPage [%d]", _page);
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadHomeTimelineInBackground:) withObject:nil];
}

- (void)_headerClick:(id)sender
{
    NSLog(@"headerClick %d", [sender tag]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    RoomView *roomView = [[[RoomView alloc] initWithNibName:@"RoomView" bundle:nil 
                                                       room:[self.homeList objectAtIndex:[sender tag]] 
                                                    factory:self.factory] autorelease];
    [self.container.navigationController pushViewController:roomView animated:YES];
    [pool release];
}

- (void)_moveToCommentViewWithOrigin:(NSArray *)origin
{
    NSLog(@"move to CommentView [%@]", [[origin objectAtIndex:1] entryId]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CommentView *commentView = [[[CommentView alloc] initWithNibName:@"CommentView" 
                                                              bundle:nil 
                                                                room:[origin objectAtIndex:0]
                                                         originEntry:[origin objectAtIndex:1]
                                                        previousView:self 
                                                             factory:self.factory] autorelease];
    [self.container.navigationController pushViewController:commentView animated:YES];
    [pool release];
}

- (void)_markReadWithOrigin:(NSArray *)origin
{
    NSLog(@"mark read [%@]", [[origin objectAtIndex:1] entryId]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_markReadInBackground:) withObject:[origin objectAtIndex:1]];
    [pool release];
}

- (void)_viewAttachmentWithOrigin:(NSArray *)origin
{
    NSLog(@"View Attachment [%@]", [[origin objectAtIndex:1] entryId]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([@"Text" isEqualToString:[[origin objectAtIndex:1] attachmentType]]) {
        NSLog(@"move to LongTextView");
        LongTextView *longTextView = [[[LongTextView alloc] initWithNibName:@"LongTextView" bundle:nil 
                                                                      entry:[origin objectAtIndex:1]
                                                                    factory:self.factory] autorelease];
        [self.container.navigationController pushViewController:longTextView animated:YES];
    }
    else if ([@"Image" isEqualToString:[[origin objectAtIndex:1] attachmentType]]) {
        NSLog(@"move to ImageView");
        ImageView *imageView = [[[ImageView alloc] initWithNibName:@"ImageView" bundle:nil 
                                                             entry:[origin objectAtIndex:1] 
                                                           factory:self.factory] autorelease];
        [self.container.navigationController pushViewController:imageView animated:YES];
    }
    else if ([@"Link" isEqualToString:[[origin objectAtIndex:1] attachmentType]]) {
        NSLog(@"open safari with url[%@]", [[origin objectAtIndex:1] attachmentURL]);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[origin objectAtIndex:1] attachmentURL]]];
    }
    [pool release];
}

- (void)_cancelWithOrigin:(NSArray *)origin
{
    NSLog(@"cancel entry [%@]", [[origin objectAtIndex:1] entryId]);
    [self.homeTable deselectRowAtIndexPath:[self.homeTable indexPathForSelectedRow] animated:YES];
}

- (void)_markReadInBackground:(id)arg
{
    NSLog(@"mark read In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.factory.gateway.pDic = nil;
    [self.factory markEntryRead:[arg entryId] sender:self];
    NSMutableArray *list = [self.factory getHomeTimelineWithPage:_page sender:self];
    if (list != nil && [list count] != 0) {
        self.homeList = list;
        [self.homeTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}
@end
