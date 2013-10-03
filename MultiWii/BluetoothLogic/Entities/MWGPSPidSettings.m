//
//  MWGPSPidSettings.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWGPSPidSettings.h"

@implementation MWGPSPidSettings


- (id)init
{
    self = [super init];
    if (self)
    {
        self.posHold = [[MWPIDSettingsEntity alloc] init];
        self.posHoldRate = [[MWPIDSettingsEntity alloc] init];
        self.navigationRate = [[MWPIDSettingsEntity alloc] init];
        for (MWPIDSettingsEntity* pid in @[self.posHold])
        {
            pid.p.minValue = 0;
            pid.p.maxValue = 2.54;
            pid.p.step = 0.01;
            
            pid.i.minValue = 0;
            pid.i.maxValue = 2.54;
            pid.i.step = 0.01;
        }
        self.posHold.d = nil;

        for (MWPIDSettingsEntity* pid in @[self.posHoldRate, self.navigationRate])
        {
            pid.p.minValue = 0;
            pid.p.maxValue = 20.0;
            pid.p.step = 0.1;
            
            pid.i.minValue = 0;
            pid.i.maxValue = 2.54;
            pid.i.step = 0.01;
            
            pid.d.minValue = 0;
            pid.d.maxValue = 0.254;
            pid.d.step = 0.001;
        }
    }
    return self;
}

@end
