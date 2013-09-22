//
//  MWPidSettingsManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWPidSettingsManager.h"

@implementation MWPidSettingsManager
{
    NSDictionary* _pidsPayloadIndexes;
    NSDictionary* _dividersForIndexes;
}

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

-(int) indexForPidObject
{
    return 1;
}

//-(NSData*) payloadFromPid
//{
//    
//}

//-(int) deviderForPidIndex:(int) index
//{
//}


-(void) makePidsIndexInit
{
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:32];
    tmp[@1] = self.flyPid.roll.p;
    tmp[@2] = self.flyPid.roll.i;
    tmp[@3] = self.flyPid.roll.d;
    

    tmp[@4] = self.flyPid.pitch.p;
    tmp[@5] = self.flyPid.pitch.i;
    tmp[@6] = self.flyPid.pitch.d;


    tmp[@7] = self.flyPid.yaw.p;
    tmp[@8] = self.flyPid.yaw.i;
    tmp[@9] = self.flyPid.yaw.d;

    
    tmp[@22] = self.flyPid.level.p;
    tmp[@23] = self.flyPid.level.i;
    tmp[@24] = self.flyPid.level.d;

    
    tmp[@10] = self.sensorsPid.baro.p;
    tmp[@11] = self.sensorsPid.baro.i;
    tmp[@12] = self.sensorsPid.baro.d;

    
    tmp[@25] = self.sensorsPid.mag.p;
    
    _pidsPayloadIndexes = [tmp copy];
}

-(void) makeDivedersInit
{
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:32];
    
    tmp[@1] = @10;
    tmp[@2] = @1000;
    tmp[@3] = @1;

    tmp[@4] = @10;
    tmp[@5] = @1000;
    tmp[@6] = @1;

    tmp[@7] = @10;
    tmp[@8] = @1000;
    tmp[@9] = @1;

    tmp[@22] = @10;
    tmp[@23] = @100;
    tmp[@24] = @1;

    tmp[@10] = @10;
    tmp[@11] = @1000;
    tmp[@12] = @1;

    tmp[@25] = @10;
    _dividersForIndexes = [tmp copy];
    
}


-(void) fillPidFromPayload:(NSData*) pidData
{
    unsigned char *x = (unsigned char*)pidData.bytes;
//    x[0] = identifier
    for (int i = 1; i <= 30; i++)
    {
        MWSettingsEntity* pid = _pidsPayloadIndexes[@(i)];
        NSNumber* divider = _dividersForIndexes[@(i)];
        if (divider)
        {
            pid.value = x[i] / divider.floatValue;
        }
    }
//    self.flyPid.roll.p.value = x[1] / 10.;
//    self.flyPid.roll.i.value = x[2] / 1000.;
//    self.flyPid.roll.d.value = x[3];
//    
//    self.flyPid.pitch.p.value = x[4] / 10.;
//    self.flyPid.pitch.i.value = x[5] / 1000.;
//    self.flyPid.pitch.d.value = x[6];
//    
//    self.flyPid.yaw.p.value = x[7] / 10.;
//    self.flyPid.yaw.i.value = x[8] / 1000.;
//    self.flyPid.yaw.d.value = x[9];
//    
//    self.flyPid.level.p.value = x[22] / 10.;
//    self.flyPid.level.i.value = x[23] / 100.;
//    self.flyPid.level.d.value = x[24];
//    
//    self.sensorsPid.mag.p.value = x[25] / 10.;
//    
//    self.sensorsPid.baro.p.value = x[10] / 10.;
//    self.sensorsPid.baro.i.value = x[11] / 1000.;
//    self.sensorsPid.baro.d.value = x[12];

}
@end
