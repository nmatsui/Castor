//
//  CommentView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentView.h"


@implementation CommentView

@synthesize factory = _factory;
@synthesize originEntry = _originEntry;

@synthesize entryTable = _entryTable;
@synthesize entryList = _entryList;

static const int MAX_LEVLE = 6;

- (void)reloadCommentListInBackground:(id)arg
{
    NSLog(@"reload CommentList [%@] In Background", self.originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [self.factory getEntryCommentListByEntryData:self.originEntry];
    [self.entryList addObject:[[[EntryData alloc] init] autorelease]]; // 最後の空白行用
    [self.entryTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

- (IBAction)callSetting:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to SettingView");
    SettingView *settingView = [[[SettingView alloc] initWithNibName:@"SettingView" bundle:nil] autorelease];
    settingView.factory = self.factory;
    [self.navigationController pushViewController:settingView animated:YES];
    [pool release];
}

- (IBAction)editEntry:(id)sender
{
    NSLog(@"editEntry");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil] autorelease];
    editView.factory = self.factory;
    editView.roomId = self.originEntry.roomId;
    editView.originEntry = self.originEntry;
    editView.previousView = self;
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
}

- (IBAction)reload:(id)sender
{
    NSLog(@"reloadComment[%@]", self.originEntry.entryId);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(reloadCommentListInBackground:) withObject:nil];
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
    return [self.entryList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.entryList count] - 1) {
        return [ViewUtil getEntryCellHeight:self.view.window.screen.bounds.size entry:[self.entryList objectAtIndex:indexPath.row] portrate:_portrate];
    }
    else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([self.entryList count] <= indexPath.row) return cell;
    
    if (indexPath.row < [self.entryList count] - 1) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        EntryData *entry = [self.entryList objectAtIndex:indexPath.row];
        [cell.contentView addSubview:[ViewUtil getEntryCellView:self.view.window.screen.bounds.size entry:entry portrate:_portrate]];
        if (indexPath.row != 0 && [entry.level intValue] < MAX_LEVLE) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        [pool release];
    }
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"GroupView %d row clicked",indexPath.row);
    if (indexPath.row < [self.entryList count] - 1) {
        EntryData *entry = [self.entryList objectAtIndex:indexPath.row];
        if (indexPath.row != 0 && [entry.level intValue] < MAX_LEVLE) {
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSLog(@"move to RoomView");
            EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil] autorelease];
            editView.factory = self.factory;
            editView.roomId = self.originEntry.roomId;
            editView.originEntry = [self.entryList objectAtIndex:indexPath.row];
            editView.previousView = self;
            [self.navigationController pushViewController:editView animated:YES];
            [pool release];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"commentView loaded[%@]", self.originEntry.entryId);
    self.title = @"Comments";
    if (self.factory == nil) {
        self.factory = [[DataFactory alloc] init];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(reloadCommentListInBackground:) withObject:nil];
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
        _portrate = NO;
        [self.entryTable reloadData];
    }
    else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown || interfaceOrientation == UIDeviceOrientationPortrait) {
        _portrate = YES;
        [self.entryTable reloadData];
    }
    return YES;
}

@end
