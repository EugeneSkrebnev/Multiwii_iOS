//
//  MWBluetoothManager.m
//  TestCoreBl
//
//  Created by Eugene Skrebnev on 6/16/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBluetoothManager.h"

#define RSSI_KEY @"RSSIKEY"
#define ADVDATA_KEY @"ADVDATAKEY"

// BLE Device Service
#define BLE_DEVICE_SERVICE_UUID                         "713D0000-503E-4C75-BA94-3148F18D941E"

#define BLE_DEVICE_VENDOR_NAME_UUID                     "713D0001-503E-4C75-BA94-3148F18D941E"

#define BLE_DEVICE_RX_UUID                              "713D0002-503E-4C75-BA94-3148F18D941E"
#define BLE_DEVICE_RX_READ_LEN                               20

#define BLE_DEVICE_TX_UUID                              "713D0003-503E-4C75-BA94-3148F18D941E"
#define BLE_DEVICE_TX_WRITE_LEN                              20

#define BLE_DEVICE_RESET_RX_UUID                        "713D0004-503E-4C75-BA94-3148F18D941E"

#define BLE_DEVICE_LIB_VERSION_UUID                     "713D0005-503E-4C75-BA94-3148F18D941E"

#define BLE_FRAMEWORK_VERSION                           0x0102


@implementation MWBluetoothManager
{
    NSMutableData* _sendBuffer;
}
#pragma mark - init section

+ (MWBluetoothManager *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _deviceList = [[NSMutableArray alloc] init];
        _metaDataForDevices = [[NSMutableDictionary alloc] init];
//        _vendor_name = {0};
        _libver = 0;
        _sendBuffer = [[NSMutableData alloc] init];
        
    }
    return self;
}

-(CBCentralManager *)centralManager
{
    if (!_centralManager)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return _centralManager;
}

#pragma mark - properties

-(NSArray *)deviceList
{
    return [_deviceList copy];
}

-(void)setRssiNotificationOn:(BOOL)rssiNotificationOn
{
    _rssiNotificationOn = rssiNotificationOn;
    if (_rssiNotificationOn)
        [_currentConnectedDevice readRSSI];
}
#pragma mark - methods copy/paste from BLE framework and refactor
-(CBService *) findServiceForUUID:(CBUUID *)UUID onDevice:(CBPeripheral *)device
{
    
    for (CBService* srv in device.services)
    {
        if ([srv.UUID isEqual:UUID]) //is equal works? test
            return srv;
    }
//    for(int i = 0; i < p.services.count; i++)
//    {
//        CBService *s = [p.services objectAtIndex:i];
//        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
//    }
//
    if (self.didFailToFindService)
        self.didFailToFindService([NSError errorWithDomain:@"com.multiwi" code:404 userInfo:nil], device);
    NSLog(@"Could not find service with UUID : %@ on device : %@", UUID.stringValue, [self metaDataForDevice:device]);
    return nil; //Service not found on this peripheral
}

-(CBCharacteristic *) findCharacteristicForUUID:(CBUUID *)UUID onService:(CBService*)service
{
    
    for (CBCharacteristic* charact in service.characteristics)
    {
        if ([UUID isEqual:charact.UUID])
            return charact;
    }
//    for(int i=0; i < service.characteristics.count; i++)
//    {
//        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
//        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
//    }

    NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@", UUID.stringValue, service.UUID.stringValue, [CBUUID UUIDWithCFUUID:_currentConnectedDevice.UUID].stringValue);
    
    return nil; //Characteristic not found on this service
}

-(void) writeValue:(NSData *)data
          onDevice:(CBPeripheral *)device
forServiceWithUUID:(CBUUID *)serviceUUID
characteristicUUID:(CBUUID *)characteristicUUID
{

    CBService *service = [self findServiceForUUID:serviceUUID onDevice:device];
    if (!service)
        return;
    
    CBCharacteristic *characteristic = [self findCharacteristicForUUID:characteristicUUID onService:service];
    if (!characteristic)
        return;
    
    [device writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//    [device writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

-(void) readValueFromDevice:(CBPeripheral *)device
                withService:(CBUUID *)serviceUUID
     withCharacteristicUUID:(CBUUID *)characteristicUUID
{
    CBService *service = [self findServiceForUUID:serviceUUID onDevice:device];
    if (!service)
        return;
    
    CBCharacteristic *characteristic = [self findCharacteristicForUUID:characteristicUUID onService:service];
    if (!characteristic)
        return;
    
    [device readValueForCharacteristic:characteristic];
}


-(void) notificationForService:(CBUUID *)serviceUUID
            characteristicUUID:(CBUUID *)characteristicUUID
                        device:(CBPeripheral *)device
                       enabled:(BOOL)on
{
    CBService *service = [self findServiceForUUID:serviceUUID onDevice:device];
    
    if (!service)
        return;
    
    CBCharacteristic *characteristic = [self findCharacteristicForUUID:characteristicUUID onService:service];
    if (!characteristic)
        return;
    
    [device setNotifyValue:on forCharacteristic:characteristic];
}

-(void) enableWrite
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@BLE_DEVICE_RESET_RX_UUID];
    unsigned char bytes[] = {0x01};
    NSData *d = [[NSData alloc] initWithBytes:bytes length:1];

    [self writeValue:d
            onDevice:_currentConnectedDevice
  forServiceWithUUID:serviceUUID
  characteristicUUID:characteristicUUID];
    
}

