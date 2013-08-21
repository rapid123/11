//
//  Red_BeaconAppDelegate.m
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Red_BeaconAppDelegate.h"
#import "JobRequest.h"
#import "SBJson.h"
#import "RBAlertMessageHandler.h"
#import "ManagedObjectContextHandler.h"
#import "HomeViewController.h"
#import "JobViewController.h"
#import "NotificationsViewController.h"
#import "ScheduleAppointmentViewController.h"
#import "QuotesViewController.h"
#import "JobDetailViewController.h"
#import "FlurryAnalytics.h"

#import "RBCurrentJobResponse.h"
#import "UINavigationItem + RedBeacon.h"


#import <CommonCrypto/CommonDigest.h>

@class HomeViewController;

@interface Red_BeaconAppDelegate (Private)
- (void)newLocationSaved;
- (void)successfulLocationUpdate;
- (void)failedLocationUpdate;
- (void)initializeAnalytics;
- (void)initializeView;
- (void)createTabbar;
-(void)selectSplashScreenToDisplay;
@end

@implementation Red_BeaconAppDelegate

@synthesize window=_window;
@synthesize delegate;
@synthesize logindelegate;
@synthesize navigationController=_navigationController;
@synthesize splashScreen;
@synthesize initialTabViewControllers;

NSString * const kUrlScheme = @"redbeaconconsumer"; // See Info.plist
NSString * const kDefaultImageKey = @"defaultImage";
NSString * const kHomeTabImageName = @"home_tab.png";
NSString * const kRequestTabImageName = @"request_tab.png";
NSString * const kNotificationTabImageName = @"notification_tab.png";

#ifdef PROD_CONFIG
NSString * const kFlurryAnalyticsToken = @"ZMSKL53TXQNAEW11KG3J"; // Prod
#else
NSString * const kFlurryAnalyticsToken = @"Z68YUT6KAUVFIY6CFIPZ"; // Dev
#endif

int kDefaultSplashScreenCount=3; 



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initializeAnalytics];
    [self initializeView];
    
    [self.window makeKeyAndVisible];
    splashNumber = 1;

    [self performSelectorInBackground:@selector(trackGreystripeDownload) withObject:nil];
    [self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
    
    return YES;
}

#pragma mark - 
#pragma mark Analytics and Tracking

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

-(void)initializeAnalytics {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics setDebugLogEnabled:YES];
    [FlurryAnalytics startSession:kFlurryAnalyticsToken];
}

- (void)trackGreystripeDownload {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * documentsPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];
    NSString * filePath = [documentsPath stringByAppendingPathComponent:@"gsDownloadTracked"];
    
    if(![fm fileExistsAtPath:filePath]){
        NSString * deviceUID = [[UIDevice currentDevice] uniqueIdentifier];
        NSString * requestURLString = [NSString stringWithFormat:@"http://ads2.greystripe.com/AdBridgeServer/track.htm?did=%@&appid=100003721&action=dl", deviceUID];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
        NSHTTPURLResponse * response = nil; NSError * errors = nil; NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errors];
        if(result != nil && errors == nil && [response statusCode] == 200) {
            [fm createFileAtPath:filePath contents:nil attributes:nil];
        }
    }
    
    // clean up
    [pool release];
}

// This method requires adding #import <CommonCrypto/CommonDigest.h> to your source file.
- (NSString *)hashedISU {
    NSString *result = nil;
    NSString *isu = [UIDevice currentDevice].uniqueIdentifier;
    
    if(isu) {
        unsigned char digest[16];
        NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
        CC_MD5([data bytes], [data length], digest);
        
        result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                  digest[0], digest[1],
                  digest[2], digest[3],
                  digest[4], digest[5],
                  digest[6], digest[7],
                  digest[8], digest[9],
                  digest[10], digest[11],
                  digest[12], digest[13],
                  digest[14], digest[15]];
        result = [result uppercaseString];
    }
    return result;
}

- (void)reportAppOpenToAdMob {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // we're in a new thread here, so we need our own autorelease pool
    // Have we already reported an app open?
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appOpenPath = [documentsDirectory stringByAppendingPathComponent:@"admob_app_open"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:appOpenPath]) {
        // Not yet reported -- report now
        NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&app_id=%@",
                                     [self hashedISU], @"467014822"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
        NSURLResponse *response;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200) && ([responseData length] > 0)) {
            [fileManager createFileAtPath:appOpenPath contents:nil attributes:nil]; // successful report, mark it as such
        }
    }
    [pool release];
}

