//
//  RBRequestInfo.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBConstants.h"

// This class is used to track requests in the NSOperationQueue
@interface RBRequestInfo : NSObject
{
    NSString * mediaFilename;
    RBMediaType mediaType;
    RBHTTPRequestType requestType;

}

@property (nonatomic, retain) NSString * mediaFilename;
@property (nonatomic, assign) RBMediaType mediaType;
@property (nonatomic, assign) RBHTTPRequestType requestType;

@end
