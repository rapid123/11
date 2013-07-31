//
//  LoginViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonParser.h"
#import "SyncManager.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,JsonParserDelegate,SyncDelegates>
{
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *forgotPasswordButton;
    IBOutlet UIButton *contactUsButton;
    
}
@end
