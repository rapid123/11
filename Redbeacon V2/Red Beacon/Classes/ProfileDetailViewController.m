//
//  ProfileDetailViewController.m
//  Red Beacon
//
//  Created by sudeep on 13/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "ProfileDetailCell.h"

#define kImageWidth   32
#define kImageHeight  29

#define kAContentOffset 6
#define kBContentOffset kAContentOffset - 3

#define kTopContentOffset    (3)
#define kBottomContentOffset (3)

#define kTimeStampHeight 21

#define kMaxMessageContentWidth (320 - 17 - 14 - 20)
#define kNonContentWidth  (kImageWidth  - kAContentOffset - kBContentOffset)
#define kNonContentHeight (kImageHeight - kTopContentOffset - kBottomContentOffset)


@implementation ProfileDetailViewController

@synthesize profileTable;
@synthesize backgroundImageView;
@synthesize jobBid;
@synthesize profileDetails;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.profileDetails = nil;
    self.jobBid = nil;
    self.profileTable = nil;
    self.backgroundImageView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark- 
#pragma mark navigation button clicks

-(void)backButtonClick:(id)sender {
 
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Initializing methods

- (void)createCustomNavigationLeftButton {
    
    //navigation back button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 65, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    [item release];
    item = nil;
}

- (void)createCustomNavigationButtons {
    
    //to adjust the title position
    UIButton * button = [[UIButton alloc] initWithFrame:rightBarButtonItemFrame];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
    
    [self createCustomNavigationLeftButton];
}


- (void)setupNavigationBar {
    
    [self.navigationItem setRBTitle:jobBid.jobProfile.best_name withSubTitle:@"Profile Details"];
    
    [self createCustomNavigationButtons]; 
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileDetails = [jobBid.jobProfile profileDetailsToDisplay];
    [self setupNavigationBar];
    
    [self.profileTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSString *)getKeyForIndex:(int)index {
    
    NSDictionary * featureDetail = [profileDetails objectAtIndex:index];
    NSString *key = [[featureDetail allKeys] lastObject];
    return key;
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [profileDetails count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    ProfileDetailCell *profileDetailCell = (ProfileDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (profileDetailCell == nil) {
        profileDetailCell = [[ProfileDetailCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                               reuseIdentifier:cellIdentifier];
        [profileDetailCell autorelease];
        profileDetailCell.frame = CGRectMake(0.0, 0.0, 320.0, 55);
    }

    
    NSDictionary * featureDetail = [profileDetails objectAtIndex:indexPath.row];
    NSString *key = [self getKeyForIndex:indexPath.row];
    [profileDetailCell displayCellWithDetails:featureDetail withKey:key];
    
    return profileDetailCell;  
}


- (CGSize)sizeForMessageIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * featureDetail = [profileDetails objectAtIndex:indexPath.row];
	NSString *content = [[featureDetail valueForKey:DETAILS_KEY] objectAtIndex:0];
	
	UIFont *font = [UIFont systemFontOfSize:12];
	
	CGSize maxContentSize = CGSizeMake(kMaxMessageContentWidth, INFINITY);
	CGSize contentSize = [content sizeWithFont:font constrainedToSize:maxContentSize];
	
	CGSize cellSize = contentSize;
	
    cellSize.width  = MAX(contentSize.width + kNonContentWidth, kImageWidth);
	cellSize.height = MAX(contentSize.height + kNonContentHeight, kImageHeight);
	
    // Add room for timestamp
	cellSize.height += kTimeStampHeight;
	
	return cellSize;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath    {
    
    CGFloat height = 55.0;
    NSString *key = [self getKeyForIndex:indexPath.row];
    if([key isEqualToString:DETAILS_KEY]){
        CGSize size = [self sizeForMessageIndexPath:indexPath];
        height = size.height;
        if(height<55.0)
            height = 55.0;
    }
 
    return height;
}



@end
