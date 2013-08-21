//
//  RBAsyncHTTPRequestHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBLoginHandler.h"
#import "FlurryAnalytics.h"


@implementation RBLoginHandler

#pragma mark -

#pragma mark Login APIs
NSString * const kLoginApi = @"/accounts/login/";
NSString * const kLogoutApi = @"/accounts/logout/";
NSString * const kSessionExpiryApi = @"/rpc/whoami";
#pragma mark -

#pragma mark Login API Params
NSString * const kLoginUserKey = @"username";
NSString * const kLoginPwdKey = @"password";
#pragma mark -

#pragma mark RBLoginHandler Methods
- (void)sendLoginRequestWithUsername:(NSString*)username andPassword:(NSString*)password
{
    [FlurryAnalytics logEvent:@"Login with Username"];
    NSString *apiName = kLoginApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kLoginUserKey];
    NSString * value = [RBConstants urlEncodedParamStringFromString:username];
    [postParams setObject:value forKey:key];
    
    key = [RBConstants urlEncodedParamStringFromString:kLoginPwdKey];
    value = [RBConstants urlEncodedParamStringFromString:password];
    [postParams setObject:value forKey:key];
    
    [self postRequest:apiName withParams:postParams withRequestType:kLogin];
    
    [postParams release];
    postParams = nil;
                         
}

- (void)sendLogoutRequest
{
    [FlurryAnalytics logEvent:@"Logout"];
    NSString *apiName = kLogoutApi;
    
    [self getRequest:apiName withRequestType:kLogout];
    
}

- (void)sendSessionExpiryRequest
{
    NSString *apiName = kSessionExpiryApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    [self postRequest:apiName withParams:postParams withRequestType:kSessionExpiry];
    
    [postParams release];
    postParams = nil;
}
#pragma mark -

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"loginRequestFinished:Response %d : %@", 
          request.responseStatusCode, 
          [request responseStatusMessage]);
    
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    
    NSLog(@"%d", requestType);
    NSLog(@"Value:%@",[request responseString]);
    if (requestType == kLogout)
    {
        [RBBaseHttpHandler clearSession];
    }
    
    if(requestType == kLogin)
    {
        // cookie code begin
        [self saveTheCookie:request];
        // cookie code end
        
    }
    if (requestType == kSessionExpiry)
    {
        NSString *responseString = [request responseString];
        NSLog(@"Session Expiry Response String: %@", responseString);
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *status = [parser objectWithString:responseString error:nil];    
        NSLog(@"Response username: '%@'", [status valueForKey:@"username"]);
        
        [parser release];
        parser = nil;
        
        NSString *result = (NSString*)[status valueForKey:@"username"];
        
        if ( result != (id)[NSNull null] ) {
            
            
            if ([result rangeOfString:@"fb_"].location == NSNotFound) {
                NSLog(@"Username does not contain 'fb_'");
            } 
            
            RBDefaultsWrapper *sharedWrapper = [RBDefaultsWrapper standardWrapper];
            NSLog(@"Defaults username: '%@'", [sharedWrapper currentUserName]);
            if([[sharedWrapper currentUserName] isEqualToString:result] || result != (id)[NSNull null])
            {
                [delegate sessionValid:YES];
            }
            else
            {
                [delegate sessionValid:NO];               
            }    
        }
        else
        {
            //handle when the user name become null
            [delegate sessionValid:NO]; 
        }
    }
    
    [delegate requestCompletedSuccessfully:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
}
#pragma mark -


@end
