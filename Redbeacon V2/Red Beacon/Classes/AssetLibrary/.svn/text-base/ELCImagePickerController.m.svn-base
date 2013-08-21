//
//  ELCImagePickerController.m
//  ELCImagePickerDemo
//
//  Created by Collin Ruffenach on 9/9/10.
//  Copyright 2010 ELC Technologies. All rights reserved.
//

#import "ELCImagePickerController.h"
#import "ELCAsset.h"
#import "ELCAssetCell.h"

@implementation ELCImagePickerController

@synthesize delegate;

-(void)cancelImagePicker {

	if([delegate respondsToSelector:@selector(elcImagePickerControllerDidCancel:)]) {
		[delegate performSelector:@selector(elcImagePickerControllerDidCancel:) withObject:self];
	}
}

-(void)selectedAssets:(NSArray*)_assets {

	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	for(ALAsset *asset in _assets) {

		NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];

		[workingDictionary setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
       CGImageRef cgimage = [[asset defaultRepresentation] fullResolutionImage];
       //CGImageRef cgimage = [[asset defaultRepresentation] fullScreenImage];
      // CGImageRef cgimage = [asset thumbnail];
       UIImage * image = [UIImage imageWithCGImage:cgimage
                                             scale:1.0 
                                       orientation:[[asset valueForProperty:@"ALAssetPropertyOrientation"] intValue]];
		[workingDictionary setObject:image forKey:@"UIImagePickerControllerOriginalImage"];
       
       NSURL * url = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]];
       NSString * querry = [url query];
       NSArray* componenets = [querry componentsSeparatedByString:@"&"];
       NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS 'id='"];
       NSArray * filteredArray = [componenets filteredArrayUsingPredicate:predicate];
       NSString * object = [filteredArray objectAtIndex:0];
       NSString * stringIdentifier = [object stringByReplacingOccurrencesOfString:@"id=" withString:@""];
       long  number = [stringIdentifier longLongValue];
		[workingDictionary setObject:[NSNumber numberWithLongLong:number] forKey:@"UIImagePickerControllerReferenceID"];

		[returnArray addObject:workingDictionary];

		[workingDictionary release];
	}
    
    [self popToRootViewControllerAnimated:NO];
    [[self parentViewController] dismissModalViewControllerAnimated:YES];
    
	if([delegate respondsToSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:)]) {
		[delegate performSelector:@selector(elcImagePickerController:didFinishPickingMediaWithInfo:) withObject:self withObject:[NSArray arrayWithArray:returnArray]];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {    
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end
