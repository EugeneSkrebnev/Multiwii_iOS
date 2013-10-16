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
        self.gpsPid = [[MWGPSPidSettings alloc] init];
        
        self.RCRates = [[MWRatesSettings alloc] init];
        [self makePidsIndexInit];
        [self makeDivedersInit];
    }
    return self;
}

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
    
    
    tmp[@13] = self.gpsPid.posHold.p;
    tmp[@14] = self.gpsPid.posHold.i;
//    tmp[@15] = NO value for pos hold d
    
    tmp[@16] = self.gpsPid.posHoldRate.p;
    tmp[@17] = self.gpsPid.posHoldRate.i;
    tmp[@18] = self.gpsPid.posHoldRate.d;
    
    tmp[@19] = self.gpsPid.navigationRate.p;
    tmp[@20] = self.gpsPid.navigationRate.i;
    tmp[@21] = self.gpsPid.navigationRate.d;
    
    _pidsPayloadIndexes = [tmp copy];
}

-(void) makeDivedersInit
{
    NSMutableDictionary* tmp = [NSMutableDictionary dictionaryWithCapacity:32];
    // fill diveders using 1 / step ... no hard code //refactor
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
    
    
    tmp[@13] = @100;
    tmp[@14] = @100;
    //    tmp[@15] = NO value for pos hold d
    
    tmp[@16] = @10;
    tmp[@17] = @100;
    tmp[@18] = @1000;
    
    tmp[@19] = @10;
    tmp[@20] = @100;
    tmp[@21] = @1000;
    
    
    _dividersForIndexes = [tmp copy];
    
}


-(void) fillPidFromPayload:(NSData*) pidData
{
    unsigned char *x = (unsigned char*)pidData.bytes;
//    x[0] = identifier
    for (int i = 1; i <= 30; i++)
    {
        MWSettingsEntity* pid = _pidsPayloadIndexes[@(i)];
        if (pid)
        {
            NSNumber* divider = _dividersForIndexes[@(i)];
            if (divider)
            {
                pid.value = x[i] / divider.floatValue;
                pid.savedValue = pid.value;
            }
        }
        else
        {
//            NSLog(@"LOGIC ERROR %@", NSStringFromSelector(_cmd));
        }
    }
}

-(NSData*) payloadFromPids
{
    unsigned char bytes[30]; // 30 is 112 request size
    for (int i = 0; i < 30; i++)
    {
        bytes[i] = 0;
    }
    for (NSNumber* key in _pidsPayloadIndexes)
    {
        MWSettingsEntity* pid = _pidsPayloadIndexes[key];
        int pidIndex = key.intValue;
        NSNumber* divider = _dividersForIndexes[key];
        bytes[pidIndex - 1] = (char)(pid.value * divider.floatValue);
    }
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

-(void) fillRcTunningFromPayload:(NSData*) payload
{
    unsigned char *bytes = (unsigned char*)payload.bytes;
    for (int i = 1; i < payload.length; i++)
    {
        MWSettingsEntity* rateEntity = self.RCRates.allSettings[i - 1];
        rateEntity.value = (float)bytes[i] / 100.;
        rateEntity.savedValue = rateEntity.value;
    }
}

-(NSData*) payloadFromRcTunning
{
    unsigned char bytes[7]; // 30 is 204 request size
    
    for (int i = 0; i < 7; i++)
    {
        MWSettingsEntity* rateEntity = self.RCRates.allSettings[i];
        bytes[i] = rateEntity.value * 100;   //100 because 0.01 step  = 1 / self.RCRates.rcRate.step
    }

    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

-(void) savePids
{
    for (int i = 1; i <= 30; i++)
    {
        MWSettingsEntity* pid = _pidsPayloadIndexes[@(i)];
        if (pid)
        {
            NSNumber* divider = _dividersForIndexes[@(i)];
            if (divider)
            {
                pid.savedValue = pid.value;
            }
        }
        else
        {
            //            NSLog(@"LOGIC ERROR %@", NSStringFromSelector(_cmd));
        }
    }

    
}

@end
