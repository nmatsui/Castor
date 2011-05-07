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
@synthesize room = _room;
@synthesize originEntry = _originEntry;

@synthesize entryTable = _entryTable;
@synthesize entryList = _entryList;

@synthesize target = _target;
@synthesize willDelete = _willDelete;
@synthesize selectors = _selectors;

@synthesize previousView = _previousView;

@synthesize indicator = _indicator;

static const int MAX_LEVLE = 6;

- (void)alertException:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setMessage:message];
    [alert addButtonWithTitle:@"OK"];
	[alert show];
	[alert release];
}

- (void)addEntryWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"editEntry");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil] autorelease];
    editView.factory = self.factory;
    editView.roomId = self.originEntry.roomId;
    editView.parentId = originEntry.entryId;
    editView.targetEntry = nil;
    editView.previousView = self;
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
}

- (void)viewAttachmentWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"View Attachment [%@]", originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([@"Text" isEqualToString:originEntry.attachmentType]) {
        NSLog(@"move to LongTextView");
        LongTextView *longTextView = [[[LongTextView alloc] initWithNibName:@"LongTextView" bundle:nil] autorelease];
        longTextView.entry = originEntry;
        [self.navigationController pushViewController:longTextView animated:YES];
    }
    else if ([@"Image" isEqualToString:originEntry.attachmentType]) {
        NSLog(@"move to ImageView");
        ImageView *imageView = [[[ImageView alloc] initWithNibName:@"ImageView" bundle:nil] autorelease];
        imageView.factory = self.factory;
        imageView.entry = originEntry;
        [self.navigationController pushViewController:imageView animated:YES];
    }
    else if ([@"Link" isEqualToString:self.target.attachmentType]) {
        NSLog(@"open safari with url[%@]", originEntry.attachmentURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.target.attachmentURL]];
    }
    [pool release];
}

- (void)updateEntryWithOriginEntry:(EntryData *)originEntry
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setTitle:@"更新できません"];
    [alert setMessage:@"更新APIがまだ提供されていません"];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    [alert release];
    
//    NSLog(@"update entry [%@]", originEntry.entryId);
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSLog(@"move to EditView");
//    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil] autorelease];
//    editView.factory = self.factory;
//    editView.roomId = self.originEntry.roomId;
//    editView.parentId = originEntry.entryId;
//    editView.targetEntry = originEntry;
//    editView.previousView = self;
//    [self.navigationController pushViewController:editView animated:YES];
//    [pool release];
}

- (void)deleteEntryWithOriginEntry:(EntryData *)originEntry
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
            [self performSelector:@selector(startIndicator:) withObject:self];
            if (rootFlg) {
                [self.previousView reload:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self performSelectorInBackground:@selector(reloadCommentListInBackground:) withObject:nil];
            }
            break;
    }
}

- (void)cancelWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"cancel entry [%@]", originEntry.entryId);
}

- (void)startIndicator:(id)sender
{
    CGRect viewSize = self.view.bounds;
    [self.indicator setFrame:CGRectMake(viewSize.size.width/2-25, viewSize.size.height/2-25, 50, 50)];
    [self.indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)reloadCommentListInBackground:(id)arg
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

- (IBAction)callSetting:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to SettingView");
    SettingView *settingView = [[[SettingView alloc] initWithNibName:@"SettingView" bundle:nil] autorelease];
    settingView.factory = self.factory;
    [self.navigationController pushViewController:settingView animated:YES];
    [pool release];
}

- (IBAction)addEntry:(id)sender
{
    [self performSelector:@selector(addEntryWithOriginEntry:) withObject:self.originEntry];
}

- (IBAction)reload:(id)sender
{
    NSLog(@"reloadComment[%@]", self.originEntry.entryId);
    [self performSelector:@selector(startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(reloadCommentListInBackground:) withObject:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectors = [[NSMutableArray alloc] init];
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.indicator];
    }
    return self;
}

- (void)dealloc
{
    self.factory = nil;
    self.room = nil;
    self.originEntry = nil;
    
    self.entryList = nil;
    self.entryTable = nil;
    self.target = nil;
    self.selectors = nil;
    self.indicator = nil;
    self.previousView = nil;
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
            [self.selectors addObject:@"addEntryWithOriginEntry:"];
        }
        
        // Updateボタンの表示判定
        if (self.room.admin || [self.room.myId intValue] == [self.target.participationId intValue]) {
            [menu addButtonWithTitle:@"Update"];
            [self.selectors addObject:@"updateEntryWithOriginEntry:"];
        }
        
        // Delteボタンの表示判定
        if (self.room.admin || [self.room.myId intValue] == [self.target.participationId intValue]) {
            if ([self.target.entryId intValue] == [self.target.rootId intValue] || self.target.children == nil || [self.target.children count] == 0) {
                [menu addButtonWithTitle:@"Delete"];
                [self.selectors addObject:@"deleteEntryWithOriginEntry:"];
            }
        }
        
        // View Attachmentボタンの表示判定
        if ([@"Text" isEqualToString:self.target.attachmentType] || [@"Image" isEqualToString:self.target.attachmentType] || [@"Link" isEqualToString:self.target.attachmentType]) {
            [menu addButtonWithTitle:@"View Attachment"];
            [self.selectors addObject:@"viewAttachmentWithOriginEntry:"];
        }
        
        // Cancelボタンは必ず表示
        [menu addButtonWithTitle:@"Cancel"];
        [self.selectors addObject:@"cancelWithOriginEntry:"];
        
        
        [menu showInView:self.view];
        [menu release];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"accessory button clicked[%d]", indexPath.row);
    [self performSelector:@selector(addEntryWithOriginEntry:) withObject:[self.entryList objectAtIndex:indexPath.row]];
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet button clicked[%d]", buttonIndex);
    [self performSelector:NSSelectorFromString([self.selectors objectAtIndex:buttonIndex]) withObject:self.target];
    self.target = nil;
    [self.selectors removeAllObjects];
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
    [self performSelector:@selector(startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(reloadCommentListInBackground:) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.room = nil;
    self.originEntry = nil;
    
    self.entryList = nil;
    self.entryTable = nil;
    
    self.target = nil;
    self.previousView = nil;
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
