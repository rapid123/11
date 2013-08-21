//
//  RBFacebookHandler.m
//  Red Beacon
//
//  Created by Nithin George on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "RBFacebookHandler.h"
#import "FlurryAnalytics.h"


@implementation RBFacebookHandler

#pragma mark -

#pragma mark Login APIs
NSString * const kFacebookLoginApi = @"/home/signup_with_fb_access_key";

#pragma mark- RBLoginHandler Methods
- (void)sendFacebookLoginWithCookie:(NSString *)accessToken
{
    [FlurryAnalytics logEvent:@"Login with Facebook"];
    NSLog(@"AcessToken :- %@",accessToken);
    
    NSString *apiName = kFacebookLoginApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];

    NSString * key = [RBConstants urlEncodedParamStringFromString:@"access_token"];
    NSString * value = [RBConstants urlEncodedParamStringFromString:accessToken];

    [postParams setObject:value forKey:key];
    
    [self postRequest:apiName withParams:postParams withRequestType:kFacebookLogin];
    
    [postParams release];
     postParams = nil;
    
}
#pragma mark -

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString * response = [request responseString];
    
    NSDictionary * responseDictionary = [response JSONValue];
    NSLog(@"facebookLoginRequestCompleted :- responseDict: %@", responseDictionary);
    
    BOOL ResultValue = [[responseDictionary objectForKey:@"success"] boolValue];
    if (ResultValue)
    {
        // cookie code begin
        [self saveTheCookie:request];
        // cookie code end
    }
    
    [delegate requestCompletedSuccessfully:request];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"facebookLoginRequest failed");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
}
#pragma mark -


@end
