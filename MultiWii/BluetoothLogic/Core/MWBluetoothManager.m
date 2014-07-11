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
        _boardType = MWBluetoothManagerTypeBiscuit;
    }
    return self;
}

- (MWBluetoothManagerBiscuit2 *)biscuitManagerOld
{
    if (!_biscuitManagerOld)
    {
        _biscuitManagerOld = [[MWBluetoothManagerBiscuit2 alloc] init];
    }
    return _biscuitManagerOld;
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
    NSArray* providers = @[self.biscuitManagerNew, self.biscuitManagerOld, self.HM10Manager];
    return providers[self.boardType];
}

-(void)setBoardType:(MWBluetoothManagerType)boardType {
    NSArray* providers = @[self.biscuitManagerNew, self.biscuitManagerOld, self.HM10Manager];
    [self copyFromBluetooth:providers[_boardType] toBluetooth:providers[boardType]];
    _boardType = boardType;
}

-(void) copyFromBluetooth:(id<MWMultiwiiBleManagerSuitable>) from toBluetooth:(id<MWMultiwiiBleManagerSuitable>) to
{
    //some nice code
    to.isReadyToUse = from.isReadyToUse;
    to.didUpdateStateBlock = from.didUpdateStateBlock;
    to.didAddDeviceToListBlock = from.didAddDeviceToListBlock;
    to.didStartScan = from.didStartScan;
    to.didStopScan = from.didStopScan;
    to.readyForReadWriteBlock = from.readyForReadWriteBlock;
    
    to.didConnectBlock = from.didConnectBlock;
    to.didFailToConnectBlock = from.didFailToConnectBlock;
    
    to.didDisconnectBlock = from.didDisconnectBlock;
    to.didDisconnectWithErrorBlock = from.didDisconnectWithErrorBlock;
    
    to.didDiscoverServices = from.didDiscoverServices;
    to.didFailToDiscoverServices = from.didFailToDiscoverServices;
    
    to.didFailToFindService = from.didFailToFindService;
    to.didDiscoverCharacteristics = from.didDiscoverCharacteristics;
    to.didFailToDiscoverCharacteristics = from.didFailToDiscoverCharacteristics;
    to.didRecieveData = from.didRecieveData;
    to.didFailUpdateCharacteristic = from.didFailUpdateCharacteristic;
    
    to.didUpdateRssi = from.didUpdateRssi;
    to.didFailUpdateRssi = from.didFailUpdateRssi;
    to.rssiNotificationOn = from.rssiNotificationOn;
}

@end
