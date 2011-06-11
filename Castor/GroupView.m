//
//  GroupView2.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupView.h"

@interface GroupView (Private)
- (void)_startIndicator:(id)sender;
- (void)_reloadGroupListInBackground:(id)arg;
@end

@implementation GroupView

@synthesize roomTable = _roomTable;
@synthesize roomList = _roomList;
@synthesize indicator = _indicator;
@synthesize cellBuilder = _cellBuilder;
@synthesize triggerHeader = _triggerHeader;
@synthesize nilFooter = _nilFooter;
@synthesize container = _container;
@synthesize toolbar = _toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
            container:(ContainerView *)container
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil factory:factory];
    if (self) {
        self.roomList = [self.factory getRoomListFromCache];
        self.cellBuilder = [[CellBuilder alloc] initWithDataFactory:self.factory];
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.indicator];
        _headerON = NO;
        self.container = container;
    }
    return self;
}

- (void)dealloc
{
    self.roomList = nil;
    self.roomTable = nil;
    self.indicator = nil;
    self.cellBuilder = nil;
    self.triggerHeader = nil;
    self.nilFooter = nil;
    self.toolbar = nil;
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
    NSLog(@"GroupView Will appear");
    self.container.navigationController.navigationBar.hidden = NO;
    [self.roomTable deselectRowAtIndexPath:[self.roomTable indexPathForSelectedRow] animated:YES];
    if (self.triggerHeader == nil) {
        self.triggerHeader = [self.cellBuilder getTriggerHeader:self.roomTable.bounds portrate:_portrate];
        [self.roomTable addSubview:self.triggerHeader];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GroupView loaded");
    self.title = @"Group";
    if (self.factory != nil) {
        [self.container.navigationItem.backBarButtonItem setEnabled:NO];
        self.container.navigationItem.hidesBackButton = YES;
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_reloadGroupListInBackground:) withObject:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.roomList = nil;
    self.roomTable = nil;
    self.indicator = nil;
    self.cellBuilder = nil;
    self.triggerHeader = nil;
    self.nilFooter = nil;
    self.toolbar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.roomTable reloadData];
    return YES;
}

//// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.roomList count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.roomList count] - 1) {
        return [self.cellBuilder getRoomCellHeight:[self.roomList objectAtIndex:indexPath.row] portrate:_portrate];
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
    if ([self.roomList count] <= indexPath.row) return cell;
    
    if (indexPath.row < [self.roomList count] - 1) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        RoomData *room = [self.roomList objectAtIndex:indexPath.row];
        [cell.contentView addSubview:[self.cellBuilder getRoomCellView:room portrate:_portrate]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [pool release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"GroupView %d row tapped",indexPath.row);
    if (indexPath.row < [self.roomList count] - 1) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        RoomView *roomView = [[[RoomView alloc] initWithNibName:@"RoomView" bundle:nil
                                                           room:[self.roomList objectAtIndex:indexPath.row]
                                                        factory:self.factory] autorelease];
        [self.container.navigationController pushViewController:roomView animated:YES];
        [pool release];
    }
}

//// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect r = self.roomTable.bounds;
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
        [self performSelectorInBackground:@selector(_reloadGroupListInBackground:) withObject:nil];
	}
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadGroup");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadGroupListInBackground:) withObject:nil];
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

- (void)_reloadGroupListInBackground:(id)arg
{
    NSLog(@"reload groupList In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.factory.gateway.pDic = nil;
    NSMutableArray *list = [self.factory getRoomListWithSender:self];
    if (list != nil && [list count] != 0) {
        self.roomList = list;
        [self.roomList addObject:[[[RoomData alloc] init] autorelease]]; // 最後の空白行用
        [self.roomTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

@end
