//
//  MWPidSettingsManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWPidSettingsManager.h"

@implementation MWPidSettingsManager


#pragma mark - init section

+ (MWPidSettingsManager *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.flyPid = [[MWFlyPidSettings alloc] init];
        self.sensorsPid = [[MWSensorsPidSettings alloc] init];

    }
    return self;
}

-(void) fillPidFromPayload:(NSData*) pidData
{
    unsigned char *x = (unsigned char*)pidData.bytes;
    self.flyPid.roll.p.value = x[1] / 10.;
    self.flyPid.roll.i.value = x[2] / 1000.;
    self.flyPid.roll.d.value = x[3];
    
    self.flyPid.pitch.p.value = x[4] / 10.;
    self.flyPid.pitch.i.value = x[5] / 1000.;
    self.flyPid.pitch.d.value = x[6];
    
    self.flyPid.yaw.p.value = x[7] / 10.;
    self.flyPid.yaw.i.value = x[8] / 1000.;
    self.flyPid.yaw.d.value = x[9];
    
    self.flyPid.level.p.value = x[22] / 10.;
    self.flyPid.level.i.value = x[23] / 100.;
    self.flyPid.level.d.value = x[24];
    
    self.sensorsPid.mag.p.value = x[25] / 10.;
    
    self.sensorsPid.baro.p.value = x[10] / 10.;
    self.sensorsPid.baro.i.value = x[11] / 1000.;
    self.sensorsPid.baro.d.value = x[12];

}
@end
