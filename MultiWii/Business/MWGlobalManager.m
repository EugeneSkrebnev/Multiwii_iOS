//
//  MWGlobalManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWGlobalManager.h"
#import "MKStoreManager.h"
@implementation MWGlobalManager

+ (MWGlobalManager *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

+ (void) initBluetoothLink
{
    
    PROTOCOL_MANAGER = [[MWMultiwiiProtocolManager alloc] init];
    [[self sharedInstance] initDefaultHandlers];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.bluetoothManager = [[MWBluetoothManager alloc] init];
        self.pidManager = [[MWPidSettingsManager alloc] init];

        self.boxManager = [[MWBoxSettingsManager alloc] init];
        self.telemetryManager = [[MWTelemetryManager alloc] init];

        self.controlManager = [[MWRadioControlManager alloc] init];
        [MKStoreManager sharedManager];
    }
    return self;
}

-(void) copterIdentInfoRecieved:(NSData*) copterInfo
{
    self.multiwiiSuccesConnect = YES;
    unsigned char *x = (unsigned char*)copterInfo.bytes;
    for (int i = 0; i < copterInfo.length; i++)
    {
        NSLog(@"%d", x[i]);
    }
    int identifier = x[0];
    if ((identifier != MWI_BLE_MESSAGE_IDENT) || (copterInfo.length < 8)) //8 is default size for ident request
    {
        NSLog(@"COPTER INFO ERROR %@", copterInfo);
        return;
    }
    
    self.version = x[1];
    int copterType = x[2];
    //refactor with array
    _copterType = MWGlobalManagerQuadTypeUnknown;
    if (copterType == 1)
        _copterType = MWGlobalManagerQuadTypeTricopter;
    if (copterType == 2)
        _copterType = MWGlobalManagerQuadTypePlus;
    if (copterType == 3)
        _copterType = MWGlobalManagerQuadTypeX;
    if (copterType == 4)
        _copterType = MWGlobalManagerQuadTypeBicopter;
    if (copterType == 5)
        _copterType = MWGlobalManagerQuadTypeGimbal;
    if (copterType == 6)
        _copterType = MWGlobalManagerQuadTypeY6;
    if (copterType == 7)
        _copterType = MWGlobalManagerQuadTypeHexPlus;
    if (copterType == 8)
        _copterType = MWGlobalManagerQuadTypeFlyingWing;
    if (copterType == 9)
        _copterType = MWGlobalManagerQuadTypeY4;
    if (copterType == 10)
        _copterType = MWGlobalManagerQuadTypeHexX;


    self.mspVersion = x[3];
    
    self.copterCapabilities = 0;
    if (x[4] != 0 )
        self.copterCapabilities |= MWGlobalManagerQuadBoardCapability1;
    if (x[5] != 0 )
        self.copterCapabilities |= MWGlobalManagerQuadBoardCapability2;
    if (x[6] != 0 )
        self.copterCapabilities |= MWGlobalManagerQuadBoardCapability3;
    if (x[7] != 0 )
        self.copterCapabilities |= MWGlobalManagerQuadBoardCapability4;
}

-(void) initDefaultHandlers
{
    __weak MWGlobalManager* selfWeak = self;
    
    //ident
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak copterIdentInfoRecieved:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_IDENT];
    
    //pid section
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.pidManager fillPidFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_PID];
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.pidManager savePids];
    } forRequestWith:MWI_BLE_MESSAGE_SET_PID];
    
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.boxManager fillBoxesNamesFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_BOX_NAMES];

    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.boxManager fillBoxesValuesFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_BOXES];

    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.pidManager fillRcTunningFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_RC_TUNNING];
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.pidManager saveRCRates];
    } forRequestWith:MWI_BLE_MESSAGE_SET_RC_TUNNING];
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.boxManager saveBoxes];
    } forRequestWith:MWI_BLE_MESSAGE_SET_BOXES];
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.telemetryManager.attitude fillValuesFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_ATTITUDE];
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.telemetryManager.radio fillRadioValuesFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_8_RC];

    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
        [selfWeak.telemetryManager.gps fillGPSValuesFromPayload:recieveData];
    } forRequestWith:MWI_BLE_MESSAGE_GET_RAW_GPS];
    
    [self.protocolManager setDefaultHandler:^(NSData *recieveData) {
//        NSLog(@"send rc data");
    } forRequestWith:MWI_BLE_MESSAGE_SET_RAW_RC];
}

-(NSString *)copterTypeString
{
    NSString* result = @"Unknown copter type";
    //refactor to array and indexes
    if (self.copterType == MWGlobalManagerQuadTypeTricopter)
        result = @"Tricopter";
    if (self.copterType == MWGlobalManagerQuadTypePlus)
        result = @"Quadrocopter +";
    if (self.copterType == MWGlobalManagerQuadTypeX)
        result = @"Quadrocopter X";
    if (self.copterType == MWGlobalManagerQuadTypeBicopter)
        result = @"Bicopter";
    if (self.copterType == MWGlobalManagerQuadTypeGimbal)
        result = @"Gimbal";
    if (self.copterType == MWGlobalManagerQuadTypeY6)
        result = @"Y6 Copter";
    if (self.copterType == MWGlobalManagerQuadTypeHexPlus)
        result = @"Hexacopter +";
    if (self.copterType == MWGlobalManagerQuadTypeFlyingWing)
        result = @"Flying wing";
    if (self.copterType == MWGlobalManagerQuadTypeY4)
        result = @"Y4 Copter";
    if (self.copterType == MWGlobalManagerQuadTypeHexX)
        result = @"Hexacopter X";
    return result;
}
@end