#pragma mark - 
#pragma mark initialize view

-(void)selectSplashScreenToDisplay {
   
    NSString *imageName =[NSString stringWithFormat:@"%d.png",splashNumber];
    [splashScreen setImage:[UIImage imageNamed:imageName]];
    if(splashNumber==kDefaultSplashScreenCount)  
        splashNumber=1;
    else
        splashNumber++;     
}




-(void)initializeView {
    
    [self.window addSubview:splashScreen];
    [self createTabbar];

}

-(void)removeSplash {
    
    [splashScreen setImage:nil];
    [splashScreen removeFromSuperview];
}

#pragma mark -
#pragma mark tabbar 

-(int)indexOfQuotestab {
    
    int count = [[tabbar viewControllers] count];
    int quoteIndex = count - 2;
    return quoteIndex;
}

-(void)selectTabbarIndex:(int)index {
    
    tabbar.selectedIndex = index;
}

// used to jump to the particular quote in the list from the conversatin tab
-(void)selectTabbarIndex:(int)index withTableIndex:(int)tableIndex {
    
    RBNavigationController *navController = [[tabbar viewControllers] objectAtIndex:index];
    [navController popToRootViewControllerAnimated:NO];
    UIViewController *viewController = [navController topViewController];
    if([viewController respondsToSelector:@selector(selectTableIndex:)]) {
        [(QuotesViewController *)viewController selectTableIndex:tableIndex];
    }
    tabbar.selectedIndex = index;
}

-(void)setTabbarViewControllers:(NSArray *)viewControllers {
    
    if(viewControllers==nil)
        [tabbar setViewControllers:initialTabViewControllers];
    else
        [tabbar setViewControllers:viewControllers];
}

-(void)changeTabbarViewControllersWithAppointment:(BOOL )isFromAppointmentsection {
    
    
    JobDetailViewController *jobDetailViewController = [[JobDetailViewController alloc] init];
    if(isFromAppointmentsection) 
        [jobDetailViewController setIsAppointmentPresent:YES];
    [[jobDetailViewController tabBarItem] setImage:[UIImage imageNamed:@"detail_tab.png"]];
    [[jobDetailViewController tabBarItem] setTitle:@"Details"];
    RBNavigationController *jobNavigationController = [[RBNavigationController alloc] initWithRootViewController:jobDetailViewController];
    [jobDetailViewController release];
    jobDetailViewController=nil;
    
    QuotesViewController *quotesViewController = [[QuotesViewController alloc] init];
    [[quotesViewController tabBarItem] setImage:[UIImage imageNamed:@"quotes_tab.png"]];
    [[quotesViewController tabBarItem] setTitle:@"Quotes"];
    RBNavigationController *quotesNavigationController = [[RBNavigationController alloc] initWithRootViewController:quotesViewController];
    [quotesViewController release];
    quotesViewController=nil;
    
    NotificationsViewController *conversationViewController = [[NotificationsViewController alloc] init];
    [conversationViewController setIsConversation:YES];
    [[conversationViewController tabBarItem] setImage:[UIImage imageNamed:@"conversation_tab.png"]];
    [[conversationViewController tabBarItem] setTitle:@"Conversations"];
    RBNavigationController *conversationNavigationController = [[RBNavigationController alloc] initWithRootViewController:conversationViewController];
    [conversationViewController release];
    conversationViewController=nil;
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:    
                                                                             jobNavigationController,
                                                                             quotesNavigationController,
                                                                             conversationNavigationController,                                                                     
                                                                             nil]]; 
    
    if(isFromAppointmentsection) {
        ScheduleAppointmentViewController *scheduleAppointmentViewController = [[ScheduleAppointmentViewController alloc] init];
        [[scheduleAppointmentViewController tabBarItem] setImage:[UIImage imageNamed:@"appointment_tab.png"]];
        [[scheduleAppointmentViewController tabBarItem] setTitle:@"Appointments"];
        RBNavigationController *scheduleAppointmentNavigationController = [[RBNavigationController alloc] initWithRootViewController:scheduleAppointmentViewController];
        [scheduleAppointmentViewController release];
        scheduleAppointmentViewController=nil;
        
        [viewControllers insertObject:scheduleAppointmentNavigationController atIndex:0];
        [scheduleAppointmentNavigationController release];
        scheduleAppointmentNavigationController = nil;
    }
    
    
    [self setTabbarViewControllers:(NSArray *)viewControllers];
    
    [jobNavigationController release];
    jobNavigationController=nil;
    
    [quotesNavigationController release];
    quotesNavigationController=nil;
    
    [conversationNavigationController release];
    conversationNavigationController=nil;
    
    [viewControllers release];
    viewControllers = nil;
    
}


