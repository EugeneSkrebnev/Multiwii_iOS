//
//  MWPidSettingsManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWPidSettingsManager.h"

@implementation MWPidSettingsManager


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
        self.flyPid = [[MWFlyPidSettings alloc] init];
        self.sensorsPid = [[MWSensorsPidSettings alloc] init];

    }
    return self;
}
@end
