//
//  MobileSettingsViewController.m
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 14/09/12.
//
//

#import "MobileSettingsViewController.h"
#import "AppDelegate.h"
#import "GeneralClass.h"

@interface MobileSettingsViewController ()
{
    UIView *syncView;
    NSMutableDictionary *settingsData;
}

@property(strong,nonatomic)IBOutlet UISwitch *pushNotificationSwitchBtn;
@property(strong,nonatomic)IBOutlet UISwitch *inboxMessageVibrateSwitchBtn;
@property(strong,nonatomic)IBOutlet UISwitch *inboxMessageSoundSwitchBtn;
@property(strong,nonatomic)IBOutlet UISwitch *touchBaseMessageVibrateSwitchBtn;
@property(strong,nonatomic)IBOutlet UISwitch *touchBaseMessageSoundSwitchBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *mobileSettingsLbl;
@property (weak, nonatomic) IBOutlet UILabel *pushNotificationSettingsLbl;
@property (weak, nonatomic) IBOutlet UILabel *turnOnPushNotificationLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileAlertMessageLbl;
@property (weak, nonatomic) IBOutlet UILabel *mobileAlertTouchBaseLbl;
@property (weak, nonatomic) IBOutlet UILabel *touchBaseMessageVibrateOnLbl;
@property (weak, nonatomic) IBOutlet UILabel *touchBaseMessageSoundOnLbl;
@property (weak, nonatomic) IBOutlet UILabel *inboxMessageVibrateOnLbl;
@property (weak, nonatomic) IBOutlet UILabel *inboxMessageSoundOnLbl;

- (void)setCustomOverlay;
- (void)turnOnPushNotification;
-(void)switchButtonCustomization;
-(void)fontCustomization;
-(void)checkInboxMessageVibrateSwitchPositions;
-(void)checkTouchBaseMessageVibrateSwitchPositions;
-(void)checkInboxMessageSoundSwitchPositions;
-(void)checkTouchBaseMessageSoundSwitchPositions;
//-(void)localNotificationForInboxMessageVibrate;
-(void)localNotificationForTouchBaseMessageVibrate;
-(void)removeNotificationForTouchBaseMessageVibrate;
-(void)removeNotificationForInboxMesssageVibrate;
-(void)localNotificationForInboxMessageSound;
-(void)removeNotificationForInboxMessageSound;
-(void)localNotificationForTouchBaseMessageSound;
-(void)removeNotificationForTouchBaseMessageSound;
-(void)eventHandlerForInboxMessageVibrate: (NSNotification *) notification;
-(void)eventHandlerForTouchBaseMessageVibrate: (NSNotification *) notification;
-(void)eventHandlerForTouchBaseMessageSound:(NSNotification *) notification;
-(void)eventHandlerForInboxMessageSound: (NSNotification *) notification;
-(void)messageSoundUrl;
-(void)checkpushNotificationSwitchPositions;
-(void)userSettings:(NSDictionary *)settings;
-(void)checkSettingsWriteToPlistDict;
-(void)writeSettingsToPlistFile:(NSMutableDictionary*)dictToPlist;
-(void)getSettingsFromPlistFile;
-(NSString *)getPlistFilePath;

-(IBAction)inboxMessageVibrateSwitchToggle:(id)sender;
-(IBAction)backButtonTouched:(id)sender;
-(IBAction)touchBaseMessageVibrateSwitchToggle:(id)sender;
-(IBAction)inboxMessageSoundSwitchToggle:(id)sender;
-(IBAction)touchBaseMessageSoundSwitchToggle:(id)sender;
-(IBAction)logoutButtonTouched:(id)sender;

@end

NSUserDefaults *standardUserDefaults;
SystemSoundID soundID;
@implementation MobileSettingsViewController
@synthesize backBtn;
@synthesize mobileSettingsLbl;
@synthesize pushNotificationSettingsLbl;
@synthesize turnOnPushNotificationLbl;
@synthesize mobileAlertMessageLbl;
@synthesize mobileAlertTouchBaseLbl;
@synthesize touchBaseMessageVibrateOnLbl;
@synthesize touchBaseMessageSoundOnLbl;
@synthesize inboxMessageVibrateOnLbl;
@synthesize inboxMessageSoundOnLbl;
@synthesize inboxMessageSoundSwitchBtn;
@synthesize pushNotificationSwitchBtn;
@synthesize inboxMessageVibrateSwitchBtn;
@synthesize touchBaseMessageSoundSwitchBtn;
@synthesize touchBaseMessageVibrateSwitchBtn;

