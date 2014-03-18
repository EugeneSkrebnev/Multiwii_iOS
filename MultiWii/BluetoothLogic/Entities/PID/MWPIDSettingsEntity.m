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
        self.p = [[MWValueSettingsEntity alloc] init];
        self.i = [[MWValueSettingsEntity alloc] init];
        self.d = [[MWValueSettingsEntity alloc] init];
        self.pid = @[self.p, self.i, self.d];
    }
    return self;
}

-(BOOL)isEqual:(MWPIDSettingsEntity*)object
{
    return [object.p isEqual:self.p] && [object.i isEqual:self.i] && [object.d isEqual:self.d];
}

@end
