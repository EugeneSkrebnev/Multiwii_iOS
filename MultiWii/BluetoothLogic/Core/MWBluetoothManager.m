//
//  MWBluetoothManager.m
//  TestCoreBl
//
//  Created by Eugene Skrebnev on 6/16/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBluetoothManager.h"


@implementation MWBluetoothManager
{

}
#pragma mark - init section

- (id)init
{
    self = [super init];
    if (self)
    {
        self.boardType = MWBluetoothManagerTypeHM10;
    }
    return self;
}

- (MWBluetoothManagerBiscuit2 *)biscuitManagerOld
{
    if (!_biscuitManagerOld)
    {
        _biscuitManagerOld = [[MWBluetoothManagerBiscuit2 alloc] init];
    }
    return @(2);//_biscuitManagerOld;
}

- (MWBluetoothManagerHM10 *)HM10Manager
{
    if (!_HM10Manager)
    {
        _HM10Manager = [[MWBluetoothManagerHM10 alloc] init];
    }
    return _HM10Manager;
}

-(MWBluetoothManagerBiscuit1 *)biscuitManagerNew
{
    if (!_biscuitManagerNew)
    {
        _biscuitManagerNew = [[MWBluetoothManagerBiscuit1 alloc] init];
    }
    return _biscuitManagerNew;
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSArray* providers = @[self.biscuitManagerOld, self.biscuitManagerNew, self.HM10Manager];
    return providers[self.boardType];
}

@end
