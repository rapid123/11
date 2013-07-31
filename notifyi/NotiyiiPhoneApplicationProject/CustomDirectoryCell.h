//
//  CustomDirectoryCell.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 13/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Directory.h"
#import "State.h"

@interface CustomDirectoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *specialityLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

-(void)displayDetails:(Directory *)directory;
@end
