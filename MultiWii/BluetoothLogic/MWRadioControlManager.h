//
//  MWRadioControlManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/23/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWValueSettingsEntity.h"

@interface MWRadioControlManager : NSObject

@property (nonatomic, assign) int yaw;
@property (nonatomic, assign) int roll;
@property (nonatomic, assign) int pitch;
@property (nonatomic, assign) int throttle;

@property (nonatomic, assign) int aux1;
@property (nonatomic, assign) int aux2;
@property (nonatomic, assign) int aux3;
@property (nonatomic, assign) int aux4;

@property (nonatomic, strong, readonly) MWValueSettingsEntity *yawEntity;
@property (nonatomic, strong, readonly) MWValueSettingsEntity *rollEntity;
@property (nonatomic, strong, readonly) MWValueSettingsEntity *pitchEntity;
@property (nonatomic, strong, readonly) MWValueSettingsEntity *throttleEntity;

@property (nonatomic, strong, readonly) MWValueSettingsEntity *aux1Entity;
@property (nonatomic, strong, readonly) MWValueSettingsEntity *aux2Entity;
@property (nonatomic, strong, readonly) MWValueSettingsEntity *aux3Entity;
@property (nonatomic, strong, readonly) MWValueSettingsEntity *aux4Entity;


@property (nonatomic, strong, readonly) NSArray* allChannels;


-(NSData*) payloadFromRadioEntities;
-(void) save:(dispatch_block_t)callback;

@end
