//
//  MWPIDSettingsEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWValueSettingsEntity.h"
@interface MWPIDSettingsEntity : NSObject

@property (nonatomic, strong) MWValueSettingsEntity* p;
@property (nonatomic, strong) MWValueSettingsEntity* i;
@property (nonatomic, strong) MWValueSettingsEntity* d;

@property (nonatomic, strong) NSArray* pid;

@end
