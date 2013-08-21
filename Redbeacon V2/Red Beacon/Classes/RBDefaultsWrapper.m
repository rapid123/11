//
//  ALDefaultsWrapper.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RBDefaultsWrapper.h"
#import "FlurryAnalytics.h"


@implementation RBDefaultsWrapper

NSString * const DEFAULTS_USERNAME = @"USER_NAME";
NSString * const DEFAULTS_USERPWD = @"USER_PWD";
NSString * const DEFAULTS_USER_FB_FULLNAME = @"FB_FULLNAME";
NSString * const DEFAULTS_OLD_LOGGEDIN_USER = @"OLD_USER";

+ (RBDefaultsWrapper *)standardWrapper
{
	return [[[RBDefaultsWrapper alloc] init] autorelease];
}

/*- (BOOL)setFirstAppLaunchDefaults
{
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	return YES;
}
    
- (BOOL)isAnonymous
{
    NSLog(@"Username = %@, Password = %@", self.currentUserName, self.currentPassword);
    
    if (self.currentUserName == nil || self.currentPassword == nil)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void)clearUserInformation
{
    [self updateUserName:nil];
    [self updatePassword:nil];

    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSString *)currentPassword
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERPWD];
}

-(void)updatePassword:(NSString *)newPassword
{
	[[NSUserDefaults standardUserDefaults] setObject:newPassword forKey:DEFAULTS_USERPWD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

- (void)updateUserName:(NSString *)newUserName
{
	[[NSUserDefaults standardUserDefaults] setObject:newUserName forKey:DEFAULTS_USERNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [FlurryAnalytics setUserID:newUserName];
}

-(void)updateFullName:(NSString *)newFullName {
    
    [[NSUserDefaults standardUserDefaults] setObject:newFullName forKey:DEFAULTS_USER_FB_FULLNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)lastuserLoggedIn:(NSString *)userName {
    
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DEFAULTS_OLD_LOGGEDIN_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)lastuser {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_OLD_LOGGEDIN_USER];
}

-(NSString *)currentUserName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USERNAME];
}

-(NSString *)FBUserName {

    return [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_USER_FB_FULLNAME];
}

-(void)clearUserInformation
{
//    if([self currentUserName])
//        [self lastuserLoggedIn:[self currentUserName]];
//    else if([self FBUserName])
//        [self lastuserLoggedIn:[self FBUserName]];
    
    
    [self updateUserName:nil];
    [self updateFullName:nil];
    [self lastuserLoggedIn:nil];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end

