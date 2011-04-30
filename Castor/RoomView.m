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
@synthesize roomId;

@synthesize entryTable;
@synthesize entryList;

- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setFrame:rect];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:UITextAlignmentLeft];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    return label;
}

- (IBAction)reloadRoom:(id)sender
{
    NSLog(@"reloadRoom");
    NSLog(@"roomId : %d", [self.roomId intValue]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getRoomEntryListByRoomId:self.roomId];
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
    self.roomId = nil;
    
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
    EntryData *entry = [entryList objectAtIndex:indexPath.row];
    float w = (portrate)?
                self.view.window.screen.bounds.size.width - 70:
                self.view.window.screen.bounds.size.height - 70;
    CGSize size = [entry.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 30 + size.height + 10;
    return (height<60)?60:height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([entryList count] <= indexPath.row) return cell;
    EntryData *entry = [entryList objectAtIndex:indexPath.row];
    UILabel *nameLabel = [self makeLabel:CGRectMake(60, 10, 250, 16) text:entry.name font:[UIFont boldSystemFontOfSize:12]];
    [cell.contentView addSubview:nameLabel];
    float w = (portrate)?
    self.view.window.screen.bounds.size.width - 70:
    self.view.window.screen.bounds.size.height - 70;
    CGSize size = [entry.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *contentLabel = [self makeLabel:CGRectMake(60, 30, w, size.height) text:entry.content font:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:contentLabel];
    return cell;    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"roomView loaded");
    NSLog(@"roomId : %d", [self.roomId intValue]);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.entryList = [factory getRoomEntryListByRoomId:self.roomId];
    [pool release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.roomId = nil;
    
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
