//
//  MWSensorsPidSettings.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSensorsPidSettings.h"

@implementation MWSensorsPidSettings


- (id)init
{
    self = [super init];
    if (self)
    {
        self.baro = [[MWPIDSettingsEntity alloc] init];
        self.mag = [[MWPIDSettingsEntity alloc] init];
        for (MWPIDSettingsEntity* pid in @[self.baro, self.mag])
        {
            pid.p.minValue = 0;
            pid.p.maxValue = 20;
            pid.p.step = 0.1;
            
            pid.i.minValue = 0;
            pid.i.maxValue = 0.250;
            pid.i.step = 0.001;
            
            pid.d.minValue = 0;
            pid.d.maxValue = 100;
            pid.d.step = 1;
        }
        self.mag.i = nil;
        self.mag.d = nil;
    }
    return self;
}

@end
