//
//  MWPIDSettingsEntity.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWPIDSettingsEntity.h"

@implementation MWPIDSettingsEntity

- (id)init
{
    self = [super init];
    if (self)
    {
        self.p = [[MWSettingsEntity alloc] init];
        self.i = [[MWSettingsEntity alloc] init];
        self.d = [[MWSettingsEntity alloc] init];
        self.pid = @[self.p, self.i, self.d];
    }
    return self;
}
@end
