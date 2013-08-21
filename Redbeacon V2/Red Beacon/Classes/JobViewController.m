//
//  JobViewController.m
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobViewController.h"
#import "GridCell.h"
#import "JobRequestViewController.h"
#import "InfoPage.h"
#import "UINavigationItem + RedBeacon.h"
#import "ManagedObjectContextHandler.h"
#import "Reachability.h"
#import "Red_BeaconAppDelegate.h"
#import "LoginViewController.h"
#import "FlurryAnalytics.h"

@interface JobViewController (Private)
- (void)populateJobCategories;
- (void)createCustomNavigationRightButton;
@end

@implementation JobViewController
@synthesize jobTable;
@synthesize delegate;
@synthesize defaultScreen;


#pragma mark - initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupNavigationBar {
    
    [self.navigationItem setRBIconImage];
    
    //right bar button item
    UIButton * settingsButton = [[UIButton alloc] init];
    settingsButton.frame = CGRectMake(8, 1, 35, 25);
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,40, 25)];
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:kRBInfoImage ofType:kRBImageType];
    UIImage * image  = [UIImage imageWithContentsOfFile:imagePath]; 
    [settingsButton setImage:image forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
    
    [infoView addSubview:settingsButton];
    
    UIBarButtonItem * settingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoView];
    self.navigationItem.leftBarButtonItem   = settingsBarButtonItem; 
    [settingsButton release];
    settingsButton = nil;
    [settingsBarButtonItem release];
    settingsBarButtonItem = nil;
    
    [infoView release];
    infoView=nil;
    
 //to adjust the title position
   UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 30)];//jvcBarButtonItemFrame
   UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
   [self.navigationItem setRightBarButtonItem:barbuttonItem];
   [button release];
   button = nil;
   [barbuttonItem release];
   barbuttonItem = nil;
}

- (void)createCustomNavigationRightButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showLoginView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
    item = nil;
}

-(void)sortJobListVerticalyInTable {
    
    NSMutableArray *columnLeftArray = [[NSMutableArray alloc] init];
    NSMutableArray *columnRightArray = [[NSMutableArray alloc] init];
    int jobCount =[job count];
    int halfJobCount = jobCount/2;
    for (int i =0; i<jobCount; i++) {
        
        if (i<halfJobCount+1) {
            [columnLeftArray addObject:[job objectAtIndex:i]];
        }
        else    
            [columnRightArray addObject:[job objectAtIndex:i]];
    }
    
    [job removeAllObjects];

    for (int i =0; i<jobCount; i++) {
        
        if (i%2 == 0) {
            [job addObject:[columnLeftArray objectAtIndex:0]];
            [columnLeftArray removeObjectAtIndex:0];
        }
        else    {
            [job addObject:[columnRightArray objectAtIndex:0]];
            [columnRightArray removeObjectAtIndex:0];
        }
    }
    
    [columnLeftArray release];
    columnLeftArray = nil;
    
    [columnRightArray release];
    columnRightArray = nil;
    
    
}

