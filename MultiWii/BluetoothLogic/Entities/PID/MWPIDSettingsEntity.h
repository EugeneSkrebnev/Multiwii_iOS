//
//  MWPIDSettingsEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWSettingsEntity.h"
@interface MWPIDSettingsEntity : NSObject

@property (nonatomic, strong) MWSettingsEntity* p;
@property (nonatomic, strong) MWSettingsEntity* i;
@property (nonatomic, strong) MWSettingsEntity* d;

@property (nonatomic, strong) NSArray* pid;

@end
