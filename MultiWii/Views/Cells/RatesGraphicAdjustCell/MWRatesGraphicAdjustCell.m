//
//  MWRatesGraphicAdjustCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWRatesGraphicAdjustCell.h"

@implementation MWRatesGraphicAdjustCell


-(void) makeInit
{
    self.sliderRight.transform = CGAffineTransformMakeRotation(M_PI * -0.5);
    for (UILabel* lbl in self.slidersTitleLabels)
    {
        lbl.font = [UIFont fontWithName:@"Montserrat-Regular" size:10];
        lbl.textColor = [UIColor colorWithRed:252./255 green:36./255 blue:8./255 alpha:1];        
    }

}

@end
