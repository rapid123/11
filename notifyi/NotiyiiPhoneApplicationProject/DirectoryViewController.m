
//
//  DirectoryViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectoryViewController.h"
#import "GeneralClass.h"
#import "DirectoryDetailsViewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "Directory.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "State.h"
#import "JsonParser.h"

@interface DirectoryViewController ()
{
    DataManager *dataManager;
    IBOutlet UILabel *directoryLabel;
    int identifyFlag;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *popOverButton;
    popOverViewController *popOverView;
    NSMutableArray *iconImageArray;
    NSMutableArray *imageArray;
    bool anyRowSelected;
    NSMutableData *downloadData;
    BOOL reachableFlag;
    BOOL isScrollingPage;
    NSMutableArray *stateObjectsArray;
    JsonParser *objParser;
    UIView *syncView;
    BOOL isSearchedResult;
    State *state;
    NSString *searchText;
    NSString *searchState;
    int errorParseType;
    UIActivityIndicatorView *loadMoreCells;
}

@property (strong, nonatomic) IBOutlet UISearchBar *directorySearchBar;
@property (strong, nonatomic) IBOutlet UITableView *directorytableView;
@property (strong, nonatomic) Directory *directory;
@property (strong, nonatomic) NSString *cachePath;
@property (nonatomic,strong) NSMutableArray *directoryDataManagerArray;


-(void)initialize;
-(void)readStatesFromCSVFile;
-(void)searchBarTextClearButtonTouched;
-(void)getDirectoryInformation;
-(void)downloadimages;
-(void)stateSelected:(NSString *)result;
-(void)setCustomOverlay;
-(void)callSingleDirectoryDetailAPI:(NSNumber*)directoryId;
-(void)directoryDetailsView:(NSArray *)directoryArray directorySelectedNumber:(int)directoryId;
-(void)getDirectoryList;
-(void)searchDirectoryAPI;
-(void)addNewDetailsToDirectoryDataManagerArray:(NSArray *)newDetails;
-(void)callDirectoryAPI:(NSString *)string;

-(IBAction)doneButtonTouched:(id)sender;
-(IBAction)popOverStateNameButtonTouched:(id)sender;

@end

@implementation DirectoryViewController
@synthesize directorySearchBar;
@synthesize directorytableView;
@synthesize directory;
@synthesize delegate;
@synthesize customDirectoryCell;
@synthesize selectedPhysicianIdArray;
@synthesize cachePath;
@synthesize toAndCcFlag;
@synthesize presentDirectoryId;
@synthesize directoryDataManagerArray;
@synthesize userStateDirectoryListArray;
#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Directory";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_Directory"];
    }
    return self;
}

#pragma mark- Initial Load
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    self.directoryDataManagerArray = [[NSMutableArray alloc]init];
    //    self.userStateDirectoryListArray = [[NSArray alloc]init];
    enablePagination = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self readStatesFromCSVFile];
    
    [self testReachability];
    
    [self searchBarTextClearButtonTouched];
    
    [self initialize];
    //[self getImageArray];
    currentState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
    //currentState = @"ALL";
    [popOverButton setTitle:currentState forState:UIControlStateNormal];
    NSLog(@"selectedPhysicianIdArray count === %d",[selectedPhysicianIdArray count]);//this Array should take as 'To' field members.
    
    if(!selectedPhysicianIdArray)
    {
        selectedPhysicianIdArray = [[NSMutableArray alloc]init];
    }
    
    NSLog(@"selectionTracker === %@",selectedPhysicianIdArray);
}

-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    anyRowSelected=NO;
    NSLog(@"currentState==%@",currentState);
    if(!isSearchedResult)
    {
        self.directorySearchBar.text = @"";
        [self.directorySearchBar resignFirstResponder];
        [self.directorySearchBar setShowsCancelButton:NO animated:NO];
        //        [popOverButton setTitle:currentState forState:UIControlStateNormal];
        //[self getDirectoryInformation];
    }
}

