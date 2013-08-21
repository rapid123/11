//
//  RBFacebookHandler.h
//  Red Beacon
//
//  Created by Nithin George on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBURLHandler.h"
#import "ASIHTTPRequest.h"
#import "RBDefaultsWrapper.h"
#import "RBBaseHttpHandler.h"

@interface RBFacebookHandler : RBBaseHttpHandler
{
    
}
- (void)sendFacebookLoginWithCookie:(NSString *)accessToken;


@end