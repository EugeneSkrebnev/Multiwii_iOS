//
//  MWSaveableSettingEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/18/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWAbstractSettingEntity.h"
@interface MWSaveableSettingEntity : MWAbstractSettingEntity

@property (nonatomic, assign) BOOL saved;
+(BOOL) haveUnsavedItems;
@end