#pragma mark- Methods
/*******************************************************************************
 *  Function Name: initialize.
 *  Purpose: To set font for controllers.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)initialize
{
    //search bar background color setting
    GeneralClass *generalClass = [[GeneralClass alloc]init];
    [generalClass searchBarBackGroundColorSetting:self.directorySearchBar];
    generalClass = nil;
    directoryLabel.font = [GeneralClass getFont:titleFont and:boldFont];
    doneButton.titleLabel.font = [GeneralClass getFont:buttonFont and:regularFont];
    popOverButton.titleLabel.font = [GeneralClass getFont:customNormal and:boldFont];
    popOverButton.titleLabel.textAlignment = UITextAlignmentLeft;
    [popOverButton setTitleColor:[UIColor colorWithRed:0.6 green:0.8 blue:0.8 alpha:1] forState:UIControlStateNormal];
    //    [popOverButton setTitle:@"ALL" forState:UIControlStateNormal];
    if(identifyFlag)//came from selection.
    {
        [doneButton setHidden:NO];
    }
    else//normal
    {
        [doneButton setHidden:YES];
    }
}
-(void) beginWithAddParticipants:(int)falgValue
{
    NSLog(@"falgValue === %d",falgValue);
    identifyFlag = falgValue;
}

/*******************************************************************************
 *  Function Name: updateselectedPhysicianIdArray.
 *  Purpose: To Update the selected Physician id.
 *  Parametrs: directory physician id.
 *  Return Values: nil.
 ********************************************************************************/
-(void) updateselectedPhysicianIdArray:(NSNumber *)dirPhysicianId
{
    NSLog(@"dirPhysicianId == %@",dirPhysicianId);
    NSLog(@"selectedPhysicianIdArray === %@",selectedPhysicianIdArray);
    
    if ([selectedPhysicianIdArray containsObject:dirPhysicianId])
    {
        NSLog(@"YES");
        [selectedPhysicianIdArray removeObject:dirPhysicianId];
    }
    else
    {
        NSLog(@"NO");
        [selectedPhysicianIdArray addObject:dirPhysicianId];
    }
    NSLog(@"selectedPhysicianIdArray === %@",selectedPhysicianIdArray);
    [self. directorytableView reloadData];
}

/*******************************************************************************
 *  Function Name: existImage.
 *  Purpose: To check image is exixsting in Cache??.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
-(BOOL)existImage:(NSString *)name
{
    NSString *path = [self getPathDocAppendedBy:name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return fileExists;
}

/*******************************************************************************
 *  Function Name: getPathDocAppendedBy.
 *  Purpose: To Get the Cache path.
 *  Parametrs: image name.
 *  Return Values: nil.
 ********************************************************************************/
-(NSString *)getPathDocAppendedBy:(NSString *)_appString
{
	NSString* documentsPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"IMAGES"];
    NSString* foofile = [documentsPath stringByAppendingPathComponent:_appString];
    
	return foofile;
}

/*******************************************************************************
 *  Function Name: callSingleDirectoryDetailAPI.
 *  Purpose: To Get the selected physician's details from server.
 *  Parametrs: directory Id.
 *  Return Values: nil.
 ********************************************************************************/
-(void)callSingleDirectoryDetailAPI:(NSNumber*)directoryId
{
    [self setCustomOverlay];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate=self;
    }
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *recipientId = [NSString stringWithFormat:@"%i", [directoryId intValue]];
    NSString *operationType = [NSString stringWithFormat:@"%i", SingleDirectoryDetail];;
    
    NSString *string = [NSString stringWithFormat:@"?userId=%@&operationType=%@&RecipientId=%@",userID,operationType,recipientId];
    NSLog(@"SingleDirectoryParameters==%@",string);
    [objParser parseJson:SingleDirectoryDetail :string];
    
}
/*******************************************************************************
 *  Function Name: directoryDetailsView.
 *  Purpose: To show the selected physician's details view.
 *  Parametrs: directory Id and details as array.
 *  Return Values: nil.
 ********************************************************************************/
- (void)directoryDetailsView:(NSArray *)directoryArray directorySelectedNumber:(int)directoryId
{
    DirectoryDetailsViewController *directoryDetailsViewController=[[DirectoryDetailsViewController alloc] initWithNibName:@"DirectoryDetailsViewController" bundle:nil];
    directoryDetailsViewController.directoryManagerArr = directoryArray;
    directoryDetailsViewController.selectedDirectoryNumber = directoryId;
    [self.navigationController pushViewController:directoryDetailsViewController animated:YES];
    directoryDetailsViewController = nil;
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
 *  Function Name: addNewDetailsToDirectoryDataManagerArray.
 *  Purpose: To add newdetails to directory data manager array
 *  Parametrs:new details array as input.
 *  Return Values:nil.
 ********************************************************************************/
-(void)addNewDetailsToDirectoryDataManagerArray:(NSArray *)newDetails
{
    int resultCount = [newDetails count];
    for (int i = 0; i <resultCount; i ++)
    {
        if ( [self.directoryDataManagerArray containsObject:[newDetails objectAtIndex:i]])
        {
            NSLog(@"searchresults==%@",[newDetails objectAtIndex:i]);
        }
        else
        {
            [self.directoryDataManagerArray addObject:[newDetails objectAtIndex:i]];
        }
    }
}

#pragma mark- Reachability Test
-(void) testReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE");
            reachableFlag = 1;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"NOT REACHABLE");
            reachableFlag = 0;
        });
    };
    
    [reach startNotifier];
}
-(void) getImageArray
{
    if(imageArray)
    {
        imageArray = nil;
    }
    imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [self.directoryDataManagerArray count]; i++)
    {
        Directory *direc = [self.directoryDataManagerArray objectAtIndex:i];
        if([direc.physicianImage length])
        {
            [imageArray addObject:direc.physicianImage];
        }
        else
        {
            [imageArray addObject:[NSNull null]];
        }
    }
    [self downloadimages];
}

