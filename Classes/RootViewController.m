// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import "RootViewController.h"
#import "Big5WebAppAppDelegate.h"
#import "big5ViewController.h"

@implementation RootViewController

@synthesize data;
@synthesize pathToUserCopyOfPlist;
@synthesize editViewController;

/* - (void)loadView {
    [super loadView];
    NSLog(@"Load root view");    
    } */

- (void)enterEditMode {
    NSLog(@"Enter edit mode");
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self 
                                              action:@selector(addEntry)] 
                                             autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self 
                                               action:@selector(leaveEditMode)] 
                                              autorelease];
    // [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
    [self.tableView beginUpdates];
}

- (void)leaveEditMode {
    NSLog(@"Leave edit mode");
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                               target:self 
                                               action:@selector(enterEditMode)] 
                                              autorelease];
    
    [self.tableView endUpdates];
    [self.tableView setEditing:NO animated:YES];
    // [self.tableView reloadData];
    [data writeToFile:pathToUserCopyOfPlist atomically:NO];    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
                                               target:self 
                                               action:@selector(enterEditMode)] 
                                              autorelease];

#ifdef ADMOB
    // [self initAd:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(initAd:) userInfo:nil repeats:NO];    
#endif
    
    // self.navigationItem.title = @"";
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;    
    // self.data = [[NSMutableArray alloc] initWithObjects:@"eins", @"zwei", @"drei", nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    NSLog(@"appear");
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    // self.navigationItem.leftBarButtonItem.enabled = NO;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (EditViewController *)editViewController {
    // Instantiate the editing view controller if necessary.
    if (editViewController == nil) {
        EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
        self.editViewController = controller;
        self.editViewController.data = self.data;
        self.editViewController.pathToUserCopyOfPlist = self.pathToUserCopyOfPlist;
        [controller release];
    }
    return editViewController;
}

- (IBAction)addEntry {
    NSLog(@"add");
    NSMutableDictionary *obj = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          @"Unnamed", @"title",
                          @"http://www.example.com", @"url",
                          nil];        
    [data addObject:obj];
    [self.tableView reloadData];
}

- (void)editRow:(NSInteger)row {    
    EditViewController *controller = self.editViewController;
    [self.navigationController pushViewController:controller animated:YES];    
    [controller editRow:row];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    // The number of rows in each section depends on the number of sub-items in each item in the data property list. 
    NSInteger count = [data count];
    // If we're in editing mode, we add a placeholder row for creating new items.
    // if (self.editing) count++;
#ifdef ADMOB
    // if(self.tableView.editing) --count;
#endif
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    static NSString *CellIdentifier = @"CustomCell";
	
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects){
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (CustomCell *) currentObject;
				break;
			}
		}
	}
    
    // Set up the cell...
    int row = indexPath.row;
    NSDictionary *obj = [data objectAtIndex:row];
    NSLog(@"Object %@", obj);
    NSString *title = [obj objectForKey:@"title"];    
    
    cell.titleLabel.text = title;
    cell.urlLabel.text =  [obj objectForKey:@"url"];
    // cell.hidesAccessoryWhenEditing = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    if(self.tableView.editing) {
        [self editRow:indexPath.row];
        
    } else {
        NSMutableDictionary *obj = [data objectAtIndex:indexPath.row];        
        big5ViewController *controller = [[big5ViewController alloc] init];
        controller.title = [obj objectForKey:@"title"];
        controller.gURL =  [NSURL URLWithString:[obj objectForKey:@"url"]];
        [self.navigationController pushViewController:controller animated:YES];  
        [controller release];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
#ifdef ADMOB
    // return indexPath.row!=0;
#endif
    return YES;
}

// The accessory view is on the right side of each cell. We'll use a "disclosure" indicator in editing mode,
// to indicate to the user that selecting the row will navigate to a new view where details can be edited.
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return (self.tableView.editing) ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [data removeObjectAtIndex:[indexPath row]];
        [self.tableView reloadData];
        
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSLog(@"moveRowAtIndexPath %@ %@", fromIndexPath, toIndexPath);
    //NSDictionary *obj = [data objectAtIndex:[fromIndexPath row]];
    //NSLog(@"moveRowAtIndexPath %@", obj);
    
    if (data && toIndexPath.row < [data count] && fromIndexPath.row < [data count]) {
        id item = [[data objectAtIndex:fromIndexPath.row] retain];
        [data removeObject:item];
        [data insertObject:item atIndex:toIndexPath.row];
        [item release];
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Disclosure %@", indexPath);
    [self editRow:indexPath.row];
}

- (void)dealloc {
    [super dealloc];
    [data release];
}

#pragma mark -
#pragma mark AdMobDelegate methods

#ifdef ADMOB

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if((indexPath.section == 0) && (indexPath.row == 0)) {
        return 49.0; // this is the height of the AdMob ad
    }
    
    return 44.0; // this is the generic cell height
}
 */

- (NSString *)publisherId {
    return @"a14999263f94978"; // this should be prefilled; if not, get it from www.admob.com
}

- (UIColor *)adBackgroundColor {
   return [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
   // this should be prefilled; if not, provide a UIColor
}

- (UIColor *)adTextColor {
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    // this should be prefilled; if not, provide a UIColor
}

- (BOOL)mayAskForLocation {
    return NO; // this should be prefilled; if not, see AdMobProtocolDelegate.h for instructions
}

// Sent when an ad request loaded an ad; this is a good opportunity to attach
// the ad view to the hierachy.
- (void)didReceiveAd:(AdMobView *)adView {
    NSLog(@"AdMob: Did receive ad");
    // self.view.hidden = NO;
    // adMobAd.frame = [self.view convertRect:self.view.frame fromView:self.view.superview]; // put the ad in the placeholder's location
    // adMobAd.frame = CGRectMake(0, 0, 320, 48);
    self.tableView.tableHeaderView = adMobAd; 
    // [self.view addSubview:adMobAd];
    autoslider = [NSTimer scheduledTimerWithTimeInterval:AD_REFRESH_PERIOD target:self selector:@selector(refreshAd:) userInfo:nil repeats:YES];
}

// Request a new ad. If a new ad is successfully loaded, it will be animated into location.
- (void)refreshAd:(NSTimer *)timer {
    [adMobAd requestFreshAd];
}

- (void)initAd:(NSTimer *)timer {
    NSLog(@"AdMob: Request an ad");
    adMobAd = [AdMobView requestAdWithDelegate:self]; // start a new ad request
    [adMobAd retain];  
}

// Sent when an ad request failed to load an ad
- (void)didFailToReceiveAd:(AdMobView *)adView {
    NSLog(@"AdMob: Did fail to receive ad");
    [adMobAd release];
    adMobAd = nil;
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(initAd:) userInfo:nil repeats:NO];    
    // we could start a new ad request here, but it is unlikely that anything has changed in the last few seconds,
    // so in the interests of the user's battery life, let's not
}
#endif

#if TARGET_IPHONE_SIMULATOR
- (BOOL)useTestAd {
    return YES;
}
#endif

@end

