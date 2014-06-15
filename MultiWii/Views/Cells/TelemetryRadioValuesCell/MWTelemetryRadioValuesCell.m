//
//  MWAUXCheckBoxCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryRadioValuesCell.h"

@implementation MWTelemetryRadioValuesCell


-(void) setSettingsEntity:(MWRadioValueEntity*) settingEntity forIndex:(int) indx
{
    MWValueSliderContainer* containerForIndex = self.valueSliderContainers[indx];
    containerForIndex.settingEntity = settingEntity;
}

-(MWRadioValueEntity*) settingEntityForIndex:(int) ind
{
    return [self.valueSliderContainers[ind] settingEntity];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIView* firstContainer = self.valueSliderContainers.firstObject;
    int cap = (self.height - ( 4 * firstContainer.height )) / 5;
    __block int startY = cap;
    
    [self.valueSliderContainers enumerateObjectsUsingBlock:^(UIView* valueSliderContainer, NSUInteger idx, BOOL *stop) {
        valueSliderContainer.top = startY;
        UIView* firstContainer = self.valueSliderContainers.firstObject;
        startY += firstContainer.height + cap;
    }];
}

@end
