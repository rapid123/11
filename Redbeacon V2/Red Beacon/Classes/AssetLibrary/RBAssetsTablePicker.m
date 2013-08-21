//
//  RBAssetsTablePicker.m
//  Red Beacon
//
//  Created by Jayahari V on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBAssetsTablePicker.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"
#import "ELCImagePickerController.h"
#import "UINavigationItem + RedBeacon.h"
#import "RBSavedStateController.h"
#import "JobRequest.h"

@interface RBAssetsTablePicker (Private)
- (void)fetchAssetAlbum;
- (void)enumaratePhotos;
- (void)onCancel;
- (void)doneAction:(id)sender;
- (void)moveToLastRow;
@end

@implementation RBAssetsTablePicker
@synthesize elcAssets, assetGroup, parent;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setAllowsSelection:NO];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
    [tempArray release];
    
    UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    useButton.frame = CGRectMake(0, 0, 60, 30);
    useButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [useButton setTitle:@"Use" forState:UIControlStateNormal];
    [useButton setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [useButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:useButton];
    self.navigationItem.rightBarButtonItem = item;
    useButton=nil;
    [item release];
    item = nil;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 60, 30);
    cancelButton.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];  
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"DoneButton.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    item = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.leftBarButtonItem = item;
    cancelButton=nil;
    [item release];
    item = nil;
    
    [self.navigationItem setRBTitle:@"Loading..."];
    
    [self performSelector:@selector(fetchAssetAlbum) withObject:nil afterDelay:0.1];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([self.assetGroup numberOfAssets] / 4.0);
}

// ugly
-(NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
    int index = (_indexPath.row*4);
    int maxIndex = (_indexPath.row*4+3);
    
    // NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    
    if(maxIndex < [self.elcAssets count]) {
        
        return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
                [self.elcAssets objectAtIndex:index+1],
                [self.elcAssets objectAtIndex:index+2],
                [self.elcAssets objectAtIndex:index+3],
                nil];
    }
    
    else if(maxIndex-1 < [self.elcAssets count]) {
        
        return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
                [self.elcAssets objectAtIndex:index+1],
                [self.elcAssets objectAtIndex:index+2],
                nil];
    }
    
    else if(maxIndex-2 < [self.elcAssets count]) {
        
        return [NSArray arrayWithObjects:[self.elcAssets objectAtIndex:index],
                [self.elcAssets objectAtIndex:index+1],
                nil];
    }
    
    else if(maxIndex-3 < [self.elcAssets count]) {
        
        return [NSArray arrayWithObject:[self.elcAssets objectAtIndex:index]];
    }
    
    return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {		        
        cell = [[[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier] autorelease];
    }	
    else 
    {		
        [cell setAssets:[self assetsForIndexPath:indexPath]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 79;
}


#pragma mark -

- (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - picker methods
- (void)fetchAssetAlbum {
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                       // Group enumerator Block
                       void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                       {
                           if (group == nil) 
                           {
                               return;
                           }
                           self.assetGroup = group;
                           
                           // Keep this line!  w/o it the asset count is broken for some reason.  Makes no sense
                           NSLog(@"count: %d", [group numberOfAssets]);
                           
                           [self enumaratePhotos];
                       };
                       
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) 
                       {
                           
                           NSLog(@"Cannot find anyimages");
                       };	
                       // Enumerate Albums
                       ALAssetsLibrary *library =[self defaultAssetsLibrary];
                       [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                              usingBlock:assetGroupEnumerator 
                                            failureBlock:assetGroupEnumberatorFailure];
                       
                       //[library release];
                       [pool release];
                   });
}



- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(ELCAsset *asset in self.elcAssets) 
    {
        if([asset selected]) 
        {            
            count++;	
        }
    }
    
    return count;
}

- (void)enumaratePhotos {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    JobRequest *jobRequest = [[RBSavedStateController sharedInstance] jobRequest];
    [jobRequest initializeSearchingImages];
    
    NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) 
     {     
         if(result == nil) 
         {
             return;
         }
         
         ELCAsset *elcAsset = [[[ELCAsset alloc] initWithAsset:result] autorelease];
         [elcAsset setParent:self];
         [self.elcAssets addObject:elcAsset];
     }];    
    NSLog(@"done enumerating photos");
    
    [self.tableView reloadData];
    [self.navigationItem setRBTitle:@"Pick Photos"];
    [self moveToLastRow];
    [pool release];
    
}

- (void)moveToLastRow {
    int  numberOfRows = ceil([self.assetGroup numberOfAssets] / 4.0);
    int lastRowNumber = numberOfRows-1;
    NSIndexPath * lastIndexPath = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    if(lastRowNumber>=0)
    {
        [self.tableView scrollToRowAtIndexPath:lastIndexPath 
                              atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


- (void)doneAction:(id)sender {
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    NSMutableArray *selectedAssetsImages = [[[NSMutableArray alloc] init] autorelease];
    
    for(ELCAsset *elcAsset in self.elcAssets) 
    {		
        if([elcAsset selected]) {
            
            [selectedAssetsImages addObject:[elcAsset asset]];
        }
    }
    [(ELCImagePickerController*)self.parent selectedAssets:selectedAssetsImages];
    
}

- (void)onCancel {
    [(ELCImagePickerController*)self.parent cancelImagePicker];   
}

@end
