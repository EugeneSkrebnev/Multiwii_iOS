//
//  MWBluetoothManager.h
//  TestCoreBl
//
//  Created by Eugene Skrebnev on 6/16/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MWMultiwiiBleManagerSuitable.h"

#import "MWBluetoothManagerBiscuit1.h"
#import "MWBluetoothManagerBiscuit2.h"
#import "MWBluetoothManagerHM10.h"

typedef NS_ENUM(NSInteger, MWBluetoothManagerType) {
    MWBluetoothManagerTypeBiscuit = 0,
    MWBluetoothManagerTypeBiscuitV2 = 1,
    MWBluetoothManagerTypeHM10 = 2
};

@interface MWBluetoothManager : NSObject<MWMultiwiiBleManagerSuitable>

@property (nonatomic, assign) MWBluetoothManagerType boardType;
@property (nonatomic, strong) MWBluetoothManagerBiscuit2 *biscuitManagerOld;
@property (nonatomic, strong) MWBluetoothManagerBiscuit1 *biscuitManagerNew;
@property (nonatomic, strong) MWBluetoothManagerHM10 *HM10Manager;

@end
