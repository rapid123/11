//
//  MoreViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "ProfileViewController.h"
#import "MobileSettingsViewController.h"
#import "CalenderViewController.h"
#import "CoverageCalendar.h"
#import "DataManager.h"
#import "GeneralClass.h"
#import "MyProfile.h"
#define MORE_VIEW [NSArray arrayWithObjects: @"My Profile",@"Coverage Calendar",@"Mobile Settings",nil]


@interface MoreViewController ()
{
    NSArray *imageArray;
    JsonParser *objParser;
    UIView *syncView;
    int errorEparseType;
}

@property (weak, nonatomic)IBOutlet UILabel *moreLabel;
@property (weak, nonatomic)IBOutlet UITableView *moreViewTableview;

- (void)fontCustomization;
- (void)callMyProfileAPI;
- (void)callCoverageCalenderAPI;
- (void)mobileSettingsViewController;

@end

@implementation MoreViewController
@synthesize moreLabel;
@synthesize moreViewTableview;
#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"More";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_More"];
        
        
    }
    return self;
}

#pragma mark- Initial Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fontCustomization];
    self.navigationController.navigationBarHidden = YES;
    imageArray = [[NSArray alloc]initWithObjects:@"More_profile",@"More_calndr",@"More_phone",nil];
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name: fontCustomization.
 *  Purpose: To set font for Controllers.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)fontCustomization
{
    moreLabel.font = [GeneralClass getFont:titleFont and:boldFont];
}

/*******************************************************************************
 *  Function Name: callMyProfileAPI.
 *  Purpose: To start myprofile View.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)callMyProfileAPI
{
        [self setCustomOverlay];
        [self deleteOldDataFromProfileEntity];
        NSString *string=@"";//No need of inputs right now.
        objParser = nil;
        if (!objParser)
        {
            objParser=[[JsonParser alloc] init];
            objParser.delegate=self;
        }
        [objParser parseJson:MyProfileAPI :string];
}

/*******************************************************************************
 *  Function Name: callCoverageCalenderAPI.
 *  Purpose: To start coverage calender View.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)callCoverageCalenderAPI
{
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLoginCoverageCalender"])
//    {
        [self deleteOldDataFromCoverageEntity];
        [self setCustomOverlay];
        NSString *string=@"";//No need of inputs right now.
        objParser = nil;
        if (!objParser)
        {
            objParser=[[JsonParser alloc] init];
            objParser.delegate=self;
        }
        [objParser parseJson:CoverageCalendarAPI :string];
        
//    }
//    else
//    {
//        CalenderViewController *calenderViewController=[[CalenderViewController alloc] initWithNibName:@"CalenderViewController"
//                                                                                                bundle:nil];
//        [self.navigationController pushViewController:calenderViewController animated:YES];
//        calenderViewController = nil;
//    }
}
- (void)deleteOldDataFromCoverageEntity
{
    NSArray *result = [DataManager getWholeEntityDetails:COVERAGECALENDER sortBy:@"date"];
    
    int resultCount = [result count];
    for (int i = 0; i < resultCount; i ++)
    {
        CoverageCalendar *coverageCalendar = [result objectAtIndex:i];
        [DataManager deleteMangedObject:coverageCalendar];
    }
}
-(void)deleteOldDataFromProfileEntity
{
    NSArray *result = [DataManager getWholeEntityDetails:MYPROFILE sortBy:@"userName"];
    
    int resultCount = [result count];
    for (int i = 0; i < resultCount; i ++)
    {
        MyProfile *myprofile = [result objectAtIndex:i];
        [DataManager deleteMangedObject:myprofile];
    }

}
/*******************************************************************************
 *  Function Name: mobileSettingsViewController.
 *  Purpose: To start mobilesettings view.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)mobileSettingsViewController
{
    MobileSettingsViewController *mobileSettingsViewController=[[MobileSettingsViewController alloc] initWithNibName:@"MobileSettingsViewController"
                                                                                                              bundle:nil];
    [self.navigationController pushViewController:mobileSettingsViewController animated:YES];
    mobileSettingsViewController = nil;
    
}
/*******************************************************************************
 *  Function Name: setCustomOverlay.
 *  Purpose: To init syncing.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)setCustomOverlay
{
    if(!syncView)
    {
        syncView = [[UIView alloc]init];
        syncView.frame = self.view.frame;
        UIActivityIndicatorView *syncingActivityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(60, 140, 200, 200)];
        syncingActivityIndicator.backgroundColor = [UIColor clearColor];
        syncingActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [syncingActivityIndicator startAnimating];
        [syncView addSubview:syncingActivityIndicator];
    }
    
    [self.view addSubview:syncView];
}

#pragma mark- UITableView delegates
/*******************************************************************************
 *  UITableView delegates
 ********************************************************************************/
