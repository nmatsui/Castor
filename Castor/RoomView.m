//
//  RoomView.m
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import "RoomView.h"

@interface RoomView (Private)
- (void)_reloadEntryListInBackground:(id)arg;
- (void)_nextPage:(id)sender;
- (void)_swipeHandler:(UISwipeGestureRecognizer *)gestureRecognizer;
- (void)_moveToCommentViewWithOriginEntry:(EntryData *)originEntry;
- (void)_updateEntryWithOriginEntry:(EntryData *)originEntry;
- (void)_deleteEntryWithOriginEntry:(EntryData *)originEntry;
- (void)_viewAttachmentWithOriginEntry:(EntryData *)originEntry;
- (void)_cancelWithOriginEntry:(EntryData *)originEntry;
@end

@implementation RoomView

@synthesize entryTable = _entryTable;
@synthesize entryList = _entryList;
@synthesize room = _room;
@synthesize target = _target;
@synthesize willDelete = _willDelete;
@synthesize selectors = _selectors;
@synthesize cellBuilder = _cellBuilder;
@synthesize triggerHeader = _triggerHeader;
@synthesize triggerFooter = _triggerFooter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 room:(RoomData *)room 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil factory:factory];
    if (self) {
        _page = 1;
        self.room = room;
        self.entryList = [self.factory getRoomEntryListFromCache:self.room.roomId];
        self.selectors = [[NSMutableArray alloc] init];
        self.cellBuilder = [[CellBuilder alloc] initWithDataFactory:self.factory];
        _headerON = NO;
        _footerON = NO;
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeHandler:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft + UISwipeGestureRecognizerDirectionRight;
        swipe.delegate = self;
        [self.entryTable addGestureRecognizer:swipe];
        [swipe release];
    }
    return self;
}

- (void)dealloc
{
    self.entryList = nil;
    self.entryTable = nil;
    self.room = nil;
    self.target = nil;
    self.willDelete = nil;
    self.selectors = nil;
    self.cellBuilder = nil;
    self.triggerHeader = nil;
    self.triggerFooter = nil;
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
    NSLog(@"RoomView Will appear");
    if (self.factory != nil) {
        [self.entryTable deselectRowAtIndexPath:[self.entryTable indexPathForSelectedRow] animated:YES];
        if (self.triggerHeader == nil) {
            self.triggerHeader = [self.cellBuilder getTriggerHeader:self.entryTable.bounds portrate:_portrate];
            [self.entryTable addSubview:self.triggerHeader];
        }
        if (self.triggerFooter == nil) {
            self.triggerFooter = [self.cellBuilder getTriggerFooter:self.entryTable.bounds portrate:_portrate];
            self.entryTable.tableFooterView = self.triggerFooter;
        }
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_reloadEntryListInBackground:) withObject:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"roomView[%@] loaded", self.room.roomId);
    self.title = @"Room";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.entryList = nil;
    self.entryTable = nil;
    self.room = nil;
    self.target = nil;
    self.willDelete = nil;
    self.selectors = nil;
    self.cellBuilder = nil;
    self.triggerHeader = nil;
    self.triggerFooter = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.entryTable reloadData];
    return YES;
}

//// UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.cellBuilder getRoomHeaderView:self.room
                                        target:nil 
                                        action:nil
                                       section:section
                                      portrate:_portrate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.entryList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellBuilder getEntryCellHeight:[self.entryList objectAtIndex:indexPath.row] portrate:_portrate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntryCell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    if ([self.entryList count] <= indexPath.row) return cell;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [cell.contentView addSubview:[self.cellBuilder getEntryCellView:[self.entryList objectAtIndex:indexPath.row] portrate:_portrate]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [pool release];
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"RoomView %d row tapped", indexPath.row);
    [self performSelector:@selector(_moveToCommentViewWithOriginEntry:) withObject:[self.entryList objectAtIndex:indexPath.row]];
}

//// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect r = self.entryTable.bounds;
    if ((r.origin.y < -1 * [self.cellBuilder getTriggerBounds]) && (_headerON == NO)) {
		_headerON = YES;
		[(UILabel *)[self.triggerHeader viewWithTag:1] setText:@"手を離すと更新"];
        UIImageView *imageView = (UIImageView *)[self.triggerHeader viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14);
		[UIView commitAnimations];
	}
	else if ((r.origin.y == 0) && (_headerON == YES)) {
		_headerON = NO;
		[(UILabel *)[self.triggerHeader viewWithTag:1] setText:@"プルダウンすると更新"];
        UIImageView *imageView = (UIImageView *)[self.triggerHeader viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_reloadEntryListInBackground:) withObject:nil];
	}
    
    
    double tableTail = r.origin.y + r.size.height;
    double triggerTail = self.triggerFooter.frame.origin.y + self.triggerFooter.frame.size.height;
    if ((tableTail > triggerTail + [self.cellBuilder getTriggerBounds]) && (_footerON == NO)) {
        _footerON = YES;
        [(UILabel *)[self.triggerFooter viewWithTag:1] setText:@"手を離すと次ページを表示"];
        UIImageView *imageView = (UIImageView *)[self.triggerFooter viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14);
		[UIView commitAnimations];
    }
    else if ((tableTail == triggerTail) && (_footerON == YES)) {
		_footerON = NO;
		[(UILabel *)[self.triggerFooter viewWithTag:1] setText:@"プルアップすると次ページを表示"];
        UIImageView *imageView = (UIImageView *)[self.triggerFooter viewWithTag:2];
		[UIView beginAnimations:nil context:nil];
		imageView.transform = CGAffineTransformIdentity;
		[UIView commitAnimations];
        [self _nextPage:self];
	}
}

