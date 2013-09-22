//
//  MWFlyPidSettings.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPIDSettingsEntity.h"

@interface MWFlyPidSettings : NSObject
@property (nonatomic, strong) MWPIDSettingsEntity* roll;
@property (nonatomic, strong) MWPIDSettingsEntity* pitch;
@property (nonatomic, strong) MWPIDSettingsEntity* yaw;
@property (nonatomic, strong) MWPIDSettingsEntity* level;
@property (nonatomic, strong) NSArray* allSettings;

@end
