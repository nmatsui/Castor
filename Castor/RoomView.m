//
//  RoomView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoomView.h"


@implementation RoomView

@synthesize factory;
@synthesize group;

@synthesize entryTable;
@synthesize entryList;

- (IBAction)reloadRoom:(id)sender
{
    NSLog(@"reloadRoom");
    NSLog(@"roomId : %d", [self.group.roomId intValue]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getRoomEntryListByRoomId:self.group.roomId];
    [pool release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.factory = nil;
    self.group = nil;
    
    self.entryList = nil;
    self.entryTable = nil;
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
    return [entryList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ViewUtil getEntryCellHeight:self.view.window.screen.bounds.size entry:[entryList objectAtIndex:indexPath.row] portrate:portrate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([entryList count] <= indexPath.row) return cell;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [cell.contentView addSubview:[ViewUtil getEntryCellView:self.view.window.screen.bounds.size entry:[entryList objectAtIndex:indexPath.row] portrate:portrate]];
    [pool release];
    return cell;    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"roomView loaded");
    NSLog(@"roomId : %d", [self.group.roomId intValue]);
    self.title = self.group.roomName;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getRoomEntryListByRoomId:self.group.roomId];
    [pool release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.group = nil;
    
    self.entryList = nil;
    self.entryTable = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        portrate = NO;
        [entryTable reloadData];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown || interfaceOrientation == UIDeviceOrientationPortrait) {
        portrate = YES;
        [entryTable reloadData];
    }
    return YES;
}

@end