#pragma mark- Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark- Initial Load
- (void)viewDidLoad
{
    [super viewDidLoad];
    //set
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [self switchButtonCustomization];
    [self fontCustomization];
    [self checkSwitchPositions];
//    [self localNotificationForInboxMessageVibrate];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark- Methods
/*******************************************************************************
 *  Function Name:switchButtonCustomization.
 *  Purpose: To Customize switch Button.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)switchButtonCustomization
{
    self.pushNotificationSwitchBtn.transform =CGAffineTransformMakeScale(0.6,0.6);
    self.inboxMessageSoundSwitchBtn.transform =CGAffineTransformMakeScale(0.6,0.6);
    self.inboxMessageVibrateSwitchBtn.transform =CGAffineTransformMakeScale(0.6,0.6);
    self.touchBaseMessageSoundSwitchBtn.transform =CGAffineTransformMakeScale(0.6,0.6);
    self.touchBaseMessageVibrateSwitchBtn.transform =CGAffineTransformMakeScale(0.6,0.6);
    
}
/*******************************************************************************
 *  Function Name:fontCustomization.
 *  Purpose: Setting font for controlles.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)fontCustomization
{
    pushNotificationSettingsLbl.font = [GeneralClass getFont: buttonFont and:boldFont];
    pushNotificationSettingsLbl.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    mobileSettingsLbl.font = [GeneralClass getFont: titleFont and:boldFont];
    turnOnPushNotificationLbl.font = [GeneralClass getFont: customNormal and:boldFont];
    mobileAlertMessageLbl.font = [GeneralClass getFont: buttonFont and:boldFont];
    mobileAlertMessageLbl.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    mobileAlertTouchBaseLbl.font = [GeneralClass getFont: buttonFont and:boldFont];
    mobileAlertTouchBaseLbl.textColor = [UIColor colorWithRed:GreenBackGround_RedColor green:GreenBackGround_GreenColor blue:GreenBackGround_BlueColor alpha:1];
    touchBaseMessageSoundOnLbl.font = [GeneralClass getFont: customNormal and:boldFont];
    touchBaseMessageVibrateOnLbl.font = [GeneralClass getFont: customNormal and:boldFont];
    inboxMessageVibrateOnLbl.font = [GeneralClass getFont: customNormal and:boldFont];
    inboxMessageSoundOnLbl.font = [GeneralClass getFont: customNormal and:boldFont];
    backBtn.titleLabel.font = [GeneralClass getFont: buttonFont and:regularFont];
}
/*******************************************************************************
 *  Function Name:checkSwitchPositions.
 *  Purpose: To Check the vibrate and sound switch positions.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)checkSwitchPositions
{
    [self getSettingsFromPlistFile];
}
/*******************************************************************************
 *  Function Name:localNotificationForInboxMessageVibrate.
 *  Purpose: To register a notification if InboxMessageVibrater Switch is ON.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)localNotificationForInboxMessageVibrate
{
    NSLog(@"inboxMessageVibrateSwitchBtn notification registered");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventHandlerForInboxMessageVibrate:)
                                                 name:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX VIBRATOR", nil)
                                               object:nil ];
    [standardUserDefaults setObject:@"1"
                             forKey:NSLocalizedString(@"INBOX MESSAGE VIBRATE SWITCH", nil)];
    [standardUserDefaults synchronize];
    
}
/*******************************************************************************
 *  Function Name:localNotificationForTouchBaseMessageVibrate.
 *  Purpose: To register a notification if TouchbaseMessageVibrater Switch is ON.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)localNotificationForTouchBaseMessageVibrate
{
    NSLog(@"touchbaseMessageVibrateSwitchBtn notification registered");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventHandlerForTouchBaseMessageVibrate:)
                                                 name:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE VIBRATOR", nil)
                                               object:nil ];
    [standardUserDefaults setObject:@"1"
                             forKey:NSLocalizedString(@"TOUCHBASE MESSAGE VIBRATE SWITCH", nil)];
    [standardUserDefaults synchronize];
    
}
/*******************************************************************************
 *  Function Name:removeNotificationForTouchBaseMessageVibrate.
 *  Purpose: To remove notification if TouchbaseMessageVibrater Switch is OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)removeNotificationForTouchBaseMessageVibrate
{
    NSLog(@"touchbaseMessageVibrateSwitchBtn notification removed");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE VIBRATOR",nil)
                                                  object:nil];
    [standardUserDefaults setObject:@"0"
                             forKey:NSLocalizedString(@"TOUCHBASE MESSAGE VIBRATE SWITCH", nil)];
    [standardUserDefaults synchronize];
    
}
/*******************************************************************************
 *  Function Name:removeNotificationForInboxMesssageVibrate.
 *  Purpose: To remove notification if InboxMesssageVibrater Switch is OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)removeNotificationForInboxMesssageVibrate
{
    NSLog(@"inboxMessageVibrateSwitchBtn notification removed");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX VIBRATOR", nil)
                                                  object:nil];
    [standardUserDefaults setObject:@"0"
                             forKey:NSLocalizedString(@"INBOX MESSAGE VIBRATE SWITCH", nil)];
    [standardUserDefaults synchronize];
}
/*******************************************************************************
 *  Function Name:localNotificationForInboxMessageSound.
 *  Purpose: To register a notification if InboxMessageSound Switch is ON.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)localNotificationForInboxMessageSound
{
    NSLog(@"inboxMessageSoundSwitchBtn notification registered");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventHandlerForInboxMessageSound:)
                                                 name:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX SOUND", nil)
                                               object:nil ];
    [standardUserDefaults setObject:@"1"
                             forKey:NSLocalizedString(@"INBOX MESSAGE SOUND SWITCH", nil)];
    [standardUserDefaults synchronize];
}
/*******************************************************************************
 *  Function Name:removeNotificationForInboxMessageSound.
 *  Purpose: To remove notification if InboxMesssageSound Switch is OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)removeNotificationForInboxMessageSound
{
    NSLog(@"inboxMessageSoundSwitchBtn notification removed");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSLocalizedString(@"NOTIFICATION OBJECT FOR INBOX SOUND", nil)
                                                  object:nil];
    [standardUserDefaults setObject:@"0"
                             forKey:NSLocalizedString(@"INBOX MESSAGE SOUND SWITCH", nil)];
    [standardUserDefaults synchronize];
}
/*******************************************************************************
 *  Function Name:localNotificationForTouchBaseMessageSound.
 *  Purpose: To register a notification if TouchbaseMessageSound Switch is ON.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)localNotificationForTouchBaseMessageSound
{
    NSLog(@"touchbaseMessageSoundSwitchBtn notification registered");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventHandlerForTouchBaseMessageSound:)
                                                 name:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE SOUND", nil)
                                               object:nil];
    [standardUserDefaults setObject:@"1"
                             forKey:NSLocalizedString(@"TOUCHBASE MESSAGE SOUND SWITCH", nil)];
    [standardUserDefaults synchronize];
    
}
/*******************************************************************************
 *  Function Name:removeNotificationForTouchBaseMessageSound.
 *  Purpose: To remove notification if TouchBaseMessageSound Switch is OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)removeNotificationForTouchBaseMessageSound
{
    NSLog(@"touchBaseMessageSoundSwitchBtn notification removed");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSLocalizedString(@"NOTIFICATION OBJECT FOR TOUCHBASE SOUND", nil)
                                                  object:nil];
    [standardUserDefaults setObject:@"0"
                             forKey:NSLocalizedString(@"TOUCHBASE MESSAGE SOUND SWITCH", nil)];
    [standardUserDefaults synchronize];
}
/*******************************************************************************
 *  Function Name:checkInboxMessageVibrateSwitchPositions.
 *  Purpose: To Check whether InboxMessageVibrate Switch is ON or OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)checkInboxMessageVibrateSwitchPositions
{
    NSLog(@"[standardUserDefaults stringForKey:InboxMessageVibrateSwitch is] === %@",[standardUserDefaults stringForKey:NSLocalizedString(@"INBOX MESSAGE VIBRATE SWITCH", nil)]);
    
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"INBOX MESSAGE VIBRATE SWITCH", nil)] isEqualToString:@"1"])
	{
        inboxMessageVibrateSwitchBtn.on = YES;
        [self localNotificationForInboxMessageVibrate];
    }
    else
    {
        inboxMessageVibrateSwitchBtn.on = NO;
        [self removeNotificationForInboxMesssageVibrate];
    }
    
}
/*******************************************************************************
 *  Function Name:checkTouchBaseMessageVibrateSwitchPositions.
 *  Purpose: To Check whether TouchBaseMessageVibrate Switch is ON or OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)checkTouchBaseMessageVibrateSwitchPositions
{
    NSLog(@"[standardUserDefaults stringForKey:TouchBaseVibrateSwitch is] === %@",[standardUserDefaults stringForKey:NSLocalizedString(@"TOUCHBASE MESSAGE VIBRATE SWITCH", nil)]);
    
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"TOUCHBASE MESSAGE VIBRATE SWITCH", nil)] isEqualToString:@"1"])
	{
        touchBaseMessageVibrateSwitchBtn.on = YES;
        [self localNotificationForTouchBaseMessageVibrate];
    }
    else
    {
        touchBaseMessageVibrateSwitchBtn.on = NO;
        [self removeNotificationForTouchBaseMessageVibrate];
    }
    
}
/*******************************************************************************
 *  Function Name:checkInboxMessageSoundSwitchPositions.
 *  Purpose: To Check whether InboxMessageSound Switch is ON or OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)checkInboxMessageSoundSwitchPositions
{
    NSLog(@"[standardUserDefaults stringForKey:InboxMessageSoundSwitch is] === %@",[standardUserDefaults stringForKey:NSLocalizedString(@"INBOX MESSAGE SOUND SWITCH", nil)]);
    
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"INBOX MESSAGE SOUND SWITCH", nil)] isEqualToString:@"1"])
	{
        inboxMessageSoundSwitchBtn.on = YES;
        [self localNotificationForInboxMessageSound];
    }
    else
    {
        inboxMessageSoundSwitchBtn.on = NO;
        [self removeNotificationForInboxMessageSound];
    }
}
/*******************************************************************************
 *  Function Name:checkTouchBaseMessageSoundSwitchPositions.
 *  Purpose: To Check whether TouchBaseMessageSound Switch is ON or OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)checkTouchBaseMessageSoundSwitchPositions
{
    NSLog(@"[standardUserDefaults stringForKey:TouchBaseMessageSoundSwitch is] === %@",[standardUserDefaults stringForKey:NSLocalizedString(@"TOUCHBASE MESSAGE SOUND SWITCH", nil)]);
    
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"TOUCHBASE MESSAGE SOUND SWITCH", nil)] isEqualToString:@"1"])
	{
        touchBaseMessageSoundSwitchBtn.on = YES;
        [self localNotificationForTouchBaseMessageSound];
    }
    else
    {
        touchBaseMessageSoundSwitchBtn.on = NO;
        [self removeNotificationForTouchBaseMessageSound];
        
    }
}

/*******************************************************************************
 *  Function Name: checkpushNotificationSwitchPositions.
 *  Purpose: To Check whether Push Notification Switch is ON or OFF.
 *  Parametrs:nil
 *  Return Values:nil
 ********************************************************************************/
-(void)checkpushNotificationSwitchPositions
{
    NSLog(@"[standardUserDefaults stringForKey:PushNotification switch is] === %@",[standardUserDefaults stringForKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)]);
    
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)] isEqualToString:@"1"])
	{
        pushNotificationSwitchBtn.on = YES;
    }
    else
    {
        pushNotificationSwitchBtn.on = NO;
        
    }
    
}

