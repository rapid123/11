//
//  JobRequestFinishedViewController.h
//  Red Beacon
//
//  Created by Joe on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JobRequestFinishedViewController : UIViewController {
	
    UILabel *topLabel;
    UILabel *bottomLabel;
    
}

@property (nonatomic, retain) IBOutlet UILabel *topLabel;
@property (nonatomic, retain) IBOutlet UILabel *bottomLabel;

- (void)createCustomNavigationLeftButton;

-(IBAction)cancelButtonClicked:(id)sender;

@end