-(void)createTabbar {
    
    
    tabbar =[[UITabBarController alloc] init];
    tabbar.delegate=self;
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    RBNavigationController *homeNavigationController = [[RBNavigationController alloc] initWithRootViewController:homeViewController];
      
    homeNavigationController.title=@"Home";
    [[homeNavigationController tabBarItem] setImage:[UIImage imageNamed:kHomeTabImageName]];
    [homeViewController release];
    homeViewController=nil;
    
    JobViewController *jobViewController = [[JobViewController alloc] init];
    RBNavigationController *requestNavigationController = [[RBNavigationController alloc] initWithRootViewController:jobViewController];
    requestNavigationController.title=@"Request";
    [[requestNavigationController tabBarItem] setImage:[UIImage imageNamed:kRequestTabImageName]];
    [jobViewController release];
    jobViewController=nil;
    
    initialTabViewControllers=[[NSArray alloc] initWithArray:[NSArray arrayWithObjects:homeNavigationController,
                                                              requestNavigationController,
                                                              nil]];
    
    [tabbar setViewControllers:initialTabViewControllers];

    
    [homeNavigationController release];
    [requestNavigationController release];
    homeNavigationController=nil;
    requestNavigationController=nil;
    
    [self removeSplash];
    [self.window addSubview:tabbar.view];
    JobRequest *jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    if(jobRequest)
        [self selectTabbarIndex:1];
        
}

#pragma mark -


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
    [self selectSplashScreenToDisplay];
    [self.window addSubview:splashScreen];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRedBeaconDidEnterBackground object:nil];
    
    [[RBSavedStateController sharedInstance] persistToDisk];

    if ([RBBaseHttpHandler isSessionInfoAvailable])
    {
        [RBBaseHttpHandler saveSession];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRedBeaconDidEnterForground object:nil];
    
    [self performSelector:@selector(removeSplash)  withObject:nil afterDelay:2];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[RBSavedStateController sharedInstance] persistToDisk];
}

- (void)dealloc
{
    self.delegate = nil;
    self.logindelegate = nil;
    [_window release];
    [_navigationController release];
    [super dealloc];
}

#pragma mark - GPS Location Scanning
- (void)startGPSScan 
{
    [self stopGPSScan];
    [[LocationManager sharedManager] startGPSScan];
    [[LocationManager sharedManager] setDelegate:self];
}

- (void)stopGPSScan 
{
    [[LocationManager sharedManager] stopGPSScan];
    [[LocationManager sharedManager] setDelegate:nil];
}

- (void)locationUpdate:(CLLocation *)location 
{
    [self stopGPSScan];
    [self fetchZipcodeForLocation:location];
    self.delegate = nil;
}

- (void)locationError:(NSError *)error 
{
    [self stopGPSScan];
    [RBAlertMessageHandler showAlert:@"Your location cannot be identified"
                      delegateObject:nil];
    
    //save to datastore
    JobRequest * jobRequest  = [[RBSavedStateController sharedInstance] jobRequest];
    [jobRequest.location setValue:nil forKey:KEY_LOCATION_ZIP];
    [jobRequest.location setValue:LOCATION_TYPE_GPS forKey:KEY_LOCATION_TYPE];
    
    [self failedLocationUpdate];
    self.delegate = nil;
}

