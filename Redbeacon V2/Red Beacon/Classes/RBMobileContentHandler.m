
//
//  RBMobileContentHandler.m
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBMobileContentHandler.h"
#import "SBJson.h"
#import "ManagedObjectContextHandler.h"

@implementation RBMobileContentHandler

@synthesize hashCode, isZipcodeValid;

#pragma mark -

#pragma mark Login APIs
NSString * const kContentApi = @"/m/c/content";
NSString * const kHashApi = @"/m/c/content/hash";
NSString * const kLocationValidationApi = @"/jobsdone/validate_address";
#pragma mark -

#pragma mark Login API Params
NSString * const kZipcodeKey = @"full_address";
#pragma mark -


#pragma mark RBLoginHandler Methods
- (void)sendContentRequest
{
    [self sendHashRequest];
}

- (void)sendHashRequest
{
    NSString *apiName = kHashApi;

    [self getRequest:apiName withRequestType:kHash];
    
}

- (void)sendLocationRequest:(NSString*)zipcode
{
    NSString *apiName = kLocationValidationApi;
    
    NSMutableDictionary * postParams = [[NSMutableDictionary alloc] init];
    
    NSString * key = [RBConstants urlEncodedParamStringFromString:kZipcodeKey];
    NSString * value = [RBConstants urlEncodedParamStringFromString:zipcode];
    [postParams setObject:value forKey:key];
    

    [self postRequest:apiName withParams:postParams withRequestType:kZipcodeValidation];
    
    [postParams release];
    postParams = nil;    
}

#pragma mark -

#pragma mark - ASIHTTPRequest Delegates
- (void)requestFinished:(ASIHTTPRequest *)request
{
    hashCode = nil;
    NSLog(@"RequestFinished:Response %d : %@", 
          request.responseStatusCode, 
          [request responseStatusMessage]);
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *list = [parser objectWithString:responseString error:nil];
    hashCode = [list valueForKey:@"hash"];
    [parser release];
    
        
    RBHTTPRequestType requestType = [RBBaseHttpHandler getRequestType:request];
    
    if (requestType == kContent)
    {
        //if hash code is present, means response is valid, not crashed.
        if (hashCode) {
            //save new hash code
            [[NSUserDefaults standardUserDefaults] setValue:hashCode forKey:KEY_HASHCODE];
            
            //saving cities
            NSMutableDictionary * cities = [[list valueForKey:@"content"] valueForKey:@"cities"];
            [[ManagedObjectContextHandler sharedInstance] saveCities:cities];
            cities = nil;
            
            NSMutableArray * occupations = [[list valueForKey:@"content"] valueForKey:@"occupations"];
            [[ManagedObjectContextHandler sharedInstance] saveOccupations:occupations];
            occupations = nil;
        }        
    }
    else if (requestType == kHash)
    {
        hashCode = [list valueForKey:@"hash"];        
        NSString * oldHashCode = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_HASHCODE];
         
        //if hash code is present, means response is valid, not crashed. and different from the older one
        if (![oldHashCode isEqualToString:hashCode] && hashCode != nil) {
           
            NSLog(@"NEW HASH CODE SEEN");
            NSString *apiName = kContentApi;
            
            //FETCH NEW CONTENTS
            [self getRequest:apiName withRequestType:kContent];
        }     
    }
    else
    {
        if([list valueForKey:@"success"]==@"true")
        {
            isZipcodeValid = YES;
        }
        else
        {
            isZipcodeValid = NO;
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


-(NSString*)getHashCode
{
    return hashCode;
}


- (void)dealloc {
    self.hashCode = nil;
    [super dealloc];
}

@end