/*******************************************************************************
 *  Function Name: getDirectoryInformation.
 *  Purpose: To get data from database.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)getDirectoryInformation
{
    NSString* userState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
    if ([popOverButton.titleLabel.text isEqualToString:userState]||[popOverButton.titleLabel.text isEqualToString:@""])
    {
        if([self.directoryDataManagerArray count])
        {
            NSArray *userStateDetails = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"state"];
            NSLog(@"userStateDetails==%@",userStateDetails);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.state = %@",userState];
            NSArray *searchResults = [userStateDetails filteredArrayUsingPredicate:predicate];
            if([searchResults count])
            {
                [self.directoryDataManagerArray removeAllObjects];
                [self.directoryDataManagerArray addObjectsFromArray:searchResults];
                //[self getImageArray];
                [self.directorytableView reloadData];
            }
            else
            {
                [self getDirectoryList];
            }
        }
        else
        {
            [self getDirectoryList];
        }
    }
    else if([popOverButton.titleLabel.text isEqualToString:@"ALL"])
    {
        NSArray *allDirectoryDetails = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"state"];
        if([self.directoryDataManagerArray count])
        {
            [self.directoryDataManagerArray removeAllObjects];
            [self.directoryDataManagerArray addObjectsFromArray:allDirectoryDetails];
            //[self getImageArray];
            [self.directorytableView reloadData];
        }
        else
        {
            [self.directoryDataManagerArray addObjectsFromArray:allDirectoryDetails];
            //[self getImageArray];
            [self.directorytableView reloadData];
        }
    }
    else if(![popOverButton.titleLabel.text isEqualToString:@"ALL"] && ![popOverButton.titleLabel.text isEqualToString:userState]&&![popOverButton.titleLabel.text isEqualToString:@""])
    {
        NSString* presentState = popOverButton.titleLabel.text;
        NSArray *allDirectoryDetail = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"state"];
        NSLog(@"allDirectoryDetail==%@",allDirectoryDetail);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.state = %@",presentState];
        NSArray *searchResults = [allDirectoryDetail filteredArrayUsingPredicate:predicate];
        if([self.directoryDataManagerArray count])
        {
            if([searchResults count])
            {
                [self.directoryDataManagerArray removeAllObjects];
                [self.directoryDataManagerArray addObjectsFromArray:searchResults];
                //[self getImageArray];
                [self.directorytableView reloadData];
            }
            else
            {
                [self getDirectoryList];
            }
            
        }
        else{
            [self getDirectoryList];
        }
        
    }
 }

/*******************************************************************************
 *  Function Name: stateSelected.
 *  Purpose: To start searching for selected state.
 *  Parametrs: selected state.
 *  Return Values: nil.
 ********************************************************************************/
-(void)stateSelected:(NSString *)result
{
    
    NSString *userState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
    if([result isEqualToString:@"ALL"]&&![searchText length])
    {
        [syncView removeFromSuperview];
        [popOverButton setTitle:@"ALL" forState:UIControlStateNormal];
        enablePagination = YES;
        
        [self getDirectoryList];
    }
    else if([popOverButton.titleLabel.text isEqualToString:userState]&&![searchText length])
    {
        [popOverButton setTitle:userState forState:UIControlStateNormal];
        NSArray *userStateDetails = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"state"];
        NSLog(@"userStateDetails==%@",userStateDetails);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.state = %@",userState];
        NSArray *searchResults = [userStateDetails filteredArrayUsingPredicate:predicate];
        if([searchResults count])
        {
            if([self.directoryDataManagerArray count])
            {
                [self.directoryDataManagerArray removeAllObjects];
            }
            [self.directoryDataManagerArray addObjectsFromArray:searchResults];
            //[self getImageArray];
            [self.directorytableView reloadData];
            
        }
    }
    else if(![searchText length])
    {
        [popOverButton setTitle:result forState:UIControlStateNormal];
        [self setCustomOverlay];
        NSMutableArray *directoryStatesArray = [[NSMutableArray alloc]init];
        NSLog(@"directoryDataManagerArrayBeforeSearch===%d",[self.directoryDataManagerArray count]);
        
        NSArray *totaldirectorydetailsArray = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"physicianName"];
        [directoryStatesArray addObjectsFromArray:totaldirectorydetailsArray];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.state CONTAINS[cd] %@",result];
        NSArray *searchResults = [directoryStatesArray filteredArrayUsingPredicate:predicate];
        
        // found the result locally
        if ([searchResults count] > 0)
        {
            if([self.directoryDataManagerArray count])
            {
                [self.directoryDataManagerArray removeAllObjects];
            }
            [self.directoryDataManagerArray addObjectsFromArray:searchResults];
            //[self getImageArray];
            [syncView removeFromSuperview];
            NSLog(@"directoryDataManagerArrayAfterSearch===%d",[self.directoryDataManagerArray count]);
        }
        //Search string not found locally then call Search API
        else
        {
            isSearchedResult = YES;
            searchState = result;
            [self searchDirectoryAPI];
        }
    }
    else
    {
        isSearchedResult = YES;
        searchState = result;
        [self searchDirectoryAPI];
    }
    
    [self.directorytableView reloadData];
}

