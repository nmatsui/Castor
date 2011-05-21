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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
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
    NSLog(@"HomeView Will appear");
    self.navigationController.navigationBar.hidden = NO;
    [self.homeTable deselectRowAtIndexPath:[self.homeTable indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"HomeView loaded");
    self.title = @"Home";
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
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
    if (indexPath.section < [self.homeList count] - 1 || indexPath.row < [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 2) {
        return [self.cellBuilder getEntryCellHeight:[[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row] portrate:_portrate];
    }
    else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if ([self.homeList count] <= indexPath.section && [[[self.homeList objectAtIndex:indexPath.section] entries] count] <= indexPath.row) return cell;
    
    if (indexPath.section != [self.homeList count] - 1 || indexPath.row < [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 2) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        EntryData *entry = [[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:[self.cellBuilder getEntryCellView:entry portrate:_portrate]];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        [pool release];
    }
    else if (indexPath.section == [self.homeList count] - 1 && indexPath.row == [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 2) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [cell.contentView addSubview:[self.cellBuilder getNextPageCellView:_portrate]];
        [pool release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"HomeView %d section %d row tapped", indexPath.section, indexPath.row);
    if (indexPath.section != [self.homeList count] - 1 || indexPath.row < [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 2) {
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
    else if (indexPath.section == [self.homeList count] - 1 && indexPath.row == [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 2) {
        [self _nextPage:self];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory button %d section %d row clicked", indexPath.section, indexPath.row);
    RoomData *room = [self.homeList objectAtIndex:indexPath.section];
    EntryData *entry = [room.entries objectAtIndex:indexPath.row];
    [self performSelector:@selector(_moveToCommentViewWithOrigin:) withObject:[[NSArray alloc] initWithObjects:room, entry, nil]];
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
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadHomeTimelineInBackground:) withObject:nil];
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
- (IBAction)callSetting:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to SettingView");
    SettingView *settingView = [[[SettingView alloc] initWithNibName:@"SettingView" bundle:nil 
                                                             factory:self.factory] autorelease];
    [self.navigationController pushViewController:settingView animated:YES];
    [pool release];
}

- (IBAction)moveToGroup:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to GroupView");
    GroupView *groupView = [[[GroupView alloc] initWithNibName:@"GroupView" bundle:nil 
                                                       factory:self.factory] autorelease];
    [self.navigationController pushViewController:groupView animated:YES];
    [pool release];
}

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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.factory.gateway.pDic = nil;
    NSMutableArray *list = [self.factory getHomeTimelineWithPage:_page sender:self];
    if (list != nil && [list count] != 0) {
        self.homeList = list;
        [[[self.homeList objectAtIndex:[self.homeList count] - 1] entries] addObject:[[[EntryData alloc] init] autorelease]]; // <<load next page>>用
        [[[self.homeList objectAtIndex:[self.homeList count] - 1] entries] addObject:[[[EntryData alloc] init] autorelease]]; // 最後の空白行用
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
    [self.navigationController pushViewController:roomView animated:YES];
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
    [self.navigationController pushViewController:commentView animated:YES];
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
                                                                      entry:[origin objectAtIndex:1]] autorelease];
        [self.navigationController pushViewController:longTextView animated:YES];
    }
    else if ([@"Image" isEqualToString:[[origin objectAtIndex:1] attachmentType]]) {
        NSLog(@"move to ImageView");
        ImageView *imageView = [[[ImageView alloc] initWithNibName:@"ImageView" bundle:nil 
                                                             entry:[origin objectAtIndex:1] 
                                                           factory:self.factory] autorelease];
        [self.navigationController pushViewController:imageView animated:YES];
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
        [[[self.homeList objectAtIndex:[self.homeList count] - 1] entries] addObject:[[[EntryData alloc] init] autorelease]]; // <<load next page>>用
        [[[self.homeList objectAtIndex:[self.homeList count] - 1] entries] addObject:[[[EntryData alloc] init] autorelease]]; // 最後の空白行用
        [self.homeTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}
@end
