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

static double singleTapDelay = 0.2;

- (IBAction)reloadRoom:(id)sender
{
    NSLog(@"reloadRoom");
    NSLog(@"roomId : %d", [self.group.roomId intValue]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getRoomEntryListByRoomId:self.group.roomId];
    [entryTable reloadData];
    [pool release];
}

- (IBAction)editEntry:(id)sender
{
    NSLog(@"editEntry");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil] autorelease];
    editView.factory = self.factory;
    editView.originEntry = nil;
    [self.navigationController pushViewController:editView animated:YES];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section) {
        case 0: return self.group.roomName;
        default: return nil;
    }
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [pool release];
    return cell;    
}

- (void)singleTapAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"single Tap at %d", indexPath.row);
    tapCount = 0;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to CommentView");
    CommentView *commentView = [[[CommentView alloc] initWithNibName:@"CommentView" bundle:nil] autorelease];
    commentView.factory = self.factory;
    commentView.originEntry = [self.entryList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:commentView animated:YES];
    [pool release];
}

- (void)doubleTapAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"double Tap at %d", indexPath.row);
    tapCount = 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"RoomView %d row tapped",indexPath.row);
    selectedRow = indexPath;
    tapCount++;
    
    switch (tapCount)
    {
        case 1: //single tap
            [self performSelector:@selector(singleTapAtIndexPath:) withObject:indexPath afterDelay:singleTapDelay];
            break;
        case 2: //double tap
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAtIndexPath:) object:indexPath];
            [self performSelector:@selector(doubleTapAtIndexPath:) withObject:indexPath];
            break;
        default:
            break;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"roomView loaded");
    NSLog(@"roomId : %d", [self.group.roomId intValue]);
    self.title = @"Room";
    if (self.factory == nil) {
        self.factory = [[DataFactory alloc] init];
    }
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