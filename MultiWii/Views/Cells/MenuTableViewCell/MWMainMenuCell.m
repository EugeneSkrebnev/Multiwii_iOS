//
//  MWMainMenuCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainMenuCell.h"

@implementation MWMainMenuCell

@synthesize title = _title;

+(NSString*) cellId
{
    return @"MWMainMenuCell_ID";
}

-(void) makeInit
{
//    self.selectedImageViewForIcon.image = [UIImage imageNamed:@""];
//    self.imageViewForIcon.image = [UIImage imageNamed:@""];
    
    self.labelForTitle.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.selectedLabelForTitle.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    
    UIImage* patternColorForUnselectedMenuItem = [UIImage imageNamed:@"gradient_menu-text@2x.png"];// stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    self.labelForTitle.textColor = [UIColor colorWithPatternImage:patternColorForUnselectedMenuItem];
    self.selectedLabelForTitle.textColor = [UIColor whiteColor];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.labelForTitle.text = title;
    self.selectedLabelForTitle.text = title;
}

-(NSString *)title
{
    return _title;
}
@end