-(void) readLibVerFromPeripheral
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@BLE_DEVICE_LIB_VERSION_UUID];
    
    [self readValueFromDevice:_currentConnectedDevice
                  withService:serviceUUID
       withCharacteristicUUID:characteristicUUID];
}

-(void) readVendorNameFromPeripheral
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@BLE_DEVICE_VENDOR_NAME_UUID];
    
    [self readValueFromDevice:_currentConnectedDevice
                  withService:serviceUUID
       withCharacteristicUUID:characteristicUUID];
}

-(void) enableReadNotification:(CBPeripheral *)device
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@BLE_DEVICE_RX_UUID];
//    [self notificationForService:serviceUUID characteristicUUID:characteristicUUID device:device enabled:NO];
    [self notificationForService:serviceUUID characteristicUUID:characteristicUUID device:device enabled:YES];
}

#pragma mark - methods private

-(void) getAllCharacteristics
{
    if (_currentConnectedDevice)
    {
        for (CBService* service in _currentConnectedDevice.services)
        {
            [_currentConnectedDevice discoverCharacteristics:nil forService:service];
        }
    }
}

-(void) addDevice:(CBPeripheral*) device
{
    if ([_deviceList containsObject:device])
    {
        NSLog(@"already in list");
        return;
    }
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"peripheral = %@", device);

    [_deviceList addObject:device];
    if (self.didAddDeviceToListBlock)
        self.didAddDeviceToListBlock();
}

-(void) setActiveDevice:(CBPeripheral*) device
{
    _currentConnectedDevice = device;
    _currentConnectedDevice.delegate = self;
    [_currentConnectedDevice discoverServices:nil];
    self.rssiNotificationOn = NO;

}

#pragma mark - methods public

-(void) startScan
{
    if (self.isReadyToUse)
    {
        [_deviceList removeAllObjects];
        if (self.currentConnectedDevice)
            [_deviceList addObject:self.currentConnectedDevice];
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
        _isInScanMode = YES;
        if (self.didStartScan)
            self.didStartScan();
    }
}

-(void) stopScan
{
    if (_isInScanMode)
    {
        [_centralManager stopScan];
        _isInScanMode = NO;
        if (self.didStopScan)
            self.didStopScan();
    }
}

-(void) connectToDevice:(CBPeripheral*) device
{
    [self stopScan]; //work only with one at time.
    if (!device.isConnected)
        [_centralManager connectPeripheral:device options:nil];
    else
    {
        NSError* err;
        err = [NSError errorWithDomain:@"MW.already connected" code:1002 userInfo:nil];
        [self centralManager:_centralManager didFailToConnectPeripheral:device error:err];
    }
}

-(void) disconnectFromDevice:(CBPeripheral*) device
{
    if (device.isConnected)
        [_centralManager cancelPeripheralConnection:device];
}

-(NSNumber*) rssiForDevice:(CBPeripheral*) device
{
    if (device.isConnected)
        return device.RSSI;

    id res = _metaDataForDevices[@(device.hash)][RSSI_KEY];
    if (!res)
    {
        NSLog(@"No RSSI for device : %@", device);
    }
    return res;
}

-(NSDictionary*) metaDataForDevice:(CBPeripheral*) device
{
    id res = _metaDataForDevices[@(device.hash)][ADVDATA_KEY];
    if (!res)
    {
        NSLog(@"No info about device : %@", device);
    }
    return res;
}


#pragma mark - delegate calls

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        _isReadyToUse = YES;
        NSLog(@"BLE init success");        
    }
    else
    {
        _isReadyToUse = NO;
        NSLog(@"Something wrong");
        [_deviceList removeAllObjects];
    }
    if (self.didUpdateStateBlock)
        self.didUpdateStateBlock();
}



-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData            RSSI:(NSNumber *)RSSI
{
//    NSLog(@"data = %@", advertisementData);
//    NSLog(@"rssi = %@", RSSI);
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[RSSI, advertisementData] forKeys:@[RSSI_KEY, ADVDATA_KEY]];
    [_metaDataForDevices setObject:dict forKey:@(peripheral.hash)];
    [self addDevice:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (self.didConnectBlock)
        self.didConnectBlock(peripheral);
    
    [self setActiveDevice:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (self.didFailToConnectBlock)
        self.didFailToConnectBlock(error, peripheral);
}

#pragma mark - CBPeripheralDelegate
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    _currentConnectedDevice = nil;
    if (error)
    {
        if (self.didDisconnectWithErrorBlock)
            self.didDisconnectWithErrorBlock(error, peripheral);
    }
    else
    {
        if (self.didDisconnectBlock)
            self.didDisconnectBlock(peripheral);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
        NSLog(@"send error - %@", error);
    [self performSendData];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        if (self.didFailToDiscoverServices)
            self.didFailToDiscoverServices(error, peripheral);
    }
    else
    {
        if (self.didDiscoverServices)
            self.didDiscoverServices(self.currentConnectedDevice);
        [self getAllCharacteristics];
    }

}



