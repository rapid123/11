//
//  ScheduleViewController.m
//  Red Beacon
//
//  Created by Nithin George on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleViewController.h"
#import "UINavigationItem + RedBeacon.h"
#import "JobRequest.h"
#import "RBAlertMessageHandler.h"

@implementation ScheduleViewController

@synthesize scheduleTableView, schedule;
@synthesize scheduleDate;
@synthesize scheduleType;
@synthesize datePickr;
@synthesize lastIndex;

#define FAILED_INVALID_DATE_ALERT_MESSAGE @"Your schedule date is in the past"

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
    
    [self.navigationItem setRBTitle:kSVCPageTitle];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    button=nil;
    [item release];
    item = nil;

}

- (void)selectTableCell {
    
    [scheduleTableView reloadData];
    
    int row;
    if ([self.schedule isFlexible]) {
        row = 0;
    }
    else if ([self.schedule isUrgent]) {
        row = 1;        
    }
    else {
        row = 2;
    }    
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row 
                                                 inSection:0];
    
    UITableViewCell *newCell = [scheduleTableView cellForRowAtIndexPath:indexPath];
    
    int presentRow=[indexPath row];
    int oldRow= (self.lastIndex != nil) ? [self.lastIndex row] : -1; //[self.lastIndex row];
    
    if(presentRow!=oldRow)
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [scheduleTableView cellForRowAtIndexPath:self.lastIndex]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.lastIndex = indexPath;		
    }
    if(0==presentRow)
    {
        [flexbleTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [flexSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [urgentTitle setTextColor:[UIColor blackColor]];
        [urgentSubTitle setTextColor:[UIColor blackColor]];
        [pickerTitle setTextColor:[UIColor blackColor]];
        [pickerSubTitle setTextColor:[UIColor blackColor]];
        datePickr.hidden=YES;
        datePickr.alpha=0.75;
        
    }
    else if(1==presentRow)
    {
        [flexbleTitle setTextColor:[UIColor blackColor]];
        [flexSubTitle setTextColor:[UIColor blackColor]];
        [urgentTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [urgentSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [pickerTitle setTextColor:[UIColor blackColor]];
        [pickerSubTitle setTextColor:[UIColor blackColor]];
        datePickr.hidden=YES;
        datePickr.alpha=0.75;
    }
    else {
        [flexbleTitle setTextColor:[UIColor blackColor]];
        [flexSubTitle setTextColor:[UIColor blackColor]];
        [urgentTitle setTextColor:[UIColor blackColor]];
        [urgentSubTitle setTextColor:[UIColor blackColor]];
        [pickerTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        [pickerSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        datePickr.hidden=NO;
        datePickr.alpha=1.0;
    }    
    [scheduleTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)populateDefaultValues {
    
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    RBJobSchedule * tempSchedule = [[RBJobSchedule alloc] initWithSchedule:jRequest.schedule];
    self.schedule = tempSchedule;
    [tempSchedule release];
    NSDate * date; //= self.schedule.date;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:[NSDate date]];
   
    int day  = [dateComponents day]+2;
    int month  = [dateComponents month];
    int year  = [dateComponents year];

    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear: year];
    [comps setHour:10];
    [comps setMinute:00];
    
    NSString * type = jRequest.schedule.type;
    if ([type isEqualToString:SCHEDULE_TYPE_DATE])
    {
       date = jRequest.schedule.date;
    }
    else
    {
       date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    }

    [datePickr setDate:date animated:NO]; 
    [self selectTableCell];    
    
    [comps release];
    comps = nil;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    datePickr.hidden=YES;
    datePickr.alpha=0.75;
    scheduleTableView.backgroundColor = [UIColor clearColor];   
    [self populateDefaultValues];
    [self setupNavigationBar];
    
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath	{
 
 return 62;
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
//    NSArray * array = [cell.contentView subviews];
//    for (UIView * view in array) {
//        if (view.tag==101) {
//            [view removeFromSuperview];
//        }
//    }
//    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:  
                    cell.textLabel.text = @"";
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;

                    [flexbleTitle removeFromSuperview];
                    [flexSubTitle removeFromSuperview];
                    
                    flexbleTitle = [self setTitleLabes];
                    flexbleTitle.frame = CGRectMake(10, 10, 282, 20);
                    [flexbleTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                    [flexbleTitle setBackgroundColor:[UIColor clearColor]];
                    [flexbleTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
                    flexbleTitle.text = SCHEDULE_SECTION_ROW0_MAIN_TITLE;
					flexbleTitle.tag=0;
                    [cell.contentView addSubview:flexbleTitle];
                    
                    flexSubTitle = [self setTitleLabes];
                    flexSubTitle.frame = CGRectMake(10 ,22 , 282, 25);
                    [flexSubTitle setFont:[UIFont fontWithName:@"Helvetica" size:13]];
                    [flexSubTitle setBackgroundColor:[UIColor clearColor]];
                    [flexSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
                    flexSubTitle.text = SCHEDULE_SECTION_ROW0_SUB_TITLE;
					flexSubTitle.tag=1;
                    [cell.contentView addSubview:flexSubTitle];
					self.lastIndex=indexPath;
                    break;
                case 1:
                    cell.textLabel.text = @"";
					cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    [urgentTitle removeFromSuperview];
                    [urgentSubTitle removeFromSuperview];
                    
                    urgentTitle = [self setTitleLabes];
                    urgentTitle.frame = CGRectMake(10, 10, 282, 20);
                    [urgentTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                    [urgentTitle setBackgroundColor:[UIColor clearColor]];
                    [urgentTitle setTextColor:[UIColor blackColor]];
                    urgentTitle.text = SCHEDULE_SECTION_ROW1_MAIN_TITLE;
					urgentTitle.tag=0;
                    [cell.contentView addSubview:urgentTitle];
                    
                    urgentSubTitle = [self setTitleLabes];
                    urgentSubTitle.frame = CGRectMake(10 ,22 , 282, 25);
                    [urgentSubTitle setFont:[UIFont fontWithName:@"Helvetica" size:13]];
                    [urgentSubTitle setBackgroundColor:[UIColor clearColor]];
                    [urgentSubTitle setTextColor:[UIColor blackColor]];
                    urgentSubTitle.text = SCHEDULE_SECTION_ROW1_SUB_TITLE;
					urgentSubTitle.tag=1;
                    [cell.contentView addSubview:urgentSubTitle];
                    break;
                case 2:
                    cell.textLabel.text = @"";
					cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    [pickerTitle removeFromSuperview];
                    [pickerSubTitle removeFromSuperview];
                    
                    pickerTitle = [self setTitleLabes];
                    pickerTitle.frame = CGRectMake(10, 10, 282, 20);
                    [pickerTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
                    [pickerTitle setBackgroundColor:[UIColor clearColor]];
                    [pickerTitle setTextColor:[UIColor blackColor]];
                    pickerTitle.text = SCHEDULE_SECTION_ROW2_MAIN_TITLE;
					pickerTitle.tag=0;
                    [cell.contentView addSubview:pickerTitle];
                    
                    pickerSubTitle = [self setTitleLabes];
                    pickerSubTitle.frame = CGRectMake(10 ,22 , 282, 25);
                    [pickerSubTitle setFont:[UIFont fontWithName:@"Helvetica" size:13]];
                    [pickerSubTitle setBackgroundColor:[UIColor clearColor]];
                    [pickerSubTitle setTextColor:[UIColor blackColor]];
                    pickerSubTitle.text = SCHEDULE_SECTION_ROW2_SUB_TITLE;
					pickerSubTitle.tag=1;
                    [cell.contentView addSubview:pickerSubTitle];
                    break;
            }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];

	int presentRow=[indexPath row];
	int oldRow= (self.lastIndex != nil) ? [self.lastIndex row] : -1; //[self.lastIndex row];
	
	if(presentRow!=oldRow)
	{
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
	
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndex]; 
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
		self.lastIndex = indexPath;		
	}
	
	if(0==presentRow)
	{
		[flexbleTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
		[flexSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
		[urgentTitle setTextColor:[UIColor blackColor]];
		[urgentSubTitle setTextColor:[UIColor blackColor]];
		[pickerTitle setTextColor:[UIColor blackColor]];
		[pickerSubTitle setTextColor:[UIColor blackColor]];
        datePickr.hidden=YES;
		datePickr.alpha=0.75;
        self.schedule.type = SCHEDULE_TYPE_FLEXIBLE;
        self.scheduleType = SCHEDULE_TYPE_FLEXIBLE;
        
       
	}
	else if(1==presentRow)
	{
		[flexbleTitle setTextColor:[UIColor blackColor]];
		[flexSubTitle setTextColor:[UIColor blackColor]];
		[urgentTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
		[urgentSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
		[pickerTitle setTextColor:[UIColor blackColor]];
		[pickerSubTitle setTextColor:[UIColor blackColor]];
        datePickr.hidden=YES;
		datePickr.alpha=0.75;
        self.schedule.type = SCHEDULE_TYPE_URGENT;
        
        self.scheduleType = SCHEDULE_TYPE_URGENT;
	}
	else {
		[flexbleTitle setTextColor:[UIColor blackColor]];
		[flexSubTitle setTextColor:[UIColor blackColor]];
		[urgentTitle setTextColor:[UIColor blackColor]];
		[urgentSubTitle setTextColor:[UIColor blackColor]];
		[pickerTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
		[pickerSubTitle setTextColor:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]];
        datePickr.hidden=NO;
		datePickr.alpha=1.0;
        self.schedule.type = SCHEDULE_TYPE_DATE;
       self.schedule.date = [datePickr date];
        self.scheduleType = SCHEDULE_TYPE_DATE;
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (UILabel *)setTitleLabes
{
    UILabel *titleLbl = [[[UILabel alloc]init] autorelease];
    [titleLbl setTag:101];
    //[titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:lblSize]];
    return titleLbl;
    
}


#pragma mark - Button Actions
-(IBAction)doneButtonClicked:(id)sender 
{
    if ([[NSDate dateWithTimeIntervalSinceNow:[datePickr.date timeIntervalSinceNow]] compare:[NSDate date]] == NSOrderedAscending) // If the picked date is less than today
        
    {
        NSString * title = @"Redbeacon";
        [RBAlertMessageHandler showAlertWithTitle:title
                                          message:FAILED_INVALID_DATE_ALERT_MESSAGE 
                                   delegateObject:self
                                          viewTag:0
                                 otherButtonTitle:@"OK" 
                                       showCancel:NO];
        datePickr.date = [NSDate date];
        
    }
    else{
        
        JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
        jRequest.schedule = self.schedule;
        [[self navigationController] popViewControllerAnimated:YES];
    }
    

}


-(IBAction)cancelButtonClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
    
}



#pragma mark- memory release

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.scheduleTableView = nil;
    self.datePickr = nil;
}
- (void)dealloc
{
    [scheduleType release];
    [scheduleDate release];
    [schedule release];
    [lastIndex release];
    
    
    [scheduleTableView release];
    scheduleTableView = nil;
    
    [datePickr release];
    datePickr = nil;
    
    
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


#pragma mark - PICKER
- (IBAction)didPickerValueChanged:(id)sender 
{
    if (![self.schedule.type isEqualToString:SCHEDULE_TYPE_DATE]) {
         self.schedule.type = SCHEDULE_TYPE_DATE;
        [self selectTableCell];
    }
    self.schedule.date = [datePickr date];
    self.scheduleDate = [RBConstants getStringFromDate:[datePickr date]];
    
}

@end