- (void)fetchZipcodeForLocation:(CLLocation*)newLocation 
{
    
    NSError * error = nil;
    NSString * urlString = kGoogleAPIToFetchZipCode;
    urlString = [urlString stringByAppendingFormat:@"latlng=%0.7f,%0.7f&sensor=true", 
                 newLocation.coordinate.latitude,
                 newLocation.coordinate.longitude];
    

    //test URL for dummy values- as we cant test GPS in here;
   // urlString = @"http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true";
    
    //give latitude and longitude and get the zipcode, from Google: reverse geocoding
    NSString *responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]  
                                                        encoding:NSUTF8StringEncoding 
                                                           error:&error];
    NSMutableDictionary * responseDictionary = [responseString JSONValue];    

    //parse the response
    NSString * zipCode = [self getZipCodeFromResponse:responseDictionary];    

    //valid zipcode only in US.
    if ([zipCode length]==5) {
        
        //tells that succesffully completed the zipcode fetch
        [self successfulLocationUpdate];
        
        //check the zipcode
//        if ([self isValidZipCode:zipCode]) 
//        {
            //save to datastore
            NSString * cityName = [[ManagedObjectContextHandler sharedInstance] getCityNameForZipcode:zipCode];
            if ([cityName isEqualToString:@""])
                cityName = EMPTY_CITY_NAME;
            JobRequest * jobRequest  = [[RBSavedStateController sharedInstance] jobRequest];
            [jobRequest.location setValue:zipCode forKey:KEY_LOCATION_ZIP];
            [jobRequest.location setValue:LOCATION_TYPE_GPS forKey:KEY_LOCATION_TYPE];
            [jobRequest.location setValue:cityName forKey:KEY_LOCATION_CITYNAME];
            [self newLocationSaved];
   //     }
    }   
    else {
        
        //zipcode fetching resulted in errors
        [self failedLocationUpdate];
        
        [RBAlertMessageHandler showAlert:@"Your location cannot be identified"
                          delegateObject:nil];
    }
}

- (NSString*)getZipCodeFromResponse:(NSMutableDictionary*)response 
{
    NSString * zipCode = nil;
    NSMutableArray * results = [response valueForKey:@"results"];
    
    for (NSDictionary * result in results) {        
        NSArray * types = [result valueForKey:@"types"];
        
        for (NSString * type in types) {
            if ([type isEqualToString:@"postal_code"]) {
                NSArray * addressComponents = [result valueForKey:@"address_components"];
                
                for (NSDictionary * component in addressComponents) {
                    NSArray * types = [component valueForKey:@"types"];
                    for (NSString * type in types) {
                        if ([type isEqualToString:@"postal_code"]) {
                            zipCode = [component valueForKey:@"long_name"];
                        }
                        else if ([type isEqualToString:@"locality"]){
                            
                        }
                    } 
                }
            }
        }
        
    }
    return zipCode;
}
- (BOOL)isValidZipCode:(NSString*)zipcode 
{
    BOOL isValid;
    isValid = [[ManagedObjectContextHandler sharedInstance] isZipcodeExists:zipcode];
    if (!isValid) {
        [RBAlertMessageHandler showAlertWithTitle:AS_INVALID_ZIPCODE_ALERT_TITLE 
                                          message:AS_INVALID_ZIPCODE_ALERT_MESSAGE 
                                   delegateObject:nil 
                                          viewTag:1 
                                 otherButtonTitle:@"OK" 
                                       showCancel:NO];
        
    }
    return isValid;
}

- (void)newLocationSaved {
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(newLocationDidSaved)])
        [self.delegate newLocationDidSaved];
}

- (void)failedLocationUpdate
{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(locationFetchCompletedWithErrors)])
        [self.delegate locationFetchCompletedWithErrors];
}

- (void)successfulLocationUpdate
{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(locationFetchCompletedSuccessfully)])
        [self.delegate locationFetchCompletedSuccessfully];
}

#pragma mark- URL and Facebook Delegates

- (BOOL)handleRedbeaconURL:(NSURL *)url {
    // Go to the Home tab.
    tabbar.selectedIndex = 0;
    return YES;
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self application:application handleOpenURL:url];
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{   
    // Custom Redbeacon URLs.
    if ([kUrlScheme isEqualToString:url.scheme]) {
        return [self handleRedbeaconURL:url];
    }
    
    // Facebook URLs.
    return [logindelegate handleOpenURL:url];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"tab selected==%d",tabBarController.selectedIndex);
//    if(tabBarController.selectedIndex==1){
//        UINavigationController *nv = [[tabBarController viewControllers] objectAtIndex:1];
//        UIViewController *vc = [nv topViewController];
//        //[vc setHidesBottomBarWhenPushed:YES];
//    }
}



@end
