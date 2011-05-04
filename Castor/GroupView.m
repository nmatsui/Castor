//
//  GroupView2.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupView.h"


@implementation GroupView

@synthesize factory = _factory;

@synthesize groupTable = _groupTable;
@synthesize groupList = _groupList;

- (IBAction)callSetting:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to SettingView");
    SettingView *settingView = [[[SettingView alloc] initWithNibName:@"SettingView" bundle:nil] autorelease];
    settingView.factory = self.factory;
    [self.navigationController pushViewController:settingView animated:YES];
    [pool release];
}

- (IBAction)reloadGroup:(id)sender
{
    [self.groupTable reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.factory = nil;
    
    self.groupList = nil;
    self.groupTable = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groupList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ViewUtil getGroupCellHeight:self.view.window.screen.bounds.size group:[self.groupList objectAtIndex:indexPath.row] portrate:portrate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if ([self.groupList count] <= indexPath.row) return cell;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    GroupData *group = [self.groupList objectAtIndex:indexPath.row];
    NSLog(@"%d=>%@", [group.roomId intValue], group.roomName);
    [cell.contentView addSubview:[ViewUtil getGroupCellView:self.view.window.screen.bounds.size group:group portrate:portrate]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [pool release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"GroupView %d row clicked",indexPath.row);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to RoomView");
    RoomView *roomView = [[[RoomView alloc] initWithNibName:@"RoomView" bundle:nil] autorelease];
    roomView.factory = self.factory;
    roomView.group = [self.groupList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:roomView animated:YES];
    [pool release];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"GroupView Will appear");
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GroupView Loaded");
    self.title = @"Group";
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.groupList = [self.factory getGroupList];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    
    self.groupList = nil;
    self.groupTable = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        portrate = NO;
        [self.groupTable reloadData];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown || interfaceOrientation == UIDeviceOrientationPortrait) {
        portrate = YES;
        [self.groupTable reloadData];
    }
    return YES;
}

@end
