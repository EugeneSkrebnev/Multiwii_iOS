//
//  MWFlyPidSettings.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWFlyPidSettings.h"

@implementation MWFlyPidSettings

- (id)init
{
    self = [super init];
    if (self)
    {
        self.roll = [[MWPIDSettingsEntity alloc] init];
        self.pitch = [[MWPIDSettingsEntity alloc] init];
        self.yaw = [[MWPIDSettingsEntity alloc] init];
        self.level = [[MWPIDSettingsEntity alloc] init];
        
        
        for (MWPIDSettingsEntity* pid in @[self.roll, self.pitch, self.yaw, self.level])
        {
            pid.p.minValue = 0;
            pid.p.maxValue = 20;
            pid.p.step = 0.1;
            pid.p.value = 3.3;
            
            pid.i.minValue = 0;
            pid.i.maxValue = 0.250;
            pid.i.step = 0.001;
            pid.i.value = 0.030;
            
            pid.d.minValue = 0;
            pid.d.maxValue = 100;
            pid.d.step = 1;
            pid.d.value = 20;
        }
        
    }
    return self;
}
@end
