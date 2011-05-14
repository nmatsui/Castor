//
//  CommentView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentView.h"

@interface CommentView (Private)
- (void)_startIndicator:(id)sender;
- (void)_reloadCommentListInBackground:(id)arg;
- (void)_addEntryWithOriginEntry:(EntryData *)originEntry;
- (void)_updateEntryWithOriginEntry:(EntryData *)originEntry;
- (void)_deleteEntryWithOriginEntry:(EntryData *)originEntry;
- (void)_viewAttachmentWithOriginEntry:(EntryData *)originEntry;
- (void)_cancelWithOriginEntry:(EntryData *)originEntry;
@end

@implementation CommentView

@synthesize entryTable = _entryTable;
@synthesize entryList = _entryList;
@synthesize factory = _factory;
@synthesize room = _room;
@synthesize originEntry = _originEntry;
@synthesize target = _target;
@synthesize willDelete = _willDelete;
@synthesize selectors = _selectors;
@synthesize previousView = _previousView;
@synthesize indicator = _indicator;
@synthesize cellBuilder = _cellBuilder;

static const int MAX_LEVLE = 6;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 room:(RoomData *)room 
          originEntry:(EntryData *)originEntry 
         previousView:(UIViewController <Reloadable> *)previousView 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.room = room;
        self.originEntry = originEntry;
        self.previousView = previousView;
        self.factory = factory;
        self.selectors = [[NSMutableArray alloc] init];
        self.cellBuilder = [[CellBuilder alloc] init];
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.indicator];
    }
    return self;
}

- (void)dealloc
{
    self.entryList = nil;
    self.entryTable = nil;
    self.factory = nil;
    self.room = nil;
    self.originEntry = nil;
    self.target = nil;
    self.willDelete = nil;
    self.selectors = nil;
    self.indicator = nil;
    self.previousView = nil;
    self.cellBuilder = nil;
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
    NSLog(@"commentView loaded[%@]", self.originEntry.entryId);
    self.title = @"Comments";
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadCommentListInBackground:) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.entryList = nil;
    self.entryTable = nil;
    self.factory = nil;
    self.room = nil;
    self.originEntry = nil;
    self.target = nil;
    self.willDelete = nil;
    self.selectors = nil;
    self.indicator = nil;
    self.previousView = nil;
    self.cellBuilder = nil;
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

//// UITableViewDelegate
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
        return [self.cellBuilder getEntryCellHeight:self.view.window.screen.bounds.size entry:[self.entryList objectAtIndex:indexPath.row] portrate:_portrate];
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
        [cell.contentView addSubview:[self.cellBuilder getEntryCellView:self.view.window.screen.bounds.size entry:entry portrate:_portrate]];
        if (indexPath.row != 0 && [entry.level intValue] < MAX_LEVLE) {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        [pool release];
    }
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CommentView %d row clicked",indexPath.row);
    if (indexPath.row < [self.entryList count] - 1) {
        [self.selectors removeAllObjects];
        if (self.target != nil) self.target = nil;
        self.target = [self.entryList objectAtIndex:indexPath.row];
        UIActionSheet *menu = [[UIActionSheet alloc] init];
        [menu setDelegate:self];
        
        // Add Commentボタンの表示判定
        if (indexPath.row != 0 && [self.target.level intValue] < MAX_LEVLE) {
            [menu addButtonWithTitle:@"Add Comment"];
            [self.selectors addObject:@"_addEntryWithOriginEntry:"];
        }
        
        // Updateボタンの表示判定
        if (self.room.admin || [self.room.myId intValue] == [self.target.participationId intValue]) {
            [menu addButtonWithTitle:@"Update"];
            [self.selectors addObject:@"_updateEntryWithOriginEntry:"];
        }
        
        // Delteボタンの表示判定
        if (self.room.admin || [self.room.myId intValue] == [self.target.participationId intValue]) {
            if ([self.target.entryId intValue] == [self.target.rootId intValue] || self.target.children == nil || [self.target.children count] == 0) {
                [menu addButtonWithTitle:@"Delete"];
                [self.selectors addObject:@"_deleteEntryWithOriginEntry:"];
            }
        }
        
        // View Attachmentボタンの表示判定
        if ([@"Text" isEqualToString:self.target.attachmentType] || [@"Image" isEqualToString:self.target.attachmentType] || [@"Link" isEqualToString:self.target.attachmentType]) {
            [menu addButtonWithTitle:@"View Attachment"];
            [self.selectors addObject:@"_viewAttachmentWithOriginEntry:"];
        }
        
        // Cancelボタンは必ず表示
        [menu addButtonWithTitle:@"Cancel"];
        [self.selectors addObject:@"_cancelWithOriginEntry:"];
        
        
        [menu showInView:self.view];
        [menu release];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory button clicked[%d]", indexPath.row);
    [self performSelector:@selector(_addEntryWithOriginEntry:) withObject:[self.entryList objectAtIndex:indexPath.row]];
}

