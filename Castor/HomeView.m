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
- (void)headerClick:(id)sender;
@end

@implementation HomeView

@synthesize homeTable = _homeTable;
@synthesize homeList = _homeList;
@synthesize factory = _factory;
@synthesize cellBuilder = _cellBuilder;
@synthesize indicator = _indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.factory = factory;
        self.homeList = [self.factory getHomeTimelineFromCache];
        self.cellBuilder = [[CellBuilder alloc] initWithDataFactory:self.factory];
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
    return [self.cellBuilder getSectionHeaderView:self.view.window.screen.bounds.size 
                                             room:[self.homeList objectAtIndex:section] 
                                           target:self 
                                           action:@selector(headerClick:) 
                                          section:section
                                         portrate:_portrate];
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    RoomData *room = [self.homeList objectAtIndex:section];
//    return room.roomName;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.homeList objectAtIndex:section] entries] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.homeList count] - 1 || indexPath.row < [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 1) {
        return [self.cellBuilder getEntryCellHeight:self.view.window.screen.bounds.size entry:[[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row] portrate:_portrate];
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
    
    if (indexPath.section != [self.homeList count] - 1 || indexPath.row != [[[self.homeList objectAtIndex:indexPath.section] entries] count] - 1) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        EntryData *entry = [[[self.homeList objectAtIndex:indexPath.section] entries] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:[self.cellBuilder getEntryCellView:self.view.window.screen.bounds.size entry:entry portrate:_portrate]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [pool release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"HomeView %d section %d row tapped", indexPath.section, indexPath.row);    
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadHome");
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
    NSMutableArray *list = [self.factory getHomeTimelineWithSender:self];
    if (list != nil && [list count] != 0) {
        self.homeList = list;
        [[[self.homeList objectAtIndex:[self.homeList count] - 1] entries] addObject:[[[EntryData alloc] init] autorelease]]; // 最後の空白行用
        [self.homeTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

- (void)headerClick:(id)sender
{
    NSLog(@"headerClick %d", [sender tag]);
}

@end
