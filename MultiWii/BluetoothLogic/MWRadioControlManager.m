//
//  MWRadioControlManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/23/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWRadioControlManager.h"
@interface MWRadioControlManager ()
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *yawEntity;
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *rollEntity;
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *pitchEntity;
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *throttleEntity;

@property (nonatomic, strong, readwrite) MWValueSettingsEntity *aux1Entity;
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *aux2Entity;
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *aux3Entity;
@property (nonatomic, strong, readwrite) MWValueSettingsEntity *aux4Entity;


@property (nonatomic, strong, readwrite) NSArray* allChannels;
@end

@implementation MWRadioControlManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.yawEntity = [[MWValueSettingsEntity alloc] init];
        self.rollEntity = [[MWValueSettingsEntity alloc] init];
        self.pitchEntity = [[MWValueSettingsEntity alloc] init];
        self.throttleEntity = [[MWValueSettingsEntity alloc] init];
        
        self.aux1Entity = [[MWValueSettingsEntity alloc] init];
        self.aux2Entity = [[MWValueSettingsEntity alloc] init];
        self.aux3Entity = [[MWValueSettingsEntity alloc] init];
        self.aux4Entity = [[MWValueSettingsEntity alloc] init];
        self.allChannels = @[self.rollEntity, self.pitchEntity, self.yawEntity, self.throttleEntity,
                             self.aux1Entity, self.aux2Entity, self.aux3Entity, self.aux4Entity];
        
        for (MWValueSettingsEntity* chan in self.allChannels) {
            chan.maxValue = 2000;
            chan.minValue = 1000;
            chan.step = 1;
            chan.value = 1000;
        }
        
    }
    return self;
}



-(NSData*) payloadFromRadioEntities {
    unsigned char bytes[8*2]; // 8 chan * 2 bytes for each
    
    for (int idx = 0; idx < 8; idx++) {
        MWValueSettingsEntity* entity = self.allChannels[idx];
        int val = entity.value;

        unsigned char lowBits = (unsigned char)((int)(val & ((1 << 9) - 1))); //i'm sorry
        val = val >> 8;
        unsigned char highBits = (unsigned char)((int)(val & ((1 << 9) - 1))); //i'm sorry
        bytes[idx * 2] = lowBits;
        bytes[idx * 2 + 1] = highBits;
    }
    return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

-(void) save:(dispatch_block_t)callback {
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_SET_RAW_RC andPayload:[self payloadFromRadioEntities] responseBlock:^(NSData *recieveData) {
        callback();
    }];
}

#pragma mark - setters/getters
-(void)setThrottle:(int)throttle {
    self.throttleEntity.value = throttle;
}
-(int)throttle {
    return self.throttleEntity.value;
}

-(void)setYaw:(int)yaw {
    self.yawEntity.value = yaw;
}
-(int)yaw {
    return self.yawEntity.value;
}

-(void)setPitch:(int)pitch {
    self.pitchEntity.value = pitch;
}
-(int)pitch {
    return self.pitchEntity.value;
}

-(void)setRoll:(int)roll {
    self.rollEntity.value = roll;
}
-(int)roll {
    return self.rollEntity.value;
}


-(void)setAux1:(int)aux1 {
    self.aux1Entity.value = aux1;
}
-(void)setAux2:(int)aux2 {
    self.aux2Entity.value = aux2;
}
-(void)setAux3:(int)aux3 {
    self.aux3Entity.value = aux3;
}
-(void)setAux4:(int)aux4 {
    self.aux4Entity.value = aux4;
}


-(int)aux1 {
    return self.aux1Entity.value;
}
-(int)aux2 {
    return self.aux2Entity.value;
}
-(int)aux3 {
    return self.aux3Entity.value;
}
-(int)aux4 {
    return self.aux4Entity.value;
}

@end