/*******************************************************************************
 *  Function Name: searchBarTextClearButtonTouched.
 *  Purpose: To set delegate for UISearch bar clear button.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)searchBarTextClearButtonTouched
{
    directorySearchBar.delegate = self;
    directorySearchBar.tintColor = [UIColor blackColor];
    for (UIView *view in directorySearchBar.subviews)
    {
        if ([view isKindOfClass: [UITextField class]])
        {
            UITextField *textField = (UITextField *)view;
            textField.delegate = self;
            break;
        }
    }
}
#pragma mark- Button Actions
/*******************************************************************************
 *  DoneButtonTouch Action.
 ********************************************************************************/
- (IBAction)doneButtonTouched:(id)sender
{
    if(self.toAndCcFlag == 0)
    {
        NSLog(@"selectedPhysicianIdArray count === %d",[selectedPhysicianIdArray count]);//this Dictionary should take as 'To' field members.
        NSLog(@"selectedPhysicianIdArray === %@",selectedPhysicianIdArray);
        if (delegate && [delegate respondsToSelector:@selector(selectedContacts:)])
        {
            [delegate selectedContacts:selectedPhysicianIdArray];
        }
    }
    else if (self.toAndCcFlag == 1)
    {
        NSLog(@"selectedPhysicianIdArray count === %d",[selectedPhysicianIdArray count]);//this Dictionary should take as 'To' field members.
        NSLog(@"selectedPhysicianIdArray === %@",selectedPhysicianIdArray);
        if (delegate && [delegate respondsToSelector:@selector(selectedContacts:)])
        {
            [delegate selectedContacts:selectedPhysicianIdArray];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************
 * CustomPopOverButtonTouch Action.
 ********************************************************************************/
-(IBAction)popOverStateNameButtonTouched:(id)sender
{
    popOverView = [[popOverViewController alloc]initWithNibName:@"popOverViewController"
                                                         bundle:nil];
    popOverView.stateCodeArr = stateObjectsArray;
    popOverView.delegate = self;
    [self.view addSubview:popOverView.view];
}

#pragma mark- Download Images
/*******************************************************************************
 *  Function Name: downloadimages.
 *  Purpose: To download directory physician's image.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
-(void)downloadimages
{
	iconImageArray=[[NSMutableArray alloc] initWithCapacity:[imageArray count]];
    NSLog(@"iconImageArrayCOunt==%u",[imageArray count]);
	int i=0;
    for(NSString *imageURLString in imageArray)
    {
        if(imageURLString != ( NSString *) [ NSNull null ])
        {
            NSLog(@"iconImageArrayCOunt==%@",imageURLString);
            NSURL *imageURL=[NSURL URLWithString:imageURLString];
            NSURLConnectionWithTag *imageUrlConnection=[[NSURLConnectionWithTag alloc] initWithRequest:[NSURLRequest requestWithURL:imageURL] delegate:self];
            imageUrlConnection.tag=i++;
            [iconImageArray addObject:[NSNull null]];
            
        }
        else
        {
            [iconImageArray addObject:[NSNull null]];
            
        }
    }
}

#pragma mark - UITable view data source
/*******************************************************************************
 * UITable view data source.
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
    
    int count = [self.directoryDataManagerArray count];
    NSLog(@"Directory Row Count #### %d",count);
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
    
    int count = [self.directoryDataManagerArray count];
    NSLog(@"[self.directoryDataManagerArray count]==%d",[self.directoryDataManagerArray count]);
    NSLog(@"indexpath.row==%d",indexPath.row);
    //Checking if this is the pagination cell
    if (indexPath.row < count)
    {
        CustomDirectoryCell *directoryCell = (CustomDirectoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (directoryCell == nil)
        {
            [[NSBundle mainBundle] loadNibNamed:@"CustomDirectoryCell" owner:self options:nil];
            directoryCell = customDirectoryCell;
            self.customDirectoryCell = nil;
        }
        Directory *directotyObject = [self.directoryDataManagerArray objectAtIndex:indexPath.row];
        NSLog(@"%@",directotyObject);
        /* NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.stateID = %@",directotyObject.state];
         NSArray *recipientEntityObject = [stateObjectsArray filteredArrayUsingPredicate:predicate];
         
         State *stateObj;
         
         if ([recipientEntityObject count]>0)
         {
         stateObj = [recipientEntityObject objectAtIndex:0];
         }*/
        [directoryCell displayDetails:directotyObject];
        
        NSString *imgName = [NSString stringWithFormat:@"%@_%@.jpg",directotyObject.physicianName,directotyObject.physicianId];
        
        BOOL imgExist = [self existImage:imgName];
        NSLog(@"%@",[iconImageArray objectAtIndex:indexPath.row]);
        if(imgExist)
        {
            NSString *path = [self getPathDocAppendedBy:imgName];
            UIImage *img=[UIImage imageWithContentsOfFile:path];
            directoryCell.thumbImageView.image=img;
            
        }
        else if([iconImageArray objectAtIndex:indexPath.row]!=[NSNull null])
        {
            directoryCell.thumbImageView.image=[iconImageArray objectAtIndex:indexPath.row];
        }
        else
        {
            NSLog(@"IMG LOADING ???");
        }
        
        Directory *dirCell = [self.directoryDataManagerArray objectAtIndex:indexPath.row];
        
        if ([selectedPhysicianIdArray containsObject:dirCell.physicianId])
        {
            directoryCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            
        }
        
        directoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = directoryCell;
        
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
        loadMoreCells = nil;
    }
    return cell;
}

#pragma mark - UITable view delegate
/*******************************************************************************
 * UITable view delegate.
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    anyRowSelected=YES;
    presentDirectoryId = indexPath.row;
    if(!identifyFlag)//normal
    {
        Directory *directoryObject = [self.directoryDataManagerArray objectAtIndex:indexPath.row];
        
        if (![directoryObject.physicianImage isEqualToString:@"NoImage"])
        {
            [self directoryDetailsView:self.directoryDataManagerArray directorySelectedNumber:presentDirectoryId];
        }
        //if the physician is message recipent need details
        else
        {
            [self callSingleDirectoryDetailAPI:directoryObject.physicianId];
            
        }
    }
    //directory from the compose mail
    else
    {
        Directory *selectedDirectory = [self.directoryDataManagerArray objectAtIndex:indexPath.row];
        [self updateselectedPhysicianIdArray:selectedDirectory.physicianId];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int count = [self.directoryDataManagerArray count];
    
    if (indexPath.row == count)
    {
        if (isSearchedResult)
        {
            isScrollingPage = YES;
            [self searchDirectoryAPI];
        }
        else
        {
            [self getDirectoryList];
        }
    }
}

/*******************************************************************************
 *  Function Name: searchDirectoryAPI.
 *  Purpose: To call directory API with search token & search State.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)searchDirectoryAPI
{
    int pageNumber;
    
    if (isScrollingPage)
    {
        //update search results
        [syncView removeFromSuperview];
        pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectorySearchPageNumber"] intValue];
    }
    else
    {
        //start search with page number 0
        pageNumber = 0;
    }
    
    if([popOverButton.titleLabel.text isEqualToString:@"ALL"])
    {
        //show all result
        searchState = @"";
    }
    else
    {
        searchState = popOverButton.titleLabel.text;
    }
    if(![searchText length])
    {
        searchText = @"";
    }
    NSString *string = [NSString stringWithFormat:@"&PageNumber=%d&searching=1&SearchToken=%@&State=%@",pageNumber,searchText,searchState];
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.APIType = SearchDirectoryAPI;
        objParser.delegate = self;
    }
    [objParser parseJson:DirectoryAPI :string];
}
#pragma mark-
/*******************************************************************************
 *  Function Name: getDirectoryList.
 *  Purpose: To get directory details from next page.
 *  Parametrs: nil.
 *  Return Values: nil.
 ********************************************************************************/
- (void)getDirectoryList
{
    NSLog(@"self.userStateDirectoryListArray==%@",self.userStateDirectoryListArray);
    int pageNumber;
    NSString *string;
    NSString *userState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
    //login time reload directory with page number 0
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"FirstLoginDirectory"])
    {
        pageNumber = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"DirectoryPageNumber"];
        pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectoryPageNumber"] intValue];
        string = [NSString stringWithFormat:@"&PageNumber=%d&searching=1&SearchToken=&State=%@",pageNumber,userState];
        
        [self callDirectoryAPI:string];
    }
    else
    {
        if([popOverButton.titleLabel.text isEqualToString:@"ALL"])
        {
            pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectoryPageNumber"] intValue];
            
            string = [NSString stringWithFormat:@"&PageNumber=%d&searching=0&SearchToken=&State=",pageNumber];
            [self callDirectoryAPI:string];
        }
        else if(![popOverButton.titleLabel.text isEqualToString:@"ALL"] && [popOverButton.titleLabel.text isEqualToString:userState])
        {
            pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectoryPageNumber"] intValue];
            string = [NSString stringWithFormat:@"&PageNumber=%d&searching=1&SearchToken=&State=%@",pageNumber,userState];
            [self callDirectoryAPI:string];
            
        }
        else
        {
            if([self.directoryDataManagerArray count])
            {
                NSArray *userStateDetails = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"state"];
                NSLog(@"userStateDetails==%@",userStateDetails);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.state = %@",userState];
                NSArray *searchResults = [userStateDetails filteredArrayUsingPredicate:predicate];
                if([searchResults count])
                {
                    [self.directoryDataManagerArray removeAllObjects];
                    [self.directoryDataManagerArray addObjectsFromArray:searchResults];
                    //[self getImageArray];
                    [self.directorytableView reloadData];
                }
                
            }
            else
                if([self.userStateDirectoryListArray count])
                {
                    [self.directoryDataManagerArray addObjectsFromArray:self.userStateDirectoryListArray];
                    //[self getImageArray];
                    [self.directorytableView reloadData];
                    
                }
                else{
                    
                    NSArray *userStateDetails = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"state"];
                    NSLog(@"userStateDetails==%@",userStateDetails);
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.state = %@",userState];
                    NSArray *searchResults = [userStateDetails filteredArrayUsingPredicate:predicate];
                    if([searchResults count])
                    {
                        [self.directoryDataManagerArray addObjectsFromArray:searchResults];
                        //[self getImageArray];
                        [self.directorytableView reloadData];
                        
                    }
                    else{
                        pageNumber = [[[NSUserDefaults standardUserDefaults] valueForKey:@"DirectoryPageNumber"] intValue];
                        string = [NSString stringWithFormat:@"&PageNumber=%d&searching=1&SearchToken=&State=%@",pageNumber,userState];
                        
                        [self callDirectoryAPI:string];
                        
                    }
                }
        }
    }
}
-(void)callDirectoryAPI:(NSString *)string
{
    objParser = nil;
    if (!objParser)
    {
        objParser=[[JsonParser alloc] init];
        objParser.delegate = self;
        objParser.APIType = AllDirectoryAPI;
    }
    [objParser parseJson:DirectoryAPI :string];
    
}
#pragma mark- popOverStateSelected Delegates
/*******************************************************************************
 *  Function Name: popOverStateSelected.
 *  Purpose: It is a delegate method for Selected state.
 *  Parametrs: selected state.
 *  Return Values: nil.
 ********************************************************************************/