-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
//    NSLog(@"%@", peripheral);
//
//    for (CBService* srv in peripheral.services)
//    {
//        NSLog(@"Service : %@", srv.UUID.toString);
//        for (CBCharacteristic* chr in srv.characteristics)
//        {
//            NSLog(@"Characteristic : %@", chr.UUID.toString);
//        }
//    }
    if (!error)
    {
        if ([((CBService*)_currentConnectedDevice.services.lastObject).UUID isEqual:service.UUID])
        {
            //did discover all char.
            [_currentConnectedDevice readRSSI];
            _isReadyToReadWrite = YES;
            
            [self enableReadNotification:_currentConnectedDevice];
            [self readLibVerFromPeripheral];
            [self readVendorNameFromPeripheral];
                        
            if (self.didDiscoverCharacteristics)
                self.didDiscoverCharacteristics(self.currentConnectedDevice);
            
            if (self.readyForReadWriteBlock)
                self.readyForReadWriteBlock();
            [self enableWrite];
        }
    }
    else
    {
        if (self.didFailToDiscoverCharacteristics)
            self.didFailToDiscoverCharacteristics(error, peripheral);
    }
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error)
    {
        if (self.didFailUpdateRssi)
            self.didFailUpdateRssi(error, peripheral);
    }
    else
    {
        if (self.didUpdateRssi)
        {
            self.didUpdateRssi(peripheral);
        }
    }
    if (self.rssiNotificationOn)
    {
        [_currentConnectedDevice readRSSI];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    unsigned char data[BLE_DEVICE_RX_READ_LEN];
    
    static unsigned char buf[512];
    static int len = 0;
    int data_len;
    
    if (!error)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@BLE_DEVICE_RX_UUID]])
        {
            data_len = characteristic.value.length;
            NSLog(@"%d bits of new data", data_len);
            [characteristic.value getBytes:data length:data_len];
            
            if (data_len == 20)
            {
                memcpy(&buf[len], data, 20);
                len += data_len;
                
                if (len >= 64)
                {
                    NSData *newData = [NSData dataWithBytes:buf length:len];
                    if (self.didRecieveData)
                        self.didRecieveData(self.currentConnectedDevice, newData);
                    len = 0;
                }
            }
            else if (data_len < 20)
            {
                memcpy(&buf[len], data, data_len);
                len += data_len;
                NSData *newData = [NSData dataWithBytes:buf length:len];
                if (self.didRecieveData)
                    self.didRecieveData(self.currentConnectedDevice, newData);

                len = 0;
            }
            
            [self enableWrite];
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@BLE_DEVICE_VENDOR_NAME_UUID]])
        {
            data_len = characteristic.value.length;
            [characteristic.value getBytes:_vendor_name length:data_len];
//            NSLog(@"Vendor: %s", _vendor_name);
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@BLE_DEVICE_LIB_VERSION_UUID]])
        {
            [characteristic.value getBytes:&_libver length:2];
//            NSLog(@"Lib. ver.: %X", _libver);
        }
    }
    else
    {
        if (self.didFailUpdateCharacteristic)
            self.didFailUpdateCharacteristic(error, self.currentConnectedDevice);
    }
}

-(void) write:(NSData *)data
{
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:@BLE_DEVICE_SERVICE_UUID];
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:@BLE_DEVICE_TX_UUID];
    
    [self writeValue:data
            onDevice:self.currentConnectedDevice
  forServiceWithUUID:serviceUUID
  characteristicUUID:characteristicUUID];    
}

-(void) performSendData
{
    NSLog(@"BUFFER L = %@", @(_sendBuffer.length));
    if (_sendBuffer.length > 0)
    {
        if (_sendBuffer.length > 20)
        {
            NSData* dataToSend = [_sendBuffer subdataWithRange:NSMakeRange(0, 20)];
            [_sendBuffer replaceBytesInRange:NSMakeRange(0, 20) withBytes:NULL length:0];
            [self write:dataToSend];
        }
        else
        {
            NSData* dataToSend = [NSData dataWithData:_sendBuffer];

            [self write:dataToSend];
            [_sendBuffer replaceBytesInRange:NSMakeRange(0, _sendBuffer.length) withBytes:NULL length:0];

        }
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performSendData) object:nil];
//        [self performSelector:@selector(performSendData) withObject:nil afterDelay:0.1];
    }
}

-(void) sendData:(NSData*) dataToSend
{
    //check for sending on main only thread in future, or on separate thread
    //
    BOOL needToSend = YES;
    if (_sendBuffer.length > 0)
        needToSend = NO;
    
    [_sendBuffer appendData:dataToSend];
    
    if (needToSend)
        [self performSendData];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(performSendData) object:nil];    
//    [self performSelector:@selector(performSendData) withObject:nil afterDelay:0.1];
//    [self write:dataToSend];
}

-(void) clearSearchList
{
    [_deviceList removeAllObjects];
}
@end
