//
//  RBSignUpHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBSignUpHandler.h"
#import "FlurryAnalytics.h"

@implementation RBSignUpHandler

@synthesize isUsernameNotTaken,isEmailNotTaken;

#pragma mark -

#pragma mark Login APIs
NSString * const kSignUpApi = @"/rpc/signup";
NSString * const kEmailNotTakenApi = @"/account/email_nottaken";
NSString * const kUsernameNotTakenApi = @"/account/username_nottaken";
NSString * const kResetPasswordApi = @"/account/password/reset/";
#pragma mark -

#pragma mark Login API Params

NSString * const kNewUserNameKey = @"new_username";
NSString * const kEmailKey       = @"email";
NSString * const kPwd1Key        = @"password1";
NSString * const kPwd2Key        = @"password2";    
NSString * const kFirsNametKey   = @"first_name";
NSString * const kLastNameKey    = @"last_name";
NSString * const kPhoneKey       = @"phone";

#pragma mark - 

#pragma mark RBLoginHandler Methods
- (void)sendSignUpRequestWithUsername:(NSString*)email andPassword:(NSString*)password:(NSString*)telephoneNumber
{
    [FlurryAnalytics logEvent:@"Signup with Username"];
    NSString *apiName = kSignUpApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kEmailKey];
    NSString * value = [RBConstants urlEncodedParamStringFromString:email];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kPwd1Key];
    value = [RBConstants urlEncodedParamStringFromString:password];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kPwd2Key];
    value = [RBConstants urlEncodedParamStringFromString:password];
    [postParams setObject:value forKey:key];    

    key = [RBConstants urlEncodedParamStringFromString:kPhoneKey];
    value = [RBConstants urlEncodedParamStringFromString:telephoneNumber];
    [postParams setObject:value forKey:key]; 
    
    [self postRequest:apiName withParams:postParams withRequestType:kSignUp];
    
    [postParams release];
    postParams = nil;
}

- (void)resetPasswordViaEmail:(NSString*)email
{
    [FlurryAnalytics logEvent:@"Reset Password"];
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *apiName = kResetPasswordApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kEmailKey];
    NSString * value = [RBConstants urlEncodedParamStringFromString:email];
    [postParams setObject:value forKey:key];
     
    [self postRequest:apiName withParams:postParams withRequestType:KResetPassword];
    
    [postParams release];
    postParams = nil;    
    
    if (pool) {
        
        [pool drain];
    }
    
}

#pragma mark -

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    do 
    {
      
        NSLog(@"loginRequestFinished:Response %d : %@", 
              request.responseStatusCode, 
              [request responseStatusMessage]);
        
        // Use when fetching text data
        NSString *responseString = [request responseString];
        
        RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
        
        if (requestType == kSignUp)
        {
            // cookie code begin
            [self saveTheCookie:request];
            // cookie code end
            break;
        }
        
        if (requestType == kEmailNotTaken) 
        {
            if([responseString isEqualToString:@"true"])
            {
                isEmailNotTaken=YES;
            }
            else
            {
                isEmailNotTaken=NO;
            }
            break;
        }
        
        if(requestType == KResetPassword)
        {
            
        }
        
        // If you reach here  requestType == kUsernameNotTaken
        if([responseString isEqualToString:@"true"])
        {
            isUsernameNotTaken=YES;
        }
        else
        {
            isUsernameNotTaken=NO;
        }        

    } while (0); 
    
    [delegate requestCompletedSuccessfully:request];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
}
#pragma mark -


@end
