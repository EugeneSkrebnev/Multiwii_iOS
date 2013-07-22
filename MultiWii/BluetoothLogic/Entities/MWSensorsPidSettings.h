//
//  MWSensorsPidSettings.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPIDSettingsEntity.h"

@interface MWSensorsPidSettings : NSObject
@property (nonatomic, strong) MWPIDSettingsEntity* baro;
@property (nonatomic, strong) MWPIDSettingsEntity* mag;
@end
