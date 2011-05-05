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

static const double singleTapDelay = 0.2;

- (void)reloadEntryListInBackground:(id)arg
{
    NSLog(@"reload entryList[%@] In Background", self.group.roomId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [self.factory getRoomEntryListByRoomId:self.group.roomId page:page];
    [self.entryList addObject:[[[EntryData alloc] init] autorelease]]; // <<load next page>>用
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
    editView.originEntry = nil;
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
}

- (IBAction)reloadRoom:(id)sender
{
    NSLog(@"reloadRoom[%@]", self.group.roomId);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(reloadEntryListInBackground:) withObject:nil];
}

- (void)nextPage:(id)sender
{
    page++;
    NSLog(@"nextPage [%d]", page);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(reloadEntryListInBackground:) withObject:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        page = 1;
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
    if (indexPath.row < [entryList count] - 2 ) {
        return [ViewUtil getEntryCellHeight:self.view.window.screen.bounds.size entry:[entryList objectAtIndex:indexPath.row] portrate:portrate];
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
    if ([entryList count] <= indexPath.row) return cell;
    
    if (indexPath.row < [entryList count] - 2) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [cell.contentView addSubview:[ViewUtil getEntryCellView:self.view.window.screen.bounds.size entry:[entryList objectAtIndex:indexPath.row] portrate:portrate]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [pool release];
    }
    else if (indexPath.row == [entryList count] - 2) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [cell.contentView addSubview:[ViewUtil getNextPageCellView:self.view.window.screen.bounds.size portrate:portrate]];
        [pool release];
    }

    return cell;    
}

- (void)singleTapAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"single Tapped at %d", indexPath.row);
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
    NSLog(@"double Tapped at %d", indexPath.row);
    tapCount = 0;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EntryData *entry = [self.entryList objectAtIndex:indexPath.row];
    if ([@"Text" isEqualToString:entry.attachmentType]) {
        NSLog(@"move to LongTextView");
        LongTextView *longTextView = [[[LongTextView alloc] initWithNibName:@"LongTextView" bundle:nil] autorelease];
        longTextView.entry = entry;
        [self.navigationController pushViewController:longTextView animated:YES];
    }
    else if ([@"Image" isEqualToString:entry.attachmentType]) {
        NSLog(@"move to ImageView");
        ImageView *imageView = [[[ImageView alloc] initWithNibName:@"ImageView" bundle:nil] autorelease];
        imageView.entry = entry;
        [self.navigationController pushViewController:imageView animated:YES];
    }
    [pool release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"RoomView %d row tapped",indexPath.row);
    
    if (indexPath.row < [entryList count] - 2) {
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
    else if (indexPath.row == [entryList count] - 2) {
        [self nextPage:self];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"roomView[%@] loaded", self.group.roomId);
    self.title = @"Room";
    if (self.factory == nil) {
        self.factory = [[DataFactory alloc] init];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(reloadEntryListInBackground:) withObject:nil];
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