//// UIAlertView Callback
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            NSLog(@"delete entry [%@]", self.willDelete.entryId);
            BOOL rootFlg = NO;
            if ([self.willDelete.entryId intValue] == [self.willDelete.rootId intValue]) {
                rootFlg = YES;
            }
            [self.factory deleteEntryByEntryId:self.willDelete.entryId roomId:self.room.roomId sender:self];
            [self performSelector:@selector(_startIndicator:) withObject:self];
            if (rootFlg) {
                [self.previousView reload:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self performSelectorInBackground:@selector(_reloadCommentListInBackground:) withObject:nil];
            }
            break;
    }
}

//// UIActionSheet Callback
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet button clicked[%d]", buttonIndex);
    [self performSelector:NSSelectorFromString([self.selectors objectAtIndex:buttonIndex]) withObject:self.target];
    self.target = nil;
    [self.selectors removeAllObjects];
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadComment[%@]", self.originEntry.entryId);
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadCommentListInBackground:) withObject:nil];
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

- (IBAction)addEntry:(id)sender
{
    [self performSelector:@selector(_addEntryWithOriginEntry:) withObject:self.originEntry];
}

//// Private
- (void)_startIndicator:(id)sender
{
    CGRect viewSize = self.view.bounds;
    [self.indicator setFrame:CGRectMake(viewSize.size.width/2-25, viewSize.size.height/2-25, 50, 50)];
    [self.indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_reloadCommentListInBackground:(id)arg
{
    NSLog(@"reload CommentList [%@] In Background", self.originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [self.factory getEntryCommentListByEntryData:self.originEntry sender:self];
    [self.entryList addObject:[[[EntryData alloc] init] autorelease]]; // 最後の空白行用
    [self.entryTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

- (void)_addEntryWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"editEntry");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil 
                                                     roomId:self.originEntry.roomId 
                                                   parentId:originEntry.entryId 
                                                targetEntry:nil 
                                               previousView:self 
                                                    factory:self.factory] autorelease];
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
}

- (void)_updateEntryWithOriginEntry:(EntryData *)originEntry
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setTitle:@"更新できません"];
    [alert setMessage:@"更新APIがまだ提供されていません"];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    [alert release];
    
    NSLog(@"update entry [%@]", originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil 
                                                     roomId:self.originEntry.roomId 
                                                   parentId:originEntry.entryId 
                                                targetEntry:originEntry 
                                               previousView:self 
                                                    factory:self.factory] autorelease];
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
}

- (void)_deleteEntryWithOriginEntry:(EntryData *)originEntry
{
    self.willDelete = originEntry;
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.delegate = self;
    alert.title = @"確認";
    alert.message = @"削除してもよろしいですか？";
    [alert addButtonWithTitle:@"いいえ"];
    [alert addButtonWithTitle:@"はい"];
    [alert show];
}

- (void)_viewAttachmentWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"View Attachment [%@]", originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([@"Text" isEqualToString:originEntry.attachmentType]) {
        NSLog(@"move to LongTextView");
        LongTextView *longTextView = [[[LongTextView alloc] initWithNibName:@"LongTextView" bundle:nil 
                                                                      entry:originEntry] autorelease];
        [self.navigationController pushViewController:longTextView animated:YES];
    }
    else if ([@"Image" isEqualToString:originEntry.attachmentType]) {
        NSLog(@"move to ImageView");
        ImageView *imageView = [[[ImageView alloc] initWithNibName:@"ImageView" bundle:nil 
                                                             entry:originEntry 
                                                           factory:self.factory] autorelease];
        [self.navigationController pushViewController:imageView animated:YES];
    }
    else if ([@"Link" isEqualToString:self.target.attachmentType]) {
        NSLog(@"open safari with url[%@]", originEntry.attachmentURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.target.attachmentURL]];
    }
    [pool release];
}

- (void)_cancelWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"cancel entry [%@]", originEntry.entryId);
}

@end