-(void)popOverStateSelected:(State *)selectedStateObj
{
    if (selectedStateObj)
    {
        [popOverButton setTitle:selectedStateObj.StateCode forState:UIControlStateNormal];
        NSString *selectedSateID = selectedStateObj.StateCode;
        [self stateSelected:selectedSateID];
    }
    
}
#pragma mark- UISearchBar Delegates
/*******************************************************************************
 * UISearchBar Delegates.
 ********************************************************************************/
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [loadMoreCells stopAnimating];
    isScrollingPage = NO;
    [self setCustomOverlay];
    searchText = searchBar.text;
    NSLog(@"%@",searchText);
    
    NSMutableArray *directoryDetailsArray = [[NSMutableArray alloc]init];
    NSArray *physicianInfoArray = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"physicianName"];;
    [directoryDetailsArray addObjectsFromArray:physicianInfoArray];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *blackSpace = [searchText stringByTrimmingCharactersInSet:whitespace];
    
    if([blackSpace length] == 0)
    {
        [syncView removeFromSuperview];
        [self.directorytableView reloadData];
        searchBar.text = @"";
        searchText = @"";
    }
    else
    {
        isSearchedResult = YES;
        
        NSLog(@"TotaldirectoryCount===%d",[self.directoryDataManagerArray count]);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.physicianName CONTAINS[cd] %@",searchText];
        NSArray *searchResults = [directoryDetailsArray filteredArrayUsingPredicate:predicate];
        //if found in local Db
        if ([searchResults count] > 0)
        {
            enablePagination = NO;
            
            if([self.directoryDataManagerArray count])
            {
                [self.directoryDataManagerArray removeAllObjects];
            }
            [self.directoryDataManagerArray addObjectsFromArray:searchResults];
            NSLog(@"TotaldirectoryCount===%d",[self.directoryDataManagerArray count]);
            
            [syncView removeFromSuperview];
        }
        //Search string not found locally call search API
        else
        {
            enablePagination = YES;
            [self searchDirectoryAPI];
        }
        
        [self.directorytableView reloadData];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //    if(directoryDataManagerArray)
    //    {
    //        directoryDataManagerArray = nil;
    //    }
    //    directoryDataManagerArray = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"physicianName"];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    enablePagination = YES;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    searchText = @"";
    [searchBar setShowsCancelButton:NO animated:NO];
    isSearchedResult = NO;
    NSString *userState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
    [popOverButton setTitle:userState forState:UIControlStateNormal];
    [self stateSelected:currentState];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //Showing Done key on Keyboard
    for (UIView *searchBarSubview in [searchBar subviews])
    {
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)])
        {
            @try {
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

#pragma mark- UITextField Delegate
/*******************************************************************************
 * UITextField Delegate.
 ********************************************************************************/
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    enablePagination = YES;
    self.directorySearchBar.text = @"";
    return YES;
}
#pragma mark - NSURLConnection delegates
/*******************************************************************************
 * NSURLConnection delegates.
 ********************************************************************************/
- (void)connection:(NSURLConnectionWithTag *)connection didReceiveData:(NSData *)data
{
	if(anyRowSelected)
		[connection cancel];
    if(!downloadData)
        downloadData=[[NSMutableData alloc]init];
	
    [downloadData appendData:data];
    NSLog(@"downloadData==%@",downloadData);
}

- (void)connection:(NSURLConnectionWithTag *)connection didFailWithError:(NSError *)error
{
    NSLog(@"fail url %@",error);
    downloadData=nil;
}
- (void)connectionDidFinishLoading:(NSURLConnectionWithTag *)connection
{
    
    NSLog(@"downloadData==%@",downloadData);
    
	UIImage *image =[[UIImage alloc] initWithData:downloadData];//[UIImage imageWithData:downloadData];//[[UIImage alloc] initWithData:downloadData];
	downloadData=nil;
    
    if(image!=nil)
    {
        [iconImageArray replaceObjectAtIndex:connection.tag withObject:image];
    }
    else
    {
        NSLog(@"IMG NULL");
    }
    [self.directorytableView reloadData];
    
}
//rechability is changed
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"****REACHABLE*****");
        reachableFlag = 1;
    }
    else
    {
        NSLog(@"*****UNREACHABLE*******");
        reachableFlag = 0;
    }
}

