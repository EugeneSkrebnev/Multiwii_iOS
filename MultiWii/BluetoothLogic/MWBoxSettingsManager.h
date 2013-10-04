//
//  MWPidSettingsManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFlyPidSettings.h"
#import "MWSensorsPidSettings.h"
#import "MWGPSPidSettings.h"

@interface MWBoxSettingsManager : NSObject

+ (MWPidSettingsManager *)sharedInstance;

@end
