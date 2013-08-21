//
//  RBURLHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBURLHandler.h"
//#import "RBConstants.h"//prod/test server macro


@implementation RBURLHandler

NSString * const kURLWebServerPROD = @"http://www.redbeacon.com";
NSString * const kURLWebServerPRODHTTPS = @"https://www.redbeacon.com";
NSString * const kURLWebServerQA = @"http://redbeacon-inc.com";//@"http://redbeacon-inc.com:80";
//NSString * const kURLWebServerQA = @"http://redbeacon-inc.com:10508";


+ (BOOL)useHttpsService:(RBHTTPRequestType)requestType {
    
    BOOL useHttps = NO;
    if(requestType == kSignUp || 
       requestType == kSessionExpiry ||
       requestType == kLogin ||
       requestType == kFacebookLogin) 
        
        useHttps = YES;
    
    return useHttps;
}

+ (NSString*)RBWEBSERVERURL:(RBHTTPRequestType)requestType
{
	NSString *result = nil;
#ifdef PROD_CONFIG
    if(requestType && [self useHttpsService:requestType])
        result = kURLWebServerPRODHTTPS;
    else    
        result = kURLWebServerPROD;
#else
	result = kURLWebServerQA;
#endif
	NSLog(@"RBURLHandler returned RBWEBSERVERURL: %@", result);
	return result;
}





@end
