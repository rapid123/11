//
//  InboxTableViewCell.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 11/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inbox.h"

@interface InboxTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *patientLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *pNameContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *subjectContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *fromLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mailBoxImage;

-(void)displayDetails:(Inbox *)inbox;

@end
