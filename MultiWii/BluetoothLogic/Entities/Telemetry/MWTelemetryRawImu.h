//
//  MWTelemetryRawImu.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWRawImuEntity.h"

@interface MWTelemetryRawImu : NSObject

@property (nonatomic, strong) MWRawImuEntity* acc;
@property (nonatomic, strong) MWRawImuEntity* gyro;
@property (nonatomic, strong) MWRawImuEntity* mag;


@end