/*******************************************************************************
 *  Function Name:eventHandlerForInboxMessageVibrate.
 *  Purpose: Vibrate event handler for InboxMessageVibrate.
 *  Parametrs: Notification Object.
 *  Return Values:nil
 ********************************************************************************/
-(void)eventHandlerForInboxMessageVibrate: (NSNotification *) notification
{
    NSLog(@"event triggered for Msg Vibrate");
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

/*******************************************************************************
 *  Function Name:eventHandlerForTouchBaseMessageVibrate.
 *  Purpose: Vibrate event handler for TouchBaseMessageVibrate.
 *  Parametrs: Notification Object.
 *  Return Values:nil
 ********************************************************************************/
-(void)eventHandlerForTouchBaseMessageVibrate: (NSNotification *) notification
{
    NSLog(@"event triggered for Touch Base vibrate");
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

/*******************************************************************************
 *  Function Name:eventHandlerForInboxMessageSound.
 *  Purpose: Sound event handler for InboxMessageSound.
 *  Parametrs: Notification Object.
 *  Return Values:nil
 ********************************************************************************/
-(void)eventHandlerForInboxMessageSound:(NSNotification *) notification
{
    NSLog(@"event triggered for Messege Sound");
    [self messageSoundUrl];
}

/*******************************************************************************
 *  Function Name:eventHandlerForTouchBaseMessageSound.
 *  Purpose: Sound event handler for TouchBaseMessageSound.
 *  Parametrs: Notification Object.
 *  Return Values:nil
 ********************************************************************************/
-(void)eventHandlerForTouchBaseMessageSound:(NSNotification *) notification
{
    NSLog(@"event triggered for Touch Base Messege Sound");
    [self messageSoundUrl];
}

/*******************************************************************************
 *  Function Name:messageSoundUrl.
 *  Purpose: To Create a soundurl.
 *  Parametrs: nil.
 *  Return Values:nil
 ********************************************************************************/
-(void)messageSoundUrl
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"OLI"
                                              withExtension:@"MP3"];
    AudioServicesCreateSystemSoundID  ((__bridge_retained CFURLRef)soundURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
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
 *  Function Name: userSettings.
 *  Purpose: To get Settings from plist and save to current user.
 *  Parametrs: settings as dictionary from plist.
 *  Return Values:nil
 ********************************************************************************/
-(void) userSettings:(NSDictionary *)settings
{
     NSLog(@"Settingsdata==%@",settings);
    [standardUserDefaults setObject:[settings objectForKey:@"pushNotiSwitch"] 

                             forKey:@"PushNotificationSwitchpositions"];

    [standardUserDefaults setObject:[settings objectForKey:@"inboxVibrateSwitch"] 
                             forKey:@"InboxMessageVibrateSwitch"];

    [standardUserDefaults setObject:[settings objectForKey:@"inboxSoundSwitch"]
                             forKey:@"InboxMessageSoundSwitchPosition"];

    [standardUserDefaults setObject:[settings objectForKey:@"touchSoundSwitch"] 
                             forKey:@"TouchBaseMessageSoundSwitchPosition"];

    [standardUserDefaults setObject:[settings objectForKey:@"touchVibrateSwitch"]
                                     forKey:@"TouchBaseMessageVibrateSwitch"];
    [standardUserDefaults synchronize];
    
    [self checkInboxMessageVibrateSwitchPositions];
    [self checkTouchBaseMessageVibrateSwitchPositions];
    [self checkInboxMessageSoundSwitchPositions];
    [self checkTouchBaseMessageSoundSwitchPositions];
    [self checkpushNotificationSwitchPositions];
}

/*******************************************************************************
 *  Function Name: getSettingsFromPlistFile.
 *  Purpose: To get Settings from plist File.
 *  Parametrs: nil.
 *  Return Values:nil
 ********************************************************************************/
-(void)getSettingsFromPlistFile
{
    NSString *plistPath = [self getPlistFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if ([fileManager fileExistsAtPath: plistPath])
    {
        settingsData = [[NSMutableDictionary alloc] initWithContentsOfFile: plistPath];
        NSLog(@"Settingsdata==%@",settingsData);
        
        if(settingsData && [[settingsData allKeys] count])
        {
            NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileUserName"];
            
            if ([settingsData objectForKey:user]) {
                
                NSDictionary *userSettingsDict = [[NSDictionary alloc] initWithDictionary:[settingsData objectForKey:user]];
                [self userSettings:userSettingsDict];
            }
            else {
                [self checkSettingsWriteToPlistDict];
            }
        }
        else
        {
            [self checkSettingsWriteToPlistDict];
        }
        
    }
    else
    {
        //Create file and save default settings..
        
        [self checkSettingsWriteToPlistDict];
    }
}
/*******************************************************************************
 *  Function Name: checkSettingsWriteToPlistDict.
 *  Purpose: Check current settings and write plist dictionary.
 *  Parametrs: nil.
 *  Return Values:nil
 ********************************************************************************/
-(void)checkSettingsWriteToPlistDict
{
    NSString * pushNotiSwitch ;
    NSString * inboxMessageVibrate;
    NSString * inboxMessageSound ;
    NSString * touchBaseMessageVibrate;
    NSString * touchBaseMessageSound ;
    
    NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileUserName"];
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)]isEqualToString:@"1"])
    {
        pushNotiSwitch = @"1";
    }
    else
    {
         pushNotiSwitch = @"0";
    }
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"INBOX MESSAGE VIBRATE SWITCH", nil)]isEqualToString:@"1"])
    {
        inboxMessageVibrate = @"1";
    }
    else
    {
        inboxMessageVibrate = @"0";
    }
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"INBOX MESSAGE SOUND SWITCH", nil)]isEqualToString:@"1"])
    {
        inboxMessageSound = @"1";
    }
    else
    {
        inboxMessageSound = @"0";
    }
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"TOUCHBASE MESSAGE VIBRATE SWITCH", nil)]isEqualToString:@"1"])
    {
        touchBaseMessageVibrate = @"1";
    }
    else
    {
        touchBaseMessageVibrate = @"0";
    }
    if([[standardUserDefaults stringForKey:NSLocalizedString(@"TOUCHBASE MESSAGE SOUND SWITCH", nil)]isEqualToString:@"1"])
    {
        touchBaseMessageSound = @"1";
    }
    else
    {
        touchBaseMessageSound = @"0";
    }

    NSMutableDictionary *currentUserSettings = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userId,@"userId",pushNotiSwitch,@"pushNotiSwitch",inboxMessageVibrate,@"inboxVibrateSwitch",inboxMessageSound,@"inboxSoundSwitch",touchBaseMessageVibrate,@"touchVibrateSwitch",touchBaseMessageSound,@"touchSoundSwitch",nil ];

    [self writeSettingsToPlistFile:currentUserSettings];
    
    [self userSettings:currentUserSettings];


}
/*******************************************************************************
 *  Function Name: writeSettingsToPlistFile.
 *  Purpose: write current settings to plist file and update it.
 *  Parametrs: new settings as dictionary.
 *  Return Values:nil
 ********************************************************************************/
