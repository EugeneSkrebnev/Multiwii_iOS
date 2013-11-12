//
//  MWRatesSettings.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWRatesSettings.h"

@implementation MWRatesSettings

- (id)init
{
    self = [super init];
    if (self)
    {
        self.rcExpo = [[MWSettingsEntity alloc] init];
        self.rcRate = [[MWSettingsEntity alloc] init];
        
        self.throttleMiddle = [[MWSettingsEntity alloc] init];
        self.throttleExpo = [[MWSettingsEntity alloc] init];
        
        self.rollPitchRate = [[MWSettingsEntity alloc] init];
        self.yawRate = [[MWSettingsEntity alloc] init];
        self.throttlePidAttenuationRate = [[MWSettingsEntity alloc] init];
        
        self.allSettings = @[self.rcRate, self.rcExpo, self.rollPitchRate, self.yawRate, self.throttlePidAttenuationRate, self.throttleMiddle, self.throttleExpo];
        
//        float i = 0.1;
        for (MWSettingsEntity* rate in self.allSettings)
        {
            rate.step = 0.01;
            rate.minValue = 0;
            rate.maxValue = 1;
//            rate.value = i;
//            i += 0.1;
        }
        
        self.rcRate.maxValue = 2.5;
    }
    return self;
}
@end
