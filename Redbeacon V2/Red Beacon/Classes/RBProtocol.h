//
//  RBProtocol.h
//  Red Beacon
//
//  Created by Nithin George on 9/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RBProtocol <NSObject>

//LoginViewController Protocol

@protocol FBLoginDelegate <NSObject>
- (BOOL)handleOpenURL:(NSURL *)url;
@end


@end
