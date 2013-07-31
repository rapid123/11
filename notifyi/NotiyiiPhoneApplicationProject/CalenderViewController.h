//
//  CalenderViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderCell.h"
#import "DataManager.h"

@interface CalenderViewController : UIViewController<NSFetchedResultsControllerDelegate>
{
    
}

@property(nonatomic,strong)IBOutlet CalenderCell *calenderCell;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