#pragma mark- Read CSV file
-(void)readStatesFromCSVFile
{
    stateObjectsArray = [[NSMutableArray alloc]init];
    
    NSString *resourceFileName = @"DcdState_Notifyi";
    NSString *pathToFile =[[NSBundle mainBundle] pathForResource: resourceFileName ofType: @"csv"];
    NSLog(@"pathToFile === %@",pathToFile);
    NSError *error;
    
    NSString *fileString = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:&error];
    if (!fileString)
    {
        NSLog(@"Error reading file.");
    }
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    //First Object for displaying ALL
    state = [[State alloc]init];
    state.stateID  = @"0";
    state.StateCode = @"ALL";
    state.StateName = @"ALL";
    
    [stateObjectsArray addObject:state];
    
    state = nil;
    
    
    NSString *lineString;
    
    while ([scanner scanUpToString:@"\n" intoString:&lineString])
    {
        NSArray *listItems = [lineString componentsSeparatedByString:@","];
        NSLog(@"lineString ### %@",lineString);
        
        state = [[State alloc]init];
        state.stateID = [listItems objectAtIndex:0];
        state.StateCode = [listItems objectAtIndex:1];
        state.StateName = [listItems objectAtIndex:2];
        
        [stateObjectsArray addObject:state];
        
        state = nil;
    }
    
    
    NSLog(@"stateObjectsArray count === %d \n %@  ",[stateObjectsArray count],stateObjectsArray);
    
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
    
    if(eparseType == SingleDirectoryDetail)
    {
        if ([result count] > 0)
        {
            [self directoryDetailsView:self.directoryDataManagerArray directorySelectedNumber:presentDirectoryId];
        }
    }
    
    else if (eparseType == DirectoryAPI)
    {
        if ([result count] == 0)
        {
            if (enablePagination) // if it is directory api,disable paging. In search cancel button click enable paging
            {
                enablePagination = NO;
                [loadMoreCells stopAnimating];
                //[self getImageArray];
                [self.directorytableView reloadData];
                
                NSString *userState = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserState"];
                if([popOverButton.titleLabel.text isEqualToString:userState])
                {
                    self.userStateDirectoryListArray = [DataManager getWholeEntityDetails:@"Directory" sortBy:@"physicianName"];
                    NSLog(@" self.userStateDirectoryListArray==%@", self.userStateDirectoryListArray);
                }
                
                objParser = nil;
                objParser.delegate = nil;
            }
            if(isSearchedResult)
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
        }
        else
        {
            NSLog(@"directoryDataManagerArrayCount===%d",[self.directoryDataManagerArray count]);
            if ([result count] > 0)
            {
                if(objParser.APIType == SearchDirectoryAPI)
                {
                    if(isScrollingPage)
                    {
                        [self addNewDetailsToDirectoryDataManagerArray:result];
                    }
                    else
                    {
                        if([self.directoryDataManagerArray count])
                        {
                            [self.directoryDataManagerArray removeAllObjects];
                        }
                        [self.directoryDataManagerArray addObjectsFromArray:result];
                        NSLog(@"directoryDataManagerArray count === %d",[self.directoryDataManagerArray count]);
                    }
                    //[self getImageArray];
                    [self.directorytableView reloadData];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstLoginDirectory"];
                    [self addNewDetailsToDirectoryDataManagerArray:result];
                    //[self getImageArray];
                    [self.directorytableView reloadData];
                    
                }
            }
        }
    }
}

