//
//  GridCell.m
//  Red Beacon
//
//  Created by Nithin George on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridCell.h"


@implementation GridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)displayCellItems:(NSMutableArray *)items{
    
    int section_x=SECTION_X; //jobButton

    for(int col=0; col<[items count];col++){
        
        //Icon 
        NSString *title = [items objectAtIndex:col];
        
        UIButton *btnHome_Section = [[UIButton alloc]init];
        
        UIImage* image = [UIImage imageNamed:@"jobButton.png"];        
        
        btnHome_Section.frame=CGRectMake(section_x, SECTION_Y, image.size.width, image.size.height);
        
        btnHome_Section.backgroundColor=[UIColor clearColor];
        
        btnHome_Section.contentMode = UIViewContentModeScaleAspectFit;
        
        [btnHome_Section setBackgroundImage:[UIImage imageNamed:@"jobButton.png"] 
                                   forState:UIControlStateNormal];
        
        [btnHome_Section addTarget:[self superview] 
                            action:@selector(sectionButtonPresssed:) 
                  forControlEvents:UIControlEventTouchUpInside];
        
        btnHome_Section.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18.0]; 
        
        [btnHome_Section setTitle:title forState:UIControlStateNormal];
        
        [btnHome_Section setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self addSubview:btnHome_Section];
        [btnHome_Section release];
        btnHome_Section=nil;
        
        section_x=section_x+SECTION_SPACE;
    }
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
