//
//  MWMultiwiiBleManagerSuitable.h
//  MultiWii
//
//  Created by Evgeniy Skrebnev on 6/17/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MWBluetoothManagerErrorBlock)(NSError* error, CBPeripheral* failDevice);
typedef void(^MWBluetoothManagerConnectBlock)(CBPeripheral* connectedDevice);
typedef void(^MWBluetoothManagerRecieveDataBlock)(CBPeripheral* connectedDevice, NSData* recieveData);

@protocol MWMultiwiiBleManagerSuitable <NSObject>

@required
@property (nonatomic, readonly) CBCentralManager* centralManager;
@property (nonatomic, readonly) NSArray* deviceList;
@property (nonatomic, readonly) CBPeripheral* currentConnectedDevice; // work with only one at time
@property (nonatomic, assign) BOOL rssiNotificationOn;

//status
@property (nonatomic, readonly) BOOL isReadyToUse;
@property (nonatomic, readonly) BOOL isInScanMode;
@property (nonatomic, readonly) BOOL isReadyToReadWrite;

//delegate blocks
@property (nonatomic, strong) dispatch_block_t didUpdateStateBlock;
@property (nonatomic, strong) dispatch_block_t didAddDeviceToListBlock;
@property (nonatomic, strong) dispatch_block_t didStartScan;    // can use for update spinner
@property (nonatomic, strong) dispatch_block_t didStopScan;     // can use for update spinner

@property (nonatomic, strong) dispatch_block_t readyForReadWriteBlock;

@property (nonatomic, strong) MWBluetoothManagerConnectBlock didConnectBlock;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didFailToConnectBlock;

@property (nonatomic, strong) MWBluetoothManagerConnectBlock didDisconnectBlock;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didDisconnectWithErrorBlock;


@property (nonatomic, strong) MWBluetoothManagerConnectBlock didDiscoverServices;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didFailToDiscoverServices;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didFailToFindService;

@property (nonatomic, strong) MWBluetoothManagerConnectBlock didDiscoverCharacteristics;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didFailToDiscoverCharacteristics;


@property (nonatomic, strong) MWBluetoothManagerRecieveDataBlock didRecieveData;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didFailUpdateCharacteristic;

@property (nonatomic, strong) MWBluetoothManagerConnectBlock didUpdateRssi;
@property (nonatomic, strong) MWBluetoothManagerErrorBlock didFailUpdateRssi;

//methods
-(void) startScan;
-(void) stopScan;
-(void) connectToDevice:(CBPeripheral*) device;
-(void) disconnectFromDevice:(CBPeripheral*) device;
-(NSNumber*) rssiForDevice:(CBPeripheral*) device;
-(NSDictionary*) metaDataForDevice:(CBPeripheral*) device;

-(void) sendData:(NSData*) dataToSend;

-(void) clearSearchList;

@end
