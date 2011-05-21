//
//  HomeView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeView.h"

@interface HomeView (Private)
- (void)headerClick:(id)sender;

@end

@implementation HomeView

@synthesize homeTable = _homeTable;
@synthesize homeList = _homeList;
@synthesize factory = _factory;
@synthesize cellBuilder = _cellBuilder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.factory = factory;
        self.cellBuilder = [[CellBuilder alloc] initWithDataFactory:self.factory];
        
        self.homeList = [[NSMutableArray alloc] init];
        
        EntryData *entry11 = [[EntryData alloc] init];
        entry11.entryId = [[NSNumber alloc] initWithInt:11];
        entry11.participationName = @"name11";
        entry11.content = @"entry11";
        entry11.level = 0;
        
        EntryData *entry12 = [[EntryData alloc] init];
        entry12.entryId = [[NSNumber alloc] initWithInt:12];
        entry12.participationName = @"name12";
        entry12.content = @"entry12";
        entry12.level = 0;
        
        EntryData *entry13 = [[EntryData alloc] init];
        entry13.entryId = [[NSNumber alloc] initWithInt:123];
        entry13.participationName = @"name13";
        entry13.content = @"entry13wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww";
        entry13.level = 0;
        
        RoomData *room1 = [[RoomData alloc] init];
        room1.roomId = [[NSNumber alloc] initWithInt:1];
        room1.roomName = @"room1";
        room1.entries = [[NSMutableArray alloc] initWithObjects:entry11, entry12, entry13, nil];
        
        [self.homeList addObject:room1];
        
        EntryData *entry21 = [[EntryData alloc] init];
        entry21.entryId = [[NSNumber alloc] initWithInt:21];
        entry21.participationName = @"name21";
        entry21.content = @"entry21";
        entry21.level = 0;
        
        EntryData *entry22 = [[EntryData alloc] init];
        entry22.entryId = [[NSNumber alloc] initWithInt:22];
        entry22.participationName = @"name22";
        entry22.content = @"entry22";
        entry22.level = 0;
        
        EntryData *entry23 = [[EntryData alloc] init];
        entry23.entryId = [[NSNumber alloc] initWithInt:23];
        entry23.participationName = @"name23";
        entry23.content = @"entry23";
        entry23.level = 0;
        
        EntryData *entry24 = [[EntryData alloc] init];
        entry24.entryId = [[NSNumber alloc] initWithInt:24];
        entry24.participationName = @"name24";
        entry24.content = @"entry24;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        entry24.level = 0;
        
        EntryData *entry25 = [[EntryData alloc] init];
        entry25.entryId = [[NSNumber alloc] initWithInt:25];
        entry25.participationName = @"name25";
        entry25.content = @"entry25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
        entry25.level = 0;
        
        RoomData *room2 = [[RoomData alloc] init];
        room2.roomId = [[NSNumber alloc] initWithInt:2];
        room2.roomName = @"room2";
        room2.entries = [[NSMutableArray alloc] initWithObjects:entry21, entry22, entry23, entry24, entry25, nil];
        
        [self.homeList addObject:room2];
        
        [[[self.homeList objectAtIndex:[self.homeList count] - 1] entries] addObject:[[EntryData alloc] init]];
        
    }
    return self;
}

- (void)dealloc
{
    self.homeTable = nil;
    self.homeList = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.homeTable = nil;
    self.homeList = nil;
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
    NSLog(@"GroupView %d row tapped",indexPath.row);    
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadHome");
//    [self performSelector:@selector(_startIndicator:) withObject:self];
//    [self performSelectorInBackground:@selector(_reloadGroupListInBackground:) withObject:nil];
    GroupView *groupView = [[[GroupView alloc] initWithNibName:@"GroupView" bundle:nil
                                                    factory:self.factory] autorelease];
    [self.navigationController pushViewController:groupView animated:YES];
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

//// Private
- (void)headerClick:(id)sender
{
    NSLog(@"headerClick %d", [sender tag]);
}

@end
