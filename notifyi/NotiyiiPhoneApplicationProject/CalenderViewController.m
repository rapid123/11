//
//  CalenderViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalenderViewController.h"
#import "CoverageCalendar.h"
#import "GeneralClass.h"

@interface CalenderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *coverageCalenderTitleLbl;

@property (weak, nonatomic) IBOutlet UITableView *calenderTableView;

- (void)calenderDataFetch;
- (void)fontCustomization;
- (IBAction)backButtonTouched:(id)sender;

@end

NSArray *calenderData;

@implementation CalenderViewController
@synthesize backButton;
@synthesize coverageCalenderTitleLbl;
@synthesize calenderTableView;
@synthesize calenderCell;
@synthesize fetchedResultsController = _fetchedResultsController;



#pragma mark- Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fontCustomization];
    [self calenderDataFetch];
}

#pragma mark - Methods
/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose: To set font for Contoller.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)fontCustomization
{
    coverageCalenderTitleLbl.font = [GeneralClass getFont:titleFont and:boldFont];
    backButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
}

/*******************************************************************************
 *  Function Name: calenderDataFetch.
 *  Purpose: To fetch calender data.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)calenderDataFetch
{
    NSError *error = nil;
    DataManager *dataManager = [[DataManager alloc]init];
    self.fetchedResultsController = [dataManager fetchedResultsController];
    
	if (![[self fetchedResultsController] performFetch:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self.calenderTableView reloadData];
}

#pragma mark - Table view data source
/*******************************************************************************
 *  UITable view data source
 ********************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
	return count;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
	NSInteger count = [sectionInfo numberOfObjects];
    NSLog(@"Row Count ::: %d",count);
	return count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [dateFormatter dateFromString:[theSection name]];
    
    [dateFormatter setDateFormat:@"MMMM dd yyyy"];
    NSString *dateWithNewFormat = [[dateFormatter stringFromDate:date] uppercaseString];
    NSLog(@"dateWithNewFormat: %@", dateWithNewFormat);
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 320, 30)];
    sectionView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 33)];
    headerImage.image = [UIImage imageNamed:@"calenderHeaderBackgroungImage.png"];
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 320, 25)];
    headerTitle.textColor =	[UIColor whiteColor];
    headerTitle.font= [GeneralClass getFont:customNormal and:boldFont];
    headerTitle.backgroundColor= [UIColor clearColor];
    headerTitle.textAlignment=UITextAlignmentLeft;
    
    headerTitle.text=dateWithNewFormat;
    
    [headerImage addSubview:headerTitle];
    [sectionView addSubview:headerImage];
    
    return sectionView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CalenderCell *coverageCalenderCell = (CalenderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (coverageCalenderCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CalenderCell" owner:self options:nil];
        coverageCalenderCell = calenderCell;
        self.calenderCell = nil;
    }
    
    coverageCalenderCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CoverageCalendar *coverageCalendar = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [coverageCalenderCell displayDetails:coverageCalendar];
    
    coverageCalenderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return coverageCalenderCell;
}

#pragma mark- Button Action
/*******************************************************************************
 *  Back button touch action
 ********************************************************************************/
- (IBAction)backButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Unload
- (void)viewDidUnload
{
    [self setCalenderTableView:nil];
    [self setBackButton:nil];
    [self setCoverageCalenderTitleLbl:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    self.fetchedResultsController = nil;
    
}



#pragma mark- Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
