//
//  MWAUXCheckBoxCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryRadioValuesCell.h"

@implementation MWTelemetryRadioValuesCell


-(void) setSettingsEntity:(MWSettingsEntity*) settingEntity forIndex:(int) indx
{
    MWValueSliderContainer* containerForIndex = self.valueSliderContainers[indx];
    containerForIndex.settingEntity = settingEntity;
}

-(MWSettingsEntity*) settingEntityForIndex:(int) ind
{
    return [self.valueSliderContainers[ind] settingEntity];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    int cap = (self.height - ( 4 * [self.valueSliderContainers.firstObject height] )) / 5;
    __block int startY = cap;
    
    [self.valueSliderContainers enumerateObjectsUsingBlock:^(UIView* valueSliderContainer, NSUInteger idx, BOOL *stop) {
        valueSliderContainer.top = startY;
        startY += [self.valueSliderContainers.firstObject height] + cap;
    }];
}

@end
