//
//  MWPidSettingsManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryManager.h"

@implementation MWTelemetryManager
{
}

#pragma mark - init section

+ (MWPidSettingsManager *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.raw = [[MWTelemetryRawImu alloc] init];
        self.altitude = [[MWTelemetryAltitude alloc] init];
        self.attitude = [[MWTelemetryAttitude alloc] init];
    }
    return self;
}


@end
