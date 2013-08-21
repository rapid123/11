//
//  ReviewsDetailViewController.m
//  Red Beacon
//
//  Created by sudeep on 13/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ReviewsDetailViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "ReviewDetailCell.h"


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

@interface ReviewsDetailViewController (Private)

- (CGSize)sizeForMessageIndexPath:(NSIndexPath *)indexPath;
@end


@implementation ReviewsDetailViewController
@synthesize jobBid;
@synthesize reviewtable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - memory management

- (void)dealloc
{
    reviewtable.delegate = nil;
    self.reviewtable = nil;
    self.jobBid = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - navigation bar

-(void)backButtonClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

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
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 25)];
    UIBarButtonItem * barbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
    [button release];
    button = nil;
    [barbuttonItem release];
    barbuttonItem = nil;
    
    [self createCustomNavigationLeftButton];
}


- (void)setupNavigationBar {
    
    [self.navigationItem setRBTitle:@"Reviews" withSubTitle:jobBid.jobProfile.best_name];
    
    [self createCustomNavigationButtons]; 
}

#pragma mark - initialize variables

-(void)initializeContents {
    
    NSLog(@"%d",[jobBid.jobProfile.reviews count]);

    reviews = [[NSMutableArray alloc] init];
    for (int i = 0; i< [jobBid.jobProfile.reviews count]; i++) {
        
        Review *objReview = [jobBid.jobProfile.reviews objectAtIndex:i];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:objReview.content
                 forKey:@"review"];
        
        [dict setObject:objReview.date 
                 forKey:@"date"];
        [dict setObject:objReview.author 
                 forKey:@"author"];
        [dict setObject:[NSNumber numberWithInt:objReview.rating] 
                 forKey:@"stars"];
        
        [reviews addObject:dict];
        [dict release];
        dict = nil;
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self initializeContents];
    [reviewtable reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int rowCount;
    if ([jobBid.jobProfile.reviews count]>100000)  // 100000 as TO DO...
        rowCount = [reviews count] + 1 ;
    else
         rowCount = [reviews count];   
        
    return rowCount;
    
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    ReviewDetailCell *reviewDetailCell = (ReviewDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (reviewDetailCell == nil) {
        reviewDetailCell = [[ReviewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                   reuseIdentifier:cellIdentifier];
        [reviewDetailCell autorelease];
        reviewDetailCell.frame = CGRectMake(0.0, 0.0, 320.0, 55);
    }

    if ([jobBid.jobProfile.reviews count]>10 && indexPath.row == 0) {
        
        [reviewDetailCell displayGraph:jobBid.jobProfile.rateDistribution];
    }
        
    else
        [reviewDetailCell displayCellWithDetails:[reviews objectAtIndex:(indexPath.row)]];
    
    return reviewDetailCell; 
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath    {
    
    CGFloat height;
    
    if ([jobBid.jobProfile.reviews count]>10 && indexPath.row == 0) {
        
        height = 150.0;
    }
    else {
        CGSize size = [self sizeForMessageIndexPath:indexPath]; 
        height = size.height;
    }
       
    return height;
}


- (CGSize)sizeForMessageIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;  
    NSDictionary * reviewDetail = [reviews objectAtIndex:index];
	NSString *content = [reviewDetail valueForKey:@"review"];
	
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
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