- (CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MORE_VIEW count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CGRect labelFrame = CGRectMake(60, 15, 200, 20);
    UILabel* label = [[UILabel alloc]initWithFrame:labelFrame];
    label.font =[GeneralClass getFont:nameFont and:boldFont];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *images = [[UIImageView alloc]init];//WithFrame:imageViewFrame];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell addSubview:images];
        NSString *cellValue = [MORE_VIEW objectAtIndex:indexPath.row];
        label.text = cellValue;
        float x ;
        if(indexPath.row == 2)
        {
            x = 25;
        }
        else
        {
            x = 20;
        }
        images.frame = CGRectMake(x, 10, [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageArray objectAtIndex:indexPath.row] ofType:@"png"]].size.width/2, [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageArray objectAtIndex:indexPath.row] ofType:@"png"]].size.height/2);
        images.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:label];
    }
	return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed: @"table_directory.png"]]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self callMyProfileAPI];

            break;
            
        case 1:
            [self callCoverageCalenderAPI];
            break;
            
        case 2:
            [self mobileSettingsViewController];
            break;
            
        default:
            break;
    }
}

#pragma mark - Parser Delegates
-(void)parseCompleteSuccessfully:(ParseServiseType) eparseType:(NSArray *)result
{
    
    if( eparseType == MyProfileAPI)
    {
       
        if([result count]>0)
        {
            //Used for Myprofile parsing
            [syncView removeFromSuperview];
            ProfileViewController *detailViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController"
                                                                                                bundle:nil];
            [self.navigationController pushViewController:detailViewController animated:YES];
            detailViewController = nil;
        }
        else
        {
            [GeneralClass showAlertView:self
                                    msg:nil
                                  title:@"No profile"
                            cancelTitle:nil
                             otherTitle:@"OK"
                                    tag:noDetailsTag];
            errorEparseType = eparseType;

        }
        
    }
    else if(eparseType == CoverageCalendarAPI)
    {
        if([result count]>0)
        {
            //Used for CoverageCalender parsing
//            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstLoginCoverageCalender"];
            [syncView removeFromSuperview];
            CalenderViewController *calenderViewController=[[CalenderViewController alloc] initWithNibName:@"CalenderViewController"
                                                                                                    bundle:nil];
            [self.navigationController pushViewController:calenderViewController animated:YES];
            calenderViewController = nil;

        }
        else
        {
            [GeneralClass showAlertView:self
                                    msg:nil
                                  title:@"No coverage calendar"
                            cancelTitle:nil
                             otherTitle:@"OK"
                                    tag:noDetailsTag];
            errorEparseType = eparseType;
            
 
        }
        
        
    }
    
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    NSLog(@"Parse Error");
    [GeneralClass showAlertView:self
                            msg:nil
                          title:@"Parse with error. Try again?"
                    cancelTitle:@"YES"
                     otherTitle:@"NO"
                            tag:parseErrorTag];
    errorEparseType = eparseType;
    
}
-(void)netWorkNotReachable
{
    NSLog(@"NO NETWORK");
    [GeneralClass showAlertView:self
                            msg:NSLocalizedString(@"CHECK NETWORK CONNECTION", nil)
                          title:NSLocalizedString(@"NO NETWORK", nil)
                    cancelTitle:@"OK"
                     otherTitle:nil
                            tag:reachabilityTag];
}
-(void)parseWithInvalidMessage:(NSArray *)result
{
    if ([result count]>0)
    {
        NSString *resultResponseCode = @"No data from server";
        resultResponseCode = [resultResponseCode stringByAppendingFormat:@"\nDo you want to continue?"];
        
        [GeneralClass showAlertView:self
                                msg:nil //resultResponseCode
                              title:resultResponseCode
                        cancelTitle:@"YES"
                         otherTitle:@"NO"
                                tag:parseErrorTag];
        errorEparseType = [[result valueForKey:@"operationType"] integerValue];
        
    }
    else
    {
        [self parseFailedWithError:0 :nil :0];
    }
}
#pragma mark- UIAlertView delegate
/*******************************************************************************
 *  UIAlertView delegate.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == reachabilityTag)
    {
        NSLog(@"No network");
        [syncView removeFromSuperview];
    }
    else if(alertView.tag == parseErrorTag)
    {
        if(errorEparseType==MyProfileAPI)
        {
            if(buttonIndex == 0)
            {
                [self callMyProfileAPI];
            }
            else
            {
                [syncView removeFromSuperview];
            }
            
        }
        else if(errorEparseType==CoverageCalendarAPI)
        {
            if(buttonIndex == 0)
            {
                [self callCoverageCalenderAPI];
            }
            else
            {
                [syncView removeFromSuperview];
            }
            
        }
        
    }
    else if (alertView.tag == noDetailsTag)
    {
        if(errorEparseType==CoverageCalendarAPI)
        {
            if(buttonIndex == 0)
            {
                [syncView removeFromSuperview];
            }
        }
        else if(errorEparseType==MyProfileAPI)
        {
            if(buttonIndex == 0)
            {
                [syncView removeFromSuperview];
            }
 
        }
    }
    alertView = nil;
}

#pragma mark- Memory
- (void)viewDidUnload
{
    [self setMoreLabel:nil];
    [super viewDidUnload];
}

#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
