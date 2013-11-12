//
//  MWGPSPidSettings.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPIDSettingsEntity.h"

@interface MWGPSPidSettings : NSObject
@property (nonatomic, strong) MWPIDSettingsEntity* posHold;
@property (nonatomic, strong) MWPIDSettingsEntity* posHoldRate;
@property (nonatomic, strong) MWPIDSettingsEntity* navigationRate;
@end
