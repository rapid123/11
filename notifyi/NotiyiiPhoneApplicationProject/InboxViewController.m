
//
//  InboxViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InboxViewController.h"
#import "GeneralClass.h"
#import "SendMessageViewController.h"
#import "DataManager.h"
#import "InboxDetailsViewController.h"
#import "MsgRecipient.h"
#import "Directory.h"
#import "AppDelegate.h"
#import <QuartzCore/CoreAnimation.h>

#define MAIL_ARRAY [NSArray arrayWithObjects: @"Sent Mail",@"Inbox",@"Draft",@"Trash",nil]

JsonParser *objParser;

@interface InboxViewController ()
{
    DataManager *dataManager;
    messageType currentMsgtype;
    UIView *syncView;
    BOOL isSearchedResult;
    BOOL enablePagination;
    BOOL isScrollingPage;
    BOOL isNewMessage;
    UIActivityIndicatorView *loadMoreCells;
    NSUserDefaults *standardUserDefaults;
    NSString * searchText;
}

-(void)searchBarTextClearButtonTouched;
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)sortItemSelected:(int)msgType;
-(void)setCustomOverlay;
-(void)getInboxList;
-(void)searchMessagesInboxAPI;
-(void)setUnreadMessagesCountAsBadgeCount;
-(void)transitionFlipFromRight;
-(void)addNewDetailsToInboxDataManegerArray:(NSArray *)newDetails;

-(IBAction)composeButtonClicked:(id)sender;
-(IBAction)listButtonTouched:(id)sender;
-(IBAction)refreshButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (nonatomic,strong) NSMutableArray *inboxDataManagerArray;
@end

BOOL isRefreshButtonTouched;

@implementation InboxViewController
@synthesize refreshButton;
@synthesize inboxLabel;
@synthesize inboxTableView;
@synthesize inboxSearchBar;
@synthesize inbox;
@synthesize inboxTableViewCell;
@synthesize inboxDataManagerArray;

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Inbox";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_Inbox"];
        inboxSearchBar.delegate = self;
    }
    return self;
}

#pragma mark- ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inboxDataManagerArray = [[NSMutableArray alloc]init];
    enablePagination =YES;
    isRefreshButtonTouched = NO;
    self.navigationController.navigationBarHidden = YES;
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //starts with inbox data.
    currentMsgtype = inboxMsg;
    
    inboxSearchBar.tintColor = [UIColor blackColor];
    inboxSearchBar.delegate = self;
    
    
    [self searchBarTextClearButtonTouched];
    
    //background color setting for UISearchBar
    GeneralClass *generalClass = [[GeneralClass alloc]init];
    [generalClass searchBarBackGroundColorSetting:self.inboxSearchBar];
    generalClass = nil;
    
    self.inboxLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self getInboxInformation];
    [self.inboxTableView reloadData];
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name:inboxTabbarTouched.
 *  Purpose: To show InboxMessages when user touches inbox tabbar.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)inboxTabbarTouched
{
    if (currentMsgtype!=inboxMsg)
    {
        currentMsgtype = inboxMsg;
        [self getInboxInformation];
    }
    
}

#pragma mark- Initialization and reload
/*******************************************************************************
 *  Function Name:getInboxInformation.
 *  Purpose: To get selected msgType information from Database.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)getInboxInformation
{
    self.inboxLabel.text = [MAIL_ARRAY objectAtIndex:currentMsgtype];
    if(isSearchedResult)
    {
        isSearchedResult = NO;
        [self.inboxTableView reloadData];
    }
    else
    {
        NSLog(@"inboxDataManangerCount==%d",[self.inboxDataManagerArray count]);
        if([self.inboxDataManagerArray count])
        {
            [self.inboxDataManagerArray removeAllObjects];
        }
        
        if (!dataManager)
        {
            
            dataManager = [[DataManager alloc]init];
        }
        NSArray *result = [dataManager getWholeInboxDetails:currentMsgtype];
        NSLog(@"result array == %@",result);
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSArray *newMessageArray = [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
        NSLog(@"newMessageArray == %@",newMessageArray);
        
        [self.inboxDataManagerArray addObjectsFromArray:newMessageArray];
        [self transitionFlipFromRight];
        NSLog(@"inboxDataManagerArray count == %d",[self.inboxDataManagerArray count]);
        
        //setting the Badge Value
        [self setUnreadMessagesCountAsBadgeCount];
        [self.inboxTableView reloadData];
        int noOfRows = [self.inboxTableView numberOfRowsInSection:0];
        NSLog(@"noOfRows==%d",noOfRows);
        if(noOfRows>0)
        {
            [self.inboxTableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    
}

- (void)setUnreadMessagesCountAsBadgeCount
{
    int badgeCount;
    AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (currentMsgtype == inboxMsg)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.readStatus = 0"];
        
        NSArray *unReadMessages = [self.inboxDataManagerArray filteredArrayUsingPredicate:predicate];
        
        badgeCount = [unReadMessages count];
    }
    else
    {
        badgeCount = 0;
    }
    
    [app setTabTabBarBadge:badgeCount];
}

#pragma mark- Sort Item Select Delegate
- (void)sortItemSelected:(int)msgType
{
    currentMsgtype = msgType;
    [self getInboxInformation];
}

#pragma mark- Button Actions
/*******************************************************************************
 *  Inorder to navigate Sendmessage viewcontroller.
 ********************************************************************************/