-(void)writeSettingsToPlistFile:(NSMutableDictionary*)dictToPlist
{
    NSMutableDictionary * saveSettingsData = [[NSMutableDictionary alloc] init]; 

    if (settingsData && [settingsData allKeys].count) {
        [saveSettingsData addEntriesFromDictionary:settingsData];
    }
    
    NSMutableDictionary * userSettings = [NSMutableDictionary dictionary];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileUserName"];
    if([userID length])
    {
        [userSettings setObject:dictToPlist forKey:userID];
        
        [saveSettingsData addEntriesFromDictionary:userSettings];
        
        NSString* plistPath = [self getPlistFilePath];
        NSLog(@"%@",plistPath);
        [saveSettingsData writeToFile:plistPath atomically:YES];
    }
}
/*******************************************************************************
 *  Function Name: getPlistFilePath.
 *  Purpose: To get plistFile path.
 *  Parametrs: nil.
 *  Return Values: File path as string.
 ********************************************************************************/
-(NSString *)getPlistFilePath
{
    NSArray *documentDirectoryPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentDirectoryPath objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    return plistPath;
}
#pragma mark- Button Actions
/*******************************************************************************
 *  InboxMessage Vibrate switch actions
 ********************************************************************************/
- (IBAction)inboxMessageVibrateSwitchToggle:(id)sender
{
    if (inboxMessageVibrateSwitchBtn.isOn)
    {
        [self localNotificationForInboxMessageVibrate];
    }
    else
    {
        [self removeNotificationForInboxMesssageVibrate];
    }
    [self checkSettingsWriteToPlistDict];
}

