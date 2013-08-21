//
//  RBAssetsTablePicker.h
//  Red Beacon
//
//  Created by Jayahari V on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RBAssetsTablePicker : UITableViewController {
    
    ALAssetsGroup *assetGroup;
    NSMutableArray *elcAssets;
    id parent;
    
}

@property (nonatomic, assign) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, assign) id parent;

- (int)totalSelectedAssets;

@end
