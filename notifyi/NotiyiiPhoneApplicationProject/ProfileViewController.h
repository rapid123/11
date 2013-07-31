//
//  ProfileViewController.h
//  Profile
//
//  Created by Amal T on 13/09/12.
//  Copyright (c) 2012 RapidValue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfile.h"

@interface ProfileViewController : UIViewController
{    
    IBOutlet UIImageView *profielImage;
}

@property(nonatomic, strong) MyProfile *myProfile;
@end
