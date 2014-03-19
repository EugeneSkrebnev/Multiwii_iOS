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
        self.rcExpo                     = [[MWValueSettingsEntity alloc] init];
        self.rcRate                     = [[MWValueSettingsEntity alloc] init];
        
        self.throttleMiddle             = [[MWValueSettingsEntity alloc] init];
        self.throttleExpo               = [[MWValueSettingsEntity alloc] init];
        
        self.rollPitchRate              = [[MWValueSettingsEntity alloc] init];
        self.yawRate                    = [[MWValueSettingsEntity alloc] init];
        self.throttlePidAttenuationRate = [[MWValueSettingsEntity alloc] init];
        
        self.allSettings = @[self.rcRate, self.rcExpo,
                             self.rollPitchRate, self.yawRate,
                             self.throttlePidAttenuationRate, self.throttleMiddle, self.throttleExpo];
        
        for (MWValueSettingsEntity* rate in self.allSettings)
        {
            rate.step     = 0.01;
            rate.minValue = 0;
            rate.maxValue = 1;
        }
        
        self.rcRate.maxValue = 2.5;
    }
    return self;
}
@end
