//
//  MWRateAdjustCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWRateAdjustCell.h"

@implementation MWRateAdjustCell


-(void) makeInit
{
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    for (UILabel* lbl in self.knobTitlesLabels)
    {
        lbl.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
        lbl.textColor = [UIColor colorWithRed:252./255 green:36./255 blue:8./255 alpha:1];
    }
}

-(void)setKnobEntities:(NSArray *)knobEntities
{
    for (int i = 0; i < MIN(knobEntities.count, self.knobContainers.count); i++)
    {
        MAKnobContainerLabeledView* knobContainer = self.knobContainers[i];
        knobContainer.settingEntity = knobEntities[i];
    }
}
@end
