//
//  TouchBaseViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchBaseViewController.h"
#import "StartDiscussionViewController.h"
#import "DataManager.h"
#import "DiscussionParticipants.h"
#import "Comments.h"
#import "GeneralClass.h"
#import "SBJSON.h"
#import "JSON.h"

JsonParser *objParser;

@interface TouchBaseViewController ()
{
    IBOutlet UILabel *touchBaseLabel;
    DataManager *dataManager;
    UIView *syncView;
    BOOL istouchBaseRefreshButtonTouched;
    BOOL enablePagination;
    BOOL isNewDiscussion;
    UIActivityIndicatorView *loadMoreCells;
}

@property(strong, nonatomic) IBOutlet UITableView *touchBaseTableView;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (nonatomic,strong) NSMutableArray *touchBaseDataManagerArray;

-(void)setCustomOverlay;
-(void)transitionFlipFromRight;
-(void)getTouchBaseList;

-(IBAction)startDiscussionBtnTouched:(id)sender;
-(IBAction)touchBaseRefreshBtnTouched:(id)sender;


@end


@implementation TouchBaseViewController
@synthesize touchBaseTableView;
@synthesize refreshButton;
@synthesize customTouchBaseTableViewCell;
@synthesize touchBase;
@synthesize touchBaseDataManagerArray;
#pragma mark- Init Load
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"Touch Base";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_TouchBase"];
    }
    return self;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.touchBaseDataManagerArray = [[NSMutableArray alloc]init];
    istouchBaseRefreshButtonTouched = NO;
    self.navigationController.navigationBarHidden = YES;
    enablePagination = YES;
    touchBaseLabel.font = [GeneralClass getFont:titleFont and:boldFont];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self getTouchBaseInformation];
}

#pragma mark- GetTouchBaseInfo
/*******************************************************************************
 *  Function Name: getTouchBaseInformation.
 *  Purpose: To get Touchbase information from Database.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)getTouchBaseInformation
{
    if([self.touchBaseDataManagerArray count])
    {
        [self.touchBaseDataManagerArray removeAllObjects];
    }
    NSArray *touchBaseArr = [DataManager getWholeEntityDetails:@"TouchBase" sortBy:@"discussionDate"];
    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"discussionDate" ascending:NO];
    NSArray *newDiscussionArray = [touchBaseArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
    [self.touchBaseDataManagerArray addObjectsFromArray:newDiscussionArray];
    
    [self transitionFlipFromRight];
    [self.touchBaseTableView reloadData];
    int noOfRows = [self.touchBaseTableView numberOfRowsInSection:0];
    NSLog(@"noOfRows==%d",noOfRows);
    if(noOfRows>0)
    {
        [self.touchBaseTableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
/*******************************************************************************
 *  Function Name: touchBaseDataRefreshing.
 *  Purpose: To get Touch base updated information.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)touchBaseDataRefreshing 
{
    int pageNumber = 0;
    NSString *string = [NSString stringWithFormat:@"&PageNumber=%d",pageNumber];
    objParser = nil;
    if (!objParser) 
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    [objParser parseJson:TouchBaseAPI :string];  
}
/*******************************************************************************
 *  Function Name: setCustomOverlay.
 *  Purpose: To init syncing.
 *  Parametrs: nil.
 *  Return Values: nil.
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
/*******************************************************************************
 *  Function Name: transitionFlipFromRight.
 *  Purpose: To flip the view from right if any new discussion comes after refresh button touch.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)transitionFlipFromRight
{
    if ([self.touchBaseDataManagerArray count] > 0 && istouchBaseRefreshButtonTouched && isNewDiscussion)
    {
        [syncView removeFromSuperview];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)forView:self.view cache:YES];
        [UIView commitAnimations];
        
        istouchBaseRefreshButtonTouched = NO;
        isNewDiscussion = NO;
    }
    else
    {
        [syncView removeFromSuperview];
    }
    
}
#pragma mark-
/*******************************************************************************
 *  Function Name: getTouchBaseList.
 *  Purpose: To get Touch base infomation pagevise.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)getTouchBaseList
{
    int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"TouchBasePageNumber"] intValue];
    
    NSString *string = [NSString stringWithFormat:@"&PageNumber=%d",pageNumber];
    
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    [objParser parseJson:TouchBaseAPI :string];
}
#pragma mark- Button Actions
/*******************************************************************************
 *  To start Discussion View.
 ********************************************************************************/
