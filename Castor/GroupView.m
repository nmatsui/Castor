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
@synthesize factory = _factory;
@synthesize indicator = _indicator;
@synthesize cellBuilder = _cellBuilder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.factory = factory;
        self.roomList = [self.factory getRoomListFromCache];
        self.cellBuilder = [[CellBuilder alloc] initWithDataFactory:self.factory];
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.indicator];
    }
    return self;
}

- (void)dealloc
{
    self.roomList = nil;
    self.roomTable = nil;
    self.factory = nil;
    self.indicator = nil;
    self.cellBuilder = nil;
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
        HomeView *homeView = [[[HomeView alloc] initWithNibName:@"HomeView" bundle:nil
                                                        factory:[[DataFactory alloc] init]] autorelease];
        [self.navigationController pushViewController:homeView animated:YES];
    }
    NSLog(@"GroupView Will appear");
    self.navigationController.navigationBar.hidden = NO;
    [self.roomTable deselectRowAtIndexPath:[self.roomTable indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GroupView loaded");
    self.title = @"Group";
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadGroupListInBackground:) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.roomList = nil;
    self.roomTable = nil;
    self.factory = nil;
    self.indicator = nil;
    self.cellBuilder = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        _portrate = NO;
        [self.roomTable reloadData];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown || interfaceOrientation == UIDeviceOrientationPortrait) {
        _portrate = YES;
        [self.roomTable reloadData];
    }
    return YES;
}

//// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.roomList count];
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
        [self.navigationController pushViewController:roomView animated:YES];
        [pool release];
    }
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadGroup");
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadGroupListInBackground:) withObject:nil];
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

- (IBAction)moveToHome:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to HomeView");
    HomeView *homeView = [[[HomeView alloc] initWithNibName:@"HomeView" bundle:nil 
                                                    factory:self.factory] autorelease];
    [self.navigationController pushViewController:homeView animated:NO];
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
