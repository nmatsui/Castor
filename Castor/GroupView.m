//
//  GroupView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupView.h"


@implementation GroupView

@synthesize factory;

@synthesize groupTable;
@synthesize groupList;
@synthesize groupCell;

-(IBAction) reloadGroup:(id)sender
{
    NSLog(@"reloadGroup");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.groupList = [factory getGroupList];
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
    
    self.groupList = nil;
    self.groupTable = nil;
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
    return [groupList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
		cell = groupCell;
		self.groupCell = nil;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    GroupCell *gcell = (GroupCell *)cell;
    gcell.groupName.text = [[groupList objectAtIndex:indexPath.row] roomName];
    return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GroupView Loaded");
    self.title = @"Group";
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    if (self.factory == nil) {
        self.factory = [[DataFactory alloc] init];
    }
    [self reloadGroup:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    
    self.groupList = nil;
    self.groupTable = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
