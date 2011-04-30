//
//  GroupView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupView.h"


@implementation GroupView

@synthesize groupTable;
@synthesize groupList;
@synthesize groupCell;

-(IBAction) reloadGroup:(id)sender
{
    NSLog(@"reloadGroup");
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    [tmp addObject:@"1"];
    [tmp addObject:@"2"];
    [tmp addObject:@"3"];
    [tmp addObject:@"4"];
    [tmp addObject:@"5"];
    [tmp addObject:@"6"];
    [tmp addObject:@"7"];
    [tmp addObject:@"8"];
    [tmp addObject:@"9"];
    [tmp addObject:@"10"];
    [tmp addObject:@"11"];
    [tmp addObject:@"12"];
    [tmp addObject:@"13"];
    [tmp addObject:@"14"];
    [tmp addObject:@"15"];
    [tmp addObject:@"16"];
    [tmp addObject:@"17"];
    [tmp addObject:@"18"];
    [tmp addObject:@"19"];
    [tmp addObject:@"20"];
    self.groupList = tmp;
    [tmp release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self reloadGroup:self];
    }
    return self;
}

- (void)dealloc
{
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
    GroupCell *gcell = (GroupCell *)cell;
    gcell.groupName.text = [groupList objectAtIndex:indexPath.row];
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"GroupView Loaded");
    self.title = @"Group";
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.groupList = nil;
    self.groupTable = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