- (void)turnOnPushNotification
{
    AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.delegate = self;
    
    [standardUserDefaults setObject:@"1"
                             forKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)];
    //[standardUserDefaults synchronize];
    
    
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:( UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

/*******************************************************************************
 *  Push Notification switch actions
 ********************************************************************************/
- (IBAction)pushNotificationSwitchToggle:(id)sender
{
    
    if (pushNotificationSwitchBtn.isOn)
    {
//        [self setCustomOverlay];
        [self turnOnPushNotification];
    }
    else
    {
        [standardUserDefaults setObject:@"0"
                                 forKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)];
        //[standardUserDefaults synchronize];
        
        [[UIApplication sharedApplication]
         
         unregisterForRemoteNotifications];
    }
    [self checkSettingsWriteToPlistDict];
}

/*******************************************************************************
 *  Touch Base Message Vibrate switch actions
 ********************************************************************************/
- (IBAction)touchBaseMessageVibrateSwitchToggle:(id)sender
{
    if (touchBaseMessageVibrateSwitchBtn.isOn)
    {
        [self localNotificationForTouchBaseMessageVibrate];
    }
    else
    {
        [self removeNotificationForTouchBaseMessageVibrate];
    }
    [self checkSettingsWriteToPlistDict];
}
/*******************************************************************************
 *  Inbox Message Sound switch actions
 ********************************************************************************/