//// UIAlertView Callback
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            NSLog(@"delete entry [%@]", self.willDelete.entryId);
            [self.factory deleteEntryByEntryId:self.willDelete.entryId roomId:self.room.roomId sender:self];
            [self performSelector:@selector(_startIndicator:) withObject:self];
            [self performSelectorInBackground:@selector(_reloadEntryListInBackground:) withObject:nil];
            break;
    }
}

//// UIActionSheet Callback
-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet button clicked[%d]", buttonIndex);
    if ([[self.selectors objectAtIndex:buttonIndex] hasPrefix:@"DetectedURL_"]) {
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[[self.selectors objectAtIndex:buttonIndex] stringByReplacingOccurrencesOfString:@"DetectedURL_" withString:@""]]];
    }
    else {
        [self performSelector:NSSelectorFromString([self.selectors objectAtIndex:buttonIndex]) withObject:self.target];
    }
    self.target = nil;
    [self.selectors removeAllObjects];
}

//// Reloadable
- (IBAction)reload:(id)sender
{
    NSLog(@"reloadRoom[%@]", self.room.roomId);
    _page = 1;
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadEntryListInBackground:) withObject:nil];
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
    NSLog(@"editEntry");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil 
                                                     roomId:self.room.roomId 
                                                   parentId:nil 
                                                targetEntry:nil 
                                               previousView:self
                                                    factory:self.factory] autorelease];
    [self.navigationController pushViewController:editView animated:YES];
    [pool release];
}

//// Private
- (void)_reloadEntryListInBackground:(id)arg
{
    NSLog(@"reload entryList[%@] In Background", self.room.roomId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableArray *timeline = [self.factory getRoomEntryListByRoomId:self.room.roomId page:_page sender:self];
    if (timeline != nil && [timeline count] != 0) {
        self.entryList = timeline;
        [self.entryTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

- (void)_nextPage:(id)sender
{
    _page++;
    NSLog(@"nextPage [%d]", _page);
    [self performSelector:@selector(_startIndicator:) withObject:self];
    [self performSelectorInBackground:@selector(_reloadEntryListInBackground:) withObject:nil];
}

- (void)_swipeHandler:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.entryTable];
    NSIndexPath *indexPath = [self.entryTable indexPathForRowAtPoint:p];
    if (indexPath != nil) {
        NSLog(@"RoomView %d row swiped",indexPath.row);
        [self.selectors removeAllObjects];
        if (self.target != nil) self.target = nil;
        self.target = [self.entryList objectAtIndex:indexPath.row];
        UIActionSheet *menu = [[UIActionSheet alloc] init];
        [menu setDelegate:self];
        
        // View Commentsボタンは必ず表示
        [menu addButtonWithTitle:@"View Comments"];
        [self.selectors addObject:@"_moveToCommentViewWithOriginEntry:"];
        
        // Updateボタンの表示判定
        if (self.room.admin || [self.room.myId intValue] == [self.target.participationId intValue]) {
            [menu addButtonWithTitle:@"Update"];
            [self.selectors addObject:@"_updateEntryWithOriginEntry:"];
        }
        
        // Deleteボタンの表示判定(RoomViewのエントリは全てrootエントリ)
        if (self.room.admin || [self.room.myId intValue] == [self.target.participationId intValue]) {
            [menu addButtonWithTitle:@"Delete"];
            [self.selectors addObject:@"_deleteEntryWithOriginEntry:"];
        }
        
        // View Attachmentボタンの表示判定
        if ([@"Text" isEqualToString:self.target.attachmentType] || [@"Image" isEqualToString:self.target.attachmentType] || [@"Link" isEqualToString:self.target.attachmentType]) {
            [menu addButtonWithTitle:@"View Attachment"];
            [self.selectors addObject:@"_viewAttachmentWithOriginEntry:"];
        }
        
        // URL遷移の表示判定
        for (NSString *url in self.target.urlList) {
            [menu addButtonWithTitle:url];
            [self.selectors addObject:[NSString stringWithFormat:@"DetectedURL_%@", url]];
        }
        
        // Cancelボタンは必ず表示
        [menu addButtonWithTitle:@"Cancel"];
        [self.selectors addObject:@"_cancelWithOriginEntry:"];
        
        [menu showInView:self.view];
        [menu release];
    }
}

- (void)_moveToCommentViewWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"move to CommentView");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CommentView *commentView = [[[CommentView alloc] initWithNibName:@"CommentView" 
                                                              bundle:nil 
                                                                room:self.room 
                                                         originEntry:originEntry 
                                                        previousView:self 
                                                             factory:self.factory] autorelease];
    [self.navigationController pushViewController:commentView animated:YES];
    [pool release];
}

- (void)_updateEntryWithOriginEntry:(EntryData *)originEntry
{   
    NSLog(@"update entry [%@]", originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to EditView");
    EditView *editView = [[[EditView alloc] initWithNibName:@"EditView" bundle:nil 
                                                     roomId:self.room.roomId 
                                                   parentId:nil 
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
    [alert release];
}

- (void)_viewAttachmentWithOriginEntry:(EntryData *)originEntry
{
    NSLog(@"View Attachment [%@]", originEntry.entryId);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if ([@"Text" isEqualToString:originEntry.attachmentType]) {
        NSLog(@"move to LongTextView");
        LongTextView *longTextView = [[[LongTextView alloc] initWithNibName:@"LongTextView" bundle:nil 
                                                                      entry:originEntry
                                                                    factory:self.factory] autorelease];
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
    [self.entryTable deselectRowAtIndexPath:[self.entryTable indexPathForSelectedRow] animated:YES];
}

@end