- (IBAction)startDiscussionBtnTouched:(id)sender
{
    StartDiscussionViewController *detailViewController = [[StartDiscussionViewController alloc] initWithNibName:@"StartDiscussionViewController"
                                                                                                          bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
}

/*******************************************************************************
 *  Refresh button touch action.
 ********************************************************************************/
- (IBAction)touchBaseRefreshBtnTouched:(id)sender
{
    [self.refreshButton setUserInteractionEnabled:NO];
    [self setCustomOverlay];
    istouchBaseRefreshButtonTouched = YES;
    
    [self touchBaseDataRefreshing];
}

#pragma mark - UITable view data source
/*******************************************************************************
 *  UITable view data source.
 ********************************************************************************/
- (CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.touchBaseDataManagerArray count];
    int rowCount = 0;
    
    NSLog(@"%d",count);
    
    if (enablePagination)
    {
        rowCount = count + 1;
    }
    else
    {
        rowCount = count;
    }
    NSLog(@"%d",rowCount);
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = nil;
    
    int count = [self.touchBaseDataManagerArray count];
    //Checking if this is the pagination cell
    if (indexPath.row < count)
    {
        CustomTouchBaseTableViewCell *touchBaseCell = (CustomTouchBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (touchBaseCell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CustomTouchBaseTableViewCell" owner:self options:nil];
            touchBaseCell = customTouchBaseTableViewCell;
            self.customTouchBaseTableViewCell = nil;
        }
        if([self.touchBaseDataManagerArray count] > 0)
        {
            [touchBaseCell displayDetails:[self.touchBaseDataManagerArray objectAtIndex:indexPath.row]];
        }
        touchBaseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = touchBaseCell;
    }
    else
    {
        static NSString *loadMoreIdentifier = @"LoadNextCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:loadMoreIdentifier];
        loadMoreCells = [[UIActivityIndicatorView alloc]
                         initWithFrame:CGRectMake(0, 0, 25, 25)];
        
        [loadMoreCells setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        loadMoreCells.userInteractionEnabled = NO;
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier: loadMoreIdentifier];
            [loadMoreCells startAnimating];
            [cell addSubview:loadMoreCells];
            cell.userInteractionEnabled = NO;
            loadMoreCells.center = CGPointMake(160, 22);
            
        }
    }
    return cell;
}
#pragma mark - UITable view delegate
/*******************************************************************************
 *  UITable view delegate.
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TouchBaseDetailsViewController *touchBaseDetailsViewController=[[TouchBaseDetailsViewController alloc] initWithNibName:@"TouchBaseDetailsViewController"
                                                                                                                    bundle:nil];
    touchBaseDetailsViewController.touchBaseManagerArr = self.touchBaseDataManagerArray;
    touchBaseDetailsViewController.swipeCount = indexPath.row;
    [self.navigationController pushViewController:touchBaseDetailsViewController animated:YES];
    touchBaseDetailsViewController = nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [self.touchBaseDataManagerArray count];
    
    if (indexPath.row == count)
    {
        
        [self getTouchBaseList];
    }
}

#pragma mark- Parser Delegates
/*******************************************************************************
 *  Function Name: parseCompleteSuccessfully,parseFailedWithError.
 *  Purpose: To delegate the json parser.
 *  Parametrs:Array of resulted parserObject.
 *  Return Values:nil.
 ********************************************************************************/
-(void)parseCompleteSuccessfully:(ParseServiseType) eparseType:(NSArray *)result
{
    [self.refreshButton setUserInteractionEnabled:YES];
    if( eparseType == TouchBaseAPI)
    {
        if ([result count] == 0)
        {
            [syncView removeFromSuperview];
            enablePagination = NO;
            [loadMoreCells stopAnimating];
            objParser.delegate = nil;
            objParser = nil;
            [self.touchBaseTableView reloadData];
        }
        else
        {
            if ([result count]>0)
            {
                int resultCount = [result count];
                for (int i = 0; i <resultCount; i ++)
                {
                    if ( [self.touchBaseDataManagerArray containsObject:[result objectAtIndex:i]])
                    {
                        NSLog(@"searchresults==%@",[result objectAtIndex:i]);
                    }
                    else
                    {
                        [self.touchBaseDataManagerArray addObject:[result objectAtIndex:i]];
                        isNewDiscussion = YES;
                    }
                }
                if(istouchBaseRefreshButtonTouched)
                {
                    NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"discussionDate" ascending:NO];
                    NSArray *newDiscussionArray = [self.touchBaseDataManagerArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
                    if ([self.touchBaseDataManagerArray count])
                    {
                        [self.touchBaseDataManagerArray removeAllObjects];
                    }
                    [self.touchBaseDataManagerArray addObjectsFromArray:newDiscussionArray];
                    
                    //reset the touch base number to 1
                    int pageNumber = 1;
                    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"TouchBasePageNumber"];
                }

                [self transitionFlipFromRight];
                [self.touchBaseTableView reloadData];
            }
        }
    }
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    [GeneralClass showAlertView:self
                            msg:nil
                          title:@"Parse with error. Try again?"
                    cancelTitle:@"YES"
                     otherTitle:@"NO"
                            tag:parseErrorTag];
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
    else if (alertView.tag == parseErrorTag)
    {
        if(buttonIndex == 0)
        {
            [self touchBaseDataRefreshing];
        }
        else
        {
            [syncView removeFromSuperview];
            [self.refreshButton setUserInteractionEnabled:YES];
        }
    }
    alertView = nil;
}

#pragma mark- Memory
- (void)viewDidUnload
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

#pragma mark- dealloc
-(void) dealloc
{
    [self setTouchBaseTableView:nil];
    [self setCustomTouchBaseTableViewCell:nil];
    [self setTouchBase:nil];
}

#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
