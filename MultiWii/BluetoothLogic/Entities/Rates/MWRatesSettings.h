//
//  MWRatesSettings.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWValueSettingsEntity.h"

@interface MWRatesSettings : NSObject
@property (nonatomic, strong) MWValueSettingsEntity* rcExpo; //[0..1] 0.01
@property (nonatomic, strong) MWValueSettingsEntity* rcRate; //[0..2.50] 0.01

@property (nonatomic, strong) MWValueSettingsEntity* throttleMiddle; //[0..1] 0.01
@property (nonatomic, strong) MWValueSettingsEntity* throttleExpo;//[0..1] 0.01


@property (nonatomic, strong) MWValueSettingsEntity* rollPitchRate; //[0..1.00] 0.01
@property (nonatomic, strong) MWValueSettingsEntity* yawRate; //[0..1.00] 0.01
@property (nonatomic, strong) MWValueSettingsEntity* throttlePidAttenuationRate; //[0..1.00] 0.01

@property (nonatomic, strong) NSArray* allSettings;
@end
