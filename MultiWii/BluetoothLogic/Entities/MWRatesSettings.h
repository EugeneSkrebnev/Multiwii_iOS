//
//  MWRatesSettings.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWSettingsEntity.h"

@interface MWRatesSettings : NSObject
@property (nonatomic, strong) MWSettingsEntity* rcExpo; //[0..1] 0.01
@property (nonatomic, strong) MWSettingsEntity* rcRate; //[0..2.50] 0.01

@property (nonatomic, strong) MWSettingsEntity* throttleMiddle; //[0..1] 0.01
@property (nonatomic, strong) MWSettingsEntity* throttleExpo;//[0..1] 0.01


@property (nonatomic, strong) MWSettingsEntity* rollPitchRate; //[0..1.00] 0.01
@property (nonatomic, strong) MWSettingsEntity* yawRate; //[0..1.00] 0.01
@property (nonatomic, strong) MWSettingsEntity* throttlePidAttenuationRate; //[0..1.00] 0.01


@end