- (IBAction)inboxMessageSoundSwitchToggle:(id)sender
{
    if (inboxMessageSoundSwitchBtn.isOn)
    {
        [self localNotificationForInboxMessageSound];
    }
    else
    {
        [self removeNotificationForInboxMessageSound];
    }
    [self checkSettingsWriteToPlistDict];
}
/*******************************************************************************
 *  Touch Base Message Sound switch actions
 ********************************************************************************/
- (IBAction)touchBaseMessageSoundSwitchToggle:(id)sender
{
    if (touchBaseMessageSoundSwitchBtn.isOn)
    {
        [self localNotificationForTouchBaseMessageSound];
    }
    else
    {
        [self removeNotificationForTouchBaseMessageSound];
    }
    [self checkSettingsWriteToPlistDict];
}

/*******************************************************************************
 *  Back button touch action.
 ********************************************************************************/
- (IBAction)backButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*******************************************************************************
 *  Logout button touch action.
 ********************************************************************************/
-(IBAction)logoutButtonTouched:(id)sender
{
    AppDelegate *app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app logOutButtonTouched];
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
    if([result count]>0)
    {
        if(eparseType == pushNotificationAPI)
        {
//            [GeneralClass showAlertView:self
//                                    msg:@"Notification has been queued"
//                                  title:@"Push Notification"
//                            cancelTitle:@"OK"
//                             otherTitle:nil
//                                    tag:pushNotificationAPI];

            
        }
        else
        {
            NSLog(@"Error");
            [self parseFailedWithError:0 :nil :0];
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

#pragma mark- UIAlertView delegate
/*******************************************************************************
 *  UIAlertView delegate.
 ********************************************************************************/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [syncView removeFromSuperview];
    
    if(alertView.tag == parseErrorTag)
    {
        if(buttonIndex == 0)
        {
            [self setCustomOverlay];
            [self turnOnPushNotification];
            
        }
        else
        {
            [standardUserDefaults setObject:@"0"
                                     forKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)];
            [self checkpushNotificationSwitchPositions];
            
        }
    }
    else if(alertView.tag == reachabilityTag)
    {
        [standardUserDefaults setObject:@"0"
                                 forKey:NSLocalizedString(@"PUSH NOTIFICATION SWITCH", nil)];
        [self checkpushNotificationSwitchPositions];
    }
    
    alertView = nil;
}


#pragma mark- Memory
- (void)viewDidUnload
{
    [self setBackBtn:nil];
    [self setMobileSettingsLbl:nil];
    [self setPushNotificationSettingsLbl:nil];
    [self setTurnOnPushNotificationLbl:nil];
    [self setMobileAlertMessageLbl:nil];
    [self setMobileAlertTouchBaseLbl:nil];
    [self setTouchBaseMessageVibrateOnLbl:nil];
    [self setTouchBaseMessageSoundOnLbl:nil];
    [self setInboxMessageSoundOnLbl:nil];
    [self setInboxMessageVibrateOnLbl:nil];
    [super viewDidUnload];
}
- (void)dealloc
{
    [self setInboxMessageSoundSwitchBtn:nil];
    [self setInboxMessageVibrateSwitchBtn:nil];
    [self setTouchBaseMessageSoundSwitchBtn:nil];
    [self setTouchBaseMessageVibrateSwitchBtn:nil];
    [self setPushNotificationSwitchBtn:nil];
    [self checkSwitchPositions];
}
#pragma mark- Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
