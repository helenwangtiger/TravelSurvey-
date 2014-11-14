//
//  ForthViewController.m
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "ForthViewController.h"
#import "NavigationTripViewController.h"
#import "MapTripNavViewController.h"
#import "FourthViewControllerClickedCell.h"

@interface ForthViewController ()

@end

@implementation ForthViewController

@synthesize tableview,listData,searchResults,savedSearchTerm,tripName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Trips", @"Fourth");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_instructions.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	[self setSearchResults:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateTable];
}

-(void)updateTable {
    listData = nil;
    listData = [[NSArray alloc] init];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"trips.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    listData = [[data allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [tableview reloadData];
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
	[self setSavedSearchTerm:searchTerm];
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
		array = nil;
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (NSString *currentString in [self listData])
		{
			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:currentString];
			}
		}
	}
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rows;
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		rows = [[self searchResults] count];
    }
	else {
		rows = [[self listData] count];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
		contentForThisRow = [[self searchResults] objectAtIndex:row];
    }
	else {
		contentForThisRow = [[self listData] objectAtIndex:row];
    }
		
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];

	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		// Do anything that should be the same on EACH cell here.  Fonts, colors, etc.
	}
	
	// Do anything that COULD be different on each cell here.  Text, images, etc.
	[[cell textLabel] setText:contentForThisRow];
    
    //programmtic UIButton instance
    if([[NSUserDefaults standardUserDefaults] valueForKey:contentForThisRow]!=nil&&![[[NSUserDefaults standardUserDefaults] valueForKey:contentForThisRow] isEqualToString:@"0"]) {
        UIButton *cellButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cellButton setFrame: CGRectMake(270, 2, 40, 40)];
        [cellButton setBackgroundImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
        [cell addSubview:cellButton];
        NSLog(@"value: %@",[[NSUserDefaults standardUserDefaults] valueForKey:contentForThisRow]);
    }
    return cell;
}

-(void)viewDidAppear:(BOOL)animated {
    float sysversion= [[[UIDevice currentDevice]systemVersion]floatValue];
    CGSize screensize= [[UIScreen mainScreen]bounds].size;
    if(sysversion >=6.0 && sysversion <7.0){
        //iphone 3.5 inch
        if (screensize.height<500) {
            //[navBar setFrame:CGRectMake(0, 0, 320, 44)];
            [tableview setFrame:CGRectMake(0,0,320,436)];
        }
        // iphone 4 inch
        if(screensize.height>500){
            //[navBar setFrame:CGRectMake(0, 0, 320, 44)];
            [tableview setFrame:CGRectMake(0,0,320,524)];
        }
    }
    if (sysversion >= 7.0) {
        //3.5 inch
        if (screensize.height < 500) {
            //[navBar setFrame:CGRectMake(0, 0, 320, 54)];
            [tableview setFrame:CGRectMake(0,20,320,416)];
        }
        //4 inch
        if (screensize.height > 500) {
            //[navBar setFrame:CGRectMake(0, 0, 320, 54)];
            [tableview setFrame:CGRectMake(0,20,320,504)];
        }
    }
    [tableview reloadData];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = [indexPath row];
        NSString *contentForThisRow = nil;
        
        if (tableView == [[self searchDisplayController] searchResultsTableView]) {
            contentForThisRow = [[self searchResults] objectAtIndex:row];
        }
        else {
            contentForThisRow = [[self listData] objectAtIndex:row];
        }
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"trips.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        [data removeObjectForKey:contentForThisRow];
        [data writeToFile:path atomically:YES];
        listData = [[data allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [tableview reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    tripName = cell.textLabel.text;
    NSLog(@"tripName in table cell is %@",tripName);
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	if (tableView == [[self searchDisplayController] searchResultsTableView]) {
        contentForThisRow = [[self searchResults] objectAtIndex:row];
    }
	else {
        contentForThisRow = [[self listData] objectAtIndex:row];
    }
    NSLog(@"row: %@", contentForThisRow); //this gets the name of the row that we just chose
    FourthViewControllerClickedCell *clicked = [[FourthViewControllerClickedCell alloc] initWithNibName:nil bundle:nil];
    clicked.tripName = contentForThisRow;
    [self presentViewController:clicked animated:NO completion:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
	[self handleSearchForTerm:searchString];
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	[self setSavedSearchTerm:nil];
	[[self tableview] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
