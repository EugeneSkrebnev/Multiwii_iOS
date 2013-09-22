//
//  MWGlobalManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPidSettingsManager.h"

typedef enum {
    MWGlobalManagerQuadTypeX,
    MWGlobalManagerQuadTypeTricopter,
    MWGlobalManagerQuadTypeBicopter,
    MWGlobalManagerQuadTypeGimbal,
    MWGlobalManagerQuadTypePlus,
    MWGlobalManagerQuadTypeHexPlus,
    MWGlobalManagerQuadTypeHexX,
    MWGlobalManagerQuadTypeFlyingWing,
    MWGlobalManagerQuadTypeY4,
    MWGlobalManagerQuadTypeY6,
    MWGlobalManagerQuadTypeUnknown
} MWGlobalManagerQuadType;

typedef enum {
    MWGlobalManagerQuadBoardCapability1 = 1,
    MWGlobalManagerQuadBoardCapability2 = 2,
    MWGlobalManagerQuadBoardCapability3 = 4,
    MWGlobalManagerQuadBoardCapability4 = 8
} MWGlobalManagerQuadBoardCapability;

@interface MWGlobalManager : NSObject
+ (MWGlobalManager *)sharedInstance;

@property (nonatomic, strong) MWMultiwiiProtocolManager* protocolManager;
@property (nonatomic, strong) MWPidSettingsManager* pidManager;
@property (nonatomic, strong) MWBluetoothManager* bluetoothManager;

@property (nonatomic, assign) MWGlobalManagerQuadType copterType;
@property (nonatomic, assign) MWGlobalManagerQuadType copterCapabilities;

@property (nonatomic, assign) int version;
@property (nonatomic, assign) int mspVersion;

@end