-(void)parseFailedWithError:(ParseServiseType) eparseType:(NSError *)error:(int)errorCode
{
    NSLog(@"Parse Error");
    [syncView removeFromSuperview];
    [GeneralClass showAlertView:self
                            msg:nil
                          title:@"Parse with error. Try again?"
                    cancelTitle:@"YES"
                     otherTitle:@"NO"
                            tag:parseErrorTag];
    errorParseType = eparseType;
}
-(void)parseWithInvalidMessage:(NSArray *)result
{
    [syncView removeFromSuperview];
    if ([result count]>0)
    {
        errorParseType = [[result valueForKey:@"operationType"] integerValue];
        
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

#pragma mark- Alertview delegates
/*******************************************************************************
 *  UIAlertview delegates.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == reachabilityTag)
    {
        NSLog(@"No network");
        [loadMoreCells stopAnimating];
        [syncView removeFromSuperview];
    }
    else if(alertView.tag == parseErrorTag)
    {
        if(errorParseType == DirectoryAPI)
        {
            if(objParser.APIType == AllDirectoryAPI)
            {
                if(buttonIndex == 0)
                {
                    [self getDirectoryList];
                }
                else
                {
                    [syncView removeFromSuperview];
                    enablePagination = NO;
                    [loadMoreCells stopAnimating];
                    objParser.delegate = nil;
                    objParser = nil;
                }
                
            }
            else if(objParser.APIType == SearchDirectoryAPI)
            {
                if(buttonIndex == 0)
                {
                    [self searchDirectoryAPI];
                }
                else
                {
                    [syncView removeFromSuperview];
                    enablePagination = NO;
                    [loadMoreCells stopAnimating];
                    objParser.delegate = nil;
                    objParser = nil;
                }
                
            }
        }
        else if (errorParseType == SingleDirectoryDetail)
        {
            if(buttonIndex == 0)
            {
                [self callSingleDirectoryDetailAPI:[NSNumber numberWithInt:presentDirectoryId]];
            }
            else
            {
                [syncView removeFromSuperview];
                enablePagination = NO;
                [loadMoreCells stopAnimating];
                objParser.delegate = nil;
                objParser = nil;
            }
            
        }
    }
    else if(alertView.tag == noTag)
    {
        // reload table with full data from
        //[self getImageArray];
        [self.directorytableView reloadData];
    }
    alertView = nil;
}

#pragma mark- Unload
- (void)viewDidUnload
{
    [super viewDidUnload];
}
-(void)viewWillDisappear:(BOOL)animated
{
    int pageNumber;
    pageNumber = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:@"DirectoryPageNumber"];
    currentState = popOverButton.titleLabel.text;
    [popOverButton setTitle:currentState forState:UIControlStateNormal];
    NSLog(@" self.userStateDirectoryListArray==%@", self.userStateDirectoryListArray);
}
-(void) dealloc
{
    [self setDirectory:nil];
    [self setDirectorySearchBar:nil];
    [self setDirectorytableView:nil];
    
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