- (IBAction)composeButtonClicked:(id)sender
{
    [inboxSearchBar resignFirstResponder];
    SendMessageViewController *detailViewController=[[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController"
                                                                                                bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController = nil;
}

/*******************************************************************************
 *  Users can select the different message type from the listview Controller.
 ********************************************************************************/
- (IBAction)listButtonTouched:(id)sender
{
    self.inboxSearchBar.text = @"";
    [self.inboxSearchBar resignFirstResponder];
    ListMenuViewController *listMenuViewController=[[ListMenuViewController alloc] initWithNibName:@"ListMenuViewController"
                                                                                            bundle:nil];
    listMenuViewController.delegate = self;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:listMenuViewController animated:YES];
    listMenuViewController = nil;
}

/*******************************************************************************
 *  Refreshing entire TableView data.
 ********************************************************************************/
- (IBAction)refreshButtonClicked:(id)sender
{
    
    if(isSearchedResult)
    {
        searchText = self.inboxSearchBar.text;
    }
    else
    {
        self.inboxSearchBar.text = @"";
        
    }
    [self.inboxSearchBar resignFirstResponder];
    [self.inboxSearchBar setShowsCancelButton:NO animated:NO];
    [self.refreshButton setUserInteractionEnabled:NO];
    [self setCustomOverlay];
    isRefreshButtonTouched = YES;
    [self inboxDataRefreshing];
    
}

#pragma mark- Common Methods
/*******************************************************************************
 *  Function Name: inboxDataRefreshing.
 *  Purpose: To get refresh inbox data.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)inboxDataRefreshing
{
    if (isSearchedResult)
    {
        //if search result then call search API
        [self searchMessagesInboxAPI];
    }
    else
    {
        int pageNumber = 0;
        NSString *string = [NSString stringWithFormat:@"&PageNumber=%d&searching=0&SearchToken=",pageNumber];
        
        objParser = nil;
        if (!objParser)
        {
            objParser=[[JsonParser alloc] init];
            objParser.delegate=self;
            objParser.APIType = AllInboxAPI;
        }
        [objParser parseJson:InboxAPI :string];
    }
}

/*******************************************************************************
 *  SearchBar Clear Button Actions.
 ********************************************************************************/
-(void)searchBarTextClearButtonTouched
{
    for (UIView *view in inboxSearchBar.subviews)
    {
        if ([view isKindOfClass: [UITextField class]])
        {
            UITextField *textField = (UITextField *)view;
            
            textField.delegate = self;
            
            break;
        }
        
    }
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
/*******************************************************************************
 *  Function Name: searchMessagesInboxAPI.
 *  Purpose: To call SearchAPI.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)searchMessagesInboxAPI
{
    int pageNumber;
    if (isScrollingPage)
    {
        //update search results
        pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"InboxSearchPageNumber"] intValue];
    }
    else
    {
        //start search with page number 0
        pageNumber = 0;
    }
    NSString *string = [NSString stringWithFormat:@"&PageNumber=%d&searching=1&SearchToken=%@",pageNumber,searchText];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.APIType = SearchInboxAPI;
        objParser.delegate = self;
    }
    [objParser parseJson:InboxAPI :string];
}
/*******************************************************************************
 *  Function Name: addNewDetailsToInboxDataManegerArray.
 *  Purpose: To add newdetails to inboxdata manager array
 *  Parametrs:new details array as input.
 *  Return Values:nil.
 ********************************************************************************/
-(void)addNewDetailsToInboxDataManegerArray:(NSArray *)newDetails
{
    int resultCount = [newDetails count];
    if([newDetails count])
    {
        for (int i = 0; i <resultCount; i ++)
        {
            if ( [self.inboxDataManagerArray containsObject:[newDetails objectAtIndex:i]])
            {
                NSLog(@"searchresults==%@",[newDetails objectAtIndex:i]);
            }
            else
            {
                [self.inboxDataManagerArray addObject:[newDetails objectAtIndex:i]];
                isNewMessage = YES;
            }
        }
    }
    if(isRefreshButtonTouched)
    {
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSArray *newMessageArray = [self.inboxDataManagerArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
        if ([self.inboxDataManagerArray count])
        {
            [self.inboxDataManagerArray removeAllObjects];
        }
        
        [self.inboxDataManagerArray addObjectsFromArray:newMessageArray];
    }
    [self transitionFlipFromRight];
}

/*******************************************************************************
 *  Function Name: transitionFlipFromRight.
 *  Purpose: To give transitionflip from right if refresh success.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
-(void)transitionFlipFromRight
{
    if ([self.inboxDataManagerArray count] > 0 && isRefreshButtonTouched && isNewMessage)
    {
        [syncView removeFromSuperview];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        [UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromRight)forView:self.view cache:YES];
        [UIView commitAnimations];
        isNewMessage = NO;
        isRefreshButtonTouched = NO;
    }
    else
    {
        [syncView removeFromSuperview];
        isRefreshButtonTouched = NO;

    }
}

#pragma mark-
/*******************************************************************************
 *  Function Name: getInboxList.
 *  Purpose: To get whole inbox details page vise.
 *  Parametrs:nil.
 *  Return Values:nil.
 ********************************************************************************/
- (void)getInboxList
{
    int pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"InboxPageNumber"] intValue];
    
    NSString *string = [NSString stringWithFormat:@"&PageNumber=%d&searching=0&SearchToken=",pageNumber];
    
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
        objParser.APIType = AllInboxAPI;
    }
    [objParser parseJson:InboxAPI :string];
    
}
#pragma mark- BackGroundTouch Actions
/*******************************************************************************
 *  Function Name: touchesBegan.
 *  Purpose: To delegate back ground touch events.
 *  Parametrs:event.
 *  Return Values:nil.
 ********************************************************************************/
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"Background touched");
	[inboxSearchBar resignFirstResponder];
}

