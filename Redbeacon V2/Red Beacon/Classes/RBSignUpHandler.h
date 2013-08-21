//
//  RBSignUpHandler.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBURLHandler.h"
#import "ASIHTTPRequest.h"
#import "RBBaseHttpHandler.h"

@interface RBSignUpHandler : RBBaseHttpHandler
{
    BOOL isUsernameNotTaken;
    BOOL isEmailNotTaken;
}
@property(nonatomic) BOOL isUsernameNotTaken;
@property(nonatomic) BOOL isEmailNotTaken;

@end
