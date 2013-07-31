//
//  DirectoryDetailsViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Directory.h"

@interface DirectoryDetailsViewController : UIViewController


@property (strong, nonatomic) NSArray *directoryManagerArr;
@property (assign) int selectedDirectoryNumber;

-(IBAction)backButtonTouched:(id)sender;
@end
