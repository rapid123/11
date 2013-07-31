//
//  popOverViewController.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 03/10/12.
//
//

#import <UIKit/UIKit.h>
#import "State.h"

@protocol popOverSelectedDelegate <NSObject>

-(void)popOverStateSelected:(State *)selectedStateObj;

@end
@interface popOverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic, strong)id<popOverSelectedDelegate>delegate;
@property(nonatomic, strong) NSMutableArray *stateCodeArr;
@end