- (void)populateJobCategories {
    job = [[NSMutableArray alloc]init];
    NSMutableArray * occupations = [[ManagedObjectContextHandler sharedInstance] fetchAllOccupations];
   
    for (OccupationModel * occupation in occupations) {
        [job addObject:occupation.displayName];
    }
    NSArray *occupationSorted = [job sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [job removeAllObjects];
    [job addObjectsFromArray:occupationSorted];
    
    [self sortJobListVerticalyInTable];
    //more soon option removed
    //[job addObject:@"more soon..."];
}

- (void)checkForJobCategories {
    
    if ([Reachability connected])
    {
        if (!mobileContent)
        {
            mobileContent = [[RBMobileContentHandler alloc] init];
        }
        
        mobileContent.delegate = self;
        requestType = kContent;
        [mobileContent sendContentRequest];
    } 
}

- (void)setupTableView {
    UILabel *tableHeader = [[UILabel alloc]initWithFrame:CGRectMake(0,0,320,10)];
    tableHeader.backgroundColor = [UIColor clearColor];
    tableHeader.text = @"";
    jobTable.tableHeaderView = tableHeader;
    [tableHeader release];
    tableHeader = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    [self populateJobCategories];
    [self setupNavigationBar];
    [self checkForJobCategories];
    
    JobRequest *jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if(jobRequest)
        [self showJobRequestViewWithTitle:jobRequest.jobName];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [FlurryAnalytics logEvent:@"View - Occupation Select"];
}


/*- (void)populateHardCorededArray {

    job = [[NSMutableArray alloc]init];
     [job addObject:@"Carpet Cleaner"];
     [job addObject:@"Movers"];
     [job addObject:@"Carpenter"];
     [job addObject:@"Painter"];
     [job addObject:@"Contracter"];
     [job addObject:@"Plumber"];
     [job addObject:@"Electrician"];
     [job addObject:@"Roofer"];
     [job addObject:@"Handyman"];
     [job addObject:@"Yard Worker"];
     [job addObject:@"Maid"];
    [job addObject:@"more soon..."];
    [jobTable reloadData];
}*/

- (void)addSettingButton
{
    // Info button
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
    [infoButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem =[[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = barItem;
    [barItem release];
    barItem = nil;
    infoButton = nil;
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath    {
    // Return the height of rows in the section.
    return 47;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

  if ([job count]%COL_COUNT==0) {
        
        return ([job count]/COL_COUNT);
    }
    
    else {
        
        return ([job count]/COL_COUNT)+1;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    GridCell *cell = (GridCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell=[[[GridCell alloc] init] autorelease];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell displayCellItems:[self readHomeSectionItems:indexPath.row*COL_COUNT]];
	// Configure the cell.
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark Home Section Items

- (NSMutableArray *)readHomeSectionItems:(int)index
{
    
    NSMutableArray *secions;
    secions=[[[NSMutableArray alloc]init] autorelease];
    for(int item=index ,col=0;item<[job count];item++,col++)
    {
        if (col<COL_COUNT) 
        {
            [secions addObject:[job objectAtIndex:item]];
        }
        else
        {
            break;
        }
    }
    
    return secions;
}


#pragma mark - Button Events

- (void)sectionButtonPresssed:(UIButton *)section
{
    UIButton *button = (UIButton *)section;
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.text, @"occupation", nil];
    [FlurryAnalytics logEvent:@"Occupation Button" withParameters:data];
     
    if ([button.titleLabel.text isEqualToString:JOB_LAST_ITEM]) 
    {
        
    }
    else 
    {    
        [self showJobRequestViewWithTitle:button.titleLabel.text];
        //[delegate jobViewDidUnload:button.titleLabel.text];
    }
}




- (void)showJobRequestViewWithTitle:(NSString*)title
{
    self.navigationItem.title = HOME_NAVIGATION_TITLE;
    JobRequestViewController *jobRequestViewController = [[JobRequestViewController alloc] 
                                                          initWithNibName:@"JobRequestViewController" 
                                                          bundle:nil];
    
    jobRequestViewController.jobTitle = title;
    BOOL animated=YES;
    JobRequest *jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if(jobRequest){
        [jobRequestViewController showOldSession:title];
        animated=NO;
    }
    else
        [jobRequestViewController jobViewDidUnload:title];
    
    [jobRequestViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:jobRequestViewController animated:animated];
    
    [jobRequestViewController release];
    jobRequestViewController = nil;
}

- (void)showInfoView:(id)sender
{
    InfoPage *infoController = [[InfoPage alloc] initWithNibName:@"InfoPage" bundle:nil];
    
    RBNavigationController *infoPageNavigationController = [[RBNavigationController alloc]
                                                            initWithRootViewController:infoController];
    [self.navigationController presentModalViewController:infoPageNavigationController animated:YES];
    
    [infoPageNavigationController release];
    infoPageNavigationController = nil;
    
    [infoController release];
    infoController = nil;
}


- (void)showLoginView:(id)sender
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    RBNavigationController *loginPageNavigationController = [[RBNavigationController alloc]
                                                             initWithRootViewController:loginViewController];
    [self.navigationController presentModalViewController:loginPageNavigationController animated:YES];
    
    [loginPageNavigationController release];
    loginPageNavigationController = nil;
    
    [loginViewController release];
    loginViewController = nil;
}

- (IBAction)callButtonClick:(id)sender
{
    [FlurryAnalytics logEvent:@"Call Redbeacon Button"];
    [[UIApplication sharedApplication] 
                               openURL:[NSURL URLWithString:@"tel:1-855-723-2266"]];
}

#pragma mark -

- (void)viewDidUnload
{
    self.jobTable = nil;
    [super viewDidUnload];
}


#pragma mark - memory relese

- (void)dealloc
{
    [job release];
    job = nil;
    
    [mobileContent release];
    mobileContent = nil;
    
    [jobTable release];
    jobTable = nil;
    
    [super dealloc];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - HTTP Delegate Methods
- (void)requestCompletedSuccessfully:(ASIHTTPRequest*)request
{      
    [self populateJobCategories];
    [jobTable reloadData];
}

- (void)requestCompletedWithErrors:(ASIHTTPRequest*)request
{
    NSLog(@"Job Categories request failed");
}

#pragma mark - alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100)
    {
        Red_BeaconAppDelegate * appDelegate = (Red_BeaconAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate selectTabbarIndex:0];
    }
}

@end
