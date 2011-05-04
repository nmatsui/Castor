//
//  CommentView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentView.h"


@implementation CommentView

@synthesize factory;
@synthesize originEntry;

@synthesize entryTable;
@synthesize entryList;

static const int MAX_LEVLE = 5;

- (IBAction)reloadComments:(id)sender
{
    NSLog(@"reloadComments");
    NSLog(@"originEntryId : %d", [self.originEntry.entryId intValue]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getEntryCommentListByEntryId:self.originEntry.entryId];
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
    editView.originEntry = self.originEntry;
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
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
    self.originEntry = nil;
    
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
    EntryData *entry = [entryList objectAtIndex:indexPath.row];
    [cell.contentView addSubview:[ViewUtil getEntryCellView:self.view.window.screen.bounds.size entry:entry portrate:portrate]];
    if ([entry.level intValue] < MAX_LEVLE) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    [pool release];
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"GroupView %d row clicked",indexPath.row);
    EntryData *entry = [entryList objectAtIndex:indexPath.row];
    if ([entry.level intValue] < MAX_LEVLE) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSLog(@"move to RoomView");
        EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil] autorelease];
        editView.factory = self.factory;
        editView.originEntry = [self.entryList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:editView animated:YES];
        [pool release];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"commentView loaded");
    NSLog(@"origin entryId : %d", [self.originEntry.entryId intValue]);
    self.title = @"Comments";
    if (self.factory == nil) {
        self.factory = [[DataFactory alloc] init];
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getEntryCommentListByEntryId:self.originEntry.entryId];
    [pool release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.originEntry = nil;
    
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