#pragma mark - Table view data source
/*******************************************************************************
 *  UITable view data source.
 ********************************************************************************/
- (CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.inboxDataManagerArray count];
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
    
    int count = [self.inboxDataManagerArray count];
    //Checking if this is the pagination cell
    if (indexPath.row < count)
    {
        InboxTableViewCell *inboxCell = (InboxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (inboxCell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"InboxTableViewCell"
                                          owner:self
                                        options:nil];
            inboxCell = inboxTableViewCell;
            self.inboxTableViewCell = nil;
        }
        if([self.inboxDataManagerArray count] > 0)
        {
            [inboxCell displayDetails:[self.inboxDataManagerArray objectAtIndex:indexPath.row]];
        }
        inboxCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = inboxCell;
    }
    else
    {
        static NSString *loadMoreIdentifier = @"LoadNextCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:loadMoreIdentifier];
        loadMoreCells = [[UIActivityIndicatorView alloc]
                         initWithFrame:CGRectMake(0, 0, 25, 25)];
        
        [loadMoreCells setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
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

#pragma mark - Table view delegate
/*******************************************************************************
 *  UITable view delegates.
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [inboxSearchBar resignFirstResponder];
    Inbox *inboxObj = [self.inboxDataManagerArray objectAtIndex:indexPath.row];
    if([inboxObj.messageType isEqualToNumber:[NSNumber numberWithInt:2]])
    {
        SendMessageViewController *sendMessageViewController=[[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController"
                                                                                                         bundle:nil];
        [self.navigationController pushViewController:sendMessageViewController animated:YES];
        [sendMessageViewController beginWithReplyAction:draftPassID inbox:inboxObj];
        sendMessageViewController = nil;
    }
    else
    {
        InboxDetailsViewController *inboxDetailsViewController=[[InboxDetailsViewController alloc] initWithNibName:@"InboxDetailsViewController"
                                                                                                            bundle:nil];
        inboxDetailsViewController.inboxManagerArr = self.inboxDataManagerArray;
        inboxDetailsViewController.swipeCount = indexPath.row;
        [self.navigationController pushViewController:inboxDetailsViewController animated:YES];
        inboxDetailsViewController = nil;
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [self.inboxDataManagerArray count];
    
    if (indexPath.row == count)
    {
        if (isSearchedResult)
        {
            isScrollingPage = YES;
            [syncView removeFromSuperview];
            [self searchMessagesInboxAPI];
        }
        else
        {
            [self getInboxList];
        }
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
    [syncView removeFromSuperview];
    [self.refreshButton setUserInteractionEnabled:YES];
    
    if( eparseType == InboxAPI)
    {
        if ([result count] == 0)
        {
            enablePagination = NO;
            [loadMoreCells stopAnimating];
            [inboxTableView reloadData];
            int noOfRows = [self.inboxTableView numberOfRowsInSection:0];
            NSLog(@"noOfRows==%d",noOfRows);
            if(noOfRows>0)
            {
                [self.inboxTableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }            
            if (isSearchedResult)
            {
                if(isScrollingPage)
                {
                    isScrollingPage = NO;
                }
                else
                {
                    [GeneralClass showAlertView:self
                                            msg:NSLocalizedString(@"NO RESULT FOUND", nil)
                                          title:nil
                                    cancelTitle:@"OK"
                                     otherTitle:nil
                                            tag:noTag];
                    
                }
            }
            objParser.delegate = nil;
            objParser = nil;
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageType = %d",currentMsgtype];
            NSArray *searchResults = [result filteredArrayUsingPredicate:predicate];
            
            if([searchResults count] > 0)
            {
                if( eparseType == InboxAPI)
                {
                    if(objParser.APIType == SearchInboxAPI)
                    {
                        if(isScrollingPage)
                        {
                            [self addNewDetailsToInboxDataManegerArray:searchResults];
                            [self.inboxTableView reloadData];
                        }
                        else
                        {
                            if([self.inboxDataManagerArray count])
                            {
                                [self.inboxDataManagerArray removeAllObjects];
                            }
                            [self.inboxDataManagerArray addObjectsFromArray:searchResults];
                            [self.inboxTableView reloadData];
                            //if refersh button touched with search result reset search page number to 1
                            if(isRefreshButtonTouched)
                            {
                                int pageNumber = 1;
                                [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"InboxSearchPageNumber"];
                                
                            }
                        }
                    }
                    else
                    {
                        //if refersh button touched set page number to 1
                        if(isRefreshButtonTouched)
                        {
                            int pageNumber = 1;
                            [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"InboxPageNumber"];
                            
                            NSArray *currentMessageArray = [dataManager getWholeInboxDetails:currentMsgtype];
                            NSMutableArray *oldMessageArray = [[NSMutableArray alloc]init];
                            
                            int resultCount = [currentMessageArray count];
                            for (int i = 0; i < resultCount; i ++)
                            {
                                Inbox *inboxMsgCurrentType = [currentMessageArray objectAtIndex:i];
                                
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageId = %d",[inboxMsgCurrentType.messageId intValue]];
                                NSArray *messageEntityObject = [searchResults filteredArrayUsingPredicate:predicate];
                                if ([messageEntityObject count] == 0)
                                {
                                    [DataManager deleteMangedObject:inboxMsgCurrentType];
                                    [DataManager saveContext];

                                }
                                else
                                {
                                    [oldMessageArray addObject:inboxMsgCurrentType];
                                }
                                
                            }
                            if([self.inboxDataManagerArray count])
                            {
                                [self.inboxDataManagerArray removeAllObjects];
                            }
                            [self addNewDetailsToInboxDataManegerArray:searchResults];
                        }
                        
                    }
                    
                }
            }
            else if(objParser.APIType == SearchInboxAPI){
                [GeneralClass showAlertView:self
                                        msg:NSLocalizedString(@"NO RESULT FOUND", nil)
                                      title:nil
                                cancelTitle:@"OK"
                                 otherTitle:nil
                                        tag:noTag];
                
            }
            if([searchResults count] ==0 && isRefreshButtonTouched)
            {
                
                NSArray *currentMessageArray = [dataManager getWholeInboxDetails:currentMsgtype];
                int resultCount = [currentMessageArray count];
                for (int i = 0; i < resultCount; i ++)
                {
                    Inbox *inboxMsgCurrentType = [currentMessageArray objectAtIndex:i];
                    [DataManager deleteMangedObject:inboxMsgCurrentType];
                }
                NSArray *wholeInboxdetails = [dataManager getWholeInboxDetails:currentMsgtype];
                if([self.inboxDataManagerArray count])
                {
                    [self.inboxDataManagerArray removeAllObjects];
                }
                [self.inboxDataManagerArray addObjectsFromArray:wholeInboxdetails];
                [self addNewDetailsToInboxDataManegerArray:searchResults];
            }
            [self setUnreadMessagesCountAsBadgeCount];
            [self transitionFlipFromRight];
            [inboxTableView reloadData];
        }
    }
}
-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    if(eparseType == InboxAPI)
    {
        [GeneralClass showAlertView:self
                                msg:nil
                              title:@"Parse with error. Try again?"
                        cancelTitle:@"YES"
                         otherTitle:@"NO"
                                tag:parseErrorTag];
    }
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
        if (buttonIndex == 0)
        {
            [self inboxDataRefreshing];
        }
        else
        {
            [syncView removeFromSuperview];
            [loadMoreCells stopAnimating];
            [self.refreshButton setUserInteractionEnabled:YES];
        }
    }
    alertView = nil;
}
#pragma mark- Search Bar Text Delegates And Methods
/*******************************************************************************
 *  UISearch Bar Text Delegates And Methods.
 ********************************************************************************/
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self setCustomOverlay];
    searchText = searchBar.text;
    NSLog(@"%@",searchText);
    //saving all inbox details to a temp array for local db searching
    
    NSMutableArray *inboxDetailsArray = [[NSMutableArray alloc]init];
    NSArray *currentMessageDetailsArray = [dataManager getWholeInboxDetails:currentMsgtype];
    [inboxDetailsArray addObjectsFromArray:currentMessageDetailsArray];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *blackSpace = [searchText stringByTrimmingCharactersInSet:whitespace];
    
    if([blackSpace length] == 0)
    {
        [self.inboxTableView reloadData];
        [syncView removeFromSuperview];
        searchBar.text = @"";
    }
    else
    {
        isSearchedResult = YES;
        
        NSLog(@"self.inboxDataManagerArrayBeforeSearch===%d",[self.inboxDataManagerArray count]);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject CONTAINS[cd] %@",searchText];
        NSArray *searchResults = [inboxDetailsArray filteredArrayUsingPredicate:predicate];
        
        if ([searchResults count] > 0)
        {
            enablePagination = NO;
            
            if([self.inboxDataManagerArray count])
            {
                [self.inboxDataManagerArray removeAllObjects];
            }
            [self.inboxDataManagerArray addObjectsFromArray:searchResults];
            
            [syncView removeFromSuperview];
            NSLog(@"self.inboxDataManagerArrayAfterSearch===%d",[self.inboxDataManagerArray count]);
        }
        else//Search string not found locally
        {
            [self searchMessagesInboxAPI];
        }
        inboxDetailsArray = nil;
        [self.inboxTableView reloadData];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    /*  if(self.inboxDataManagerArray)
     {
     [self.inboxDataManagerArray removeAllObjects];
     }
     self.inboxDataManagerArray = (NSMutableArray *)[dataManager getWholeInboxDetails:currentMsgtype];
     
     */
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    enablePagination = YES;
    isSearchedResult = NO;
    
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:NO];
    
    if([self.inboxDataManagerArray count])
    {
        [self.inboxDataManagerArray removeAllObjects];
    }
    NSArray *inboxInfoArray = [dataManager getWholeInboxDetails:currentMsgtype];
    
    [self.inboxDataManagerArray addObjectsFromArray:inboxInfoArray];
    [self.inboxTableView reloadData];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	//Showing Done key on Keyboard
    for (UIView *searchBarSubview in [searchBar subviews])
    {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)])
        {
            
            @try
            {
                [(UITextField *)searchBarSubview setClearButtonMode:UITextFieldViewModeWhileEditing];
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            @catch (NSException * e)
            {
                // ignore exception
            }
        }
    }
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:NO];
}

/*******************************************************************************
 *  Function Name: textFieldShouldClear.
 *  Purpose: To Clear UIsearchBar textfield.
 *  Parametrs: textField object.
 *  Return Values:BOOL.
 ********************************************************************************/
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    enablePagination = YES;
    isSearchedResult = NO;
    self.inboxSearchBar.text = @"";
    return YES;
}


#pragma mark- Unload
-(void)viewDidUnload
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
}
-(void)dealloc
{
    inboxTableView = nil;
    inboxSearchBar = nil;
    inbox = nil;
    inboxTableViewCell = nil;
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

