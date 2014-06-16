//
//  MWBluetoothManager.m
//  TestCoreBl
//
//  Created by Eugene Skrebnev on 6/16/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBluetoothManager.h"

#define RBL_SERVICE_UUID                         "713D0000-503E-4C75-BA94-3148F18D941E"
#define RBL_CHAR_TX_UUID                         "713D0002-503E-4C75-BA94-3148F18D941E"
#define RBL_CHAR_RX_UUID                         "713D0003-503E-4C75-BA94-3148F18D941E"
#define RBL_CHAR_BAUD_UUID                       "713D0004-503E-4C75-BA94-3148F18D941E"
#define RBL_CHAR_NAME_UUID                       "713D0005-503E-4C75-BA94-3148F18D941E"

#define RBL_BLE_FRAMEWORK_VER                    0x0200

#define RSSI_KEY @"RSSIKEY"
#define ADVDATA_KEY @"ADVDATAKEY"

@implementation MWBluetoothManager
{
    NSMutableData* _sendBuffer;
}
#pragma mark - init section

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


-(void) read
{
    CBUUID *uuid_service = [CBUUID UUIDWithString:@RBL_SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@RBL_CHAR_TX_UUID];
    
    [self readValue:uuid_service characteristicUUID:uuid_char p:_currentConnectedDevice];
}

-(void) write:(NSData *)d
{
    CBUUID *uuid_service = [CBUUID UUIDWithString:@RBL_SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@RBL_CHAR_RX_UUID];
    
    [self writeValue:uuid_service characteristicUUID:uuid_char p:_currentConnectedDevice data:d];
}

-(void) enableReadNotification:(CBPeripheral *)p
{
    CBUUID *uuid_service = [CBUUID UUIDWithString:@RBL_SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@RBL_CHAR_TX_UUID];
    
    [self notification:uuid_service characteristicUUID:uuid_char p:p on:YES];
}

-(void) notification:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on
{
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service)
    {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic)
    {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristicUUID],
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    [p setNotifyValue:on forCharacteristic:characteristic];
}


-(NSString *) CBUUIDToString:(CBUUID *) cbuuid;
{
    NSData *data = cbuuid.data;
    
    if ([data length] == 2)
    {
        const unsigned char *tokenBytes = [data bytes];
        return [NSString stringWithFormat:@"%02x%02x", tokenBytes[0], tokenBytes[1]];
    }
    else if ([data length] == 16)
    {
        NSUUID* nsuuid = [[NSUUID alloc] initWithUUIDBytes:[data bytes]];
        return [nsuuid UUIDString];
    }
    
    return [cbuuid description];
}

-(void) readValue: (CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p
{
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service)
    {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic)
    {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristicUUID],
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    [p readValueForCharacteristic:characteristic];
}
-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data withResponse:(BOOL) response
{
    CBService *service = [self findServiceFromUUID:serviceUUID p:p];
    
    if (!service)
    {
        NSLog(@"Could not find service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristicUUID service:service];
    
    if (!characteristic)
    {
        NSLog(@"Could not find characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristicUUID],
              [self CBUUIDToString:serviceUUID],
              p.identifier.UUIDString);
        
        return;
    }
    
    [p writeValue:data
forCharacteristic:characteristic
             type:response ? CBCharacteristicWriteWithResponse : CBCharacteristicWriteWithoutResponse];


}

-(void) writeValue:(CBUUID *)serviceUUID characteristicUUID:(CBUUID *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data
{
    [self writeValue:serviceUUID
  characteristicUUID:characteristicUUID
                   p:p
                data:data
        withResponse:NO];
}

-(UInt16) swap:(UInt16)s
{
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}


- (BOOL) UUIDSAreEqual:(NSUUID *)UUID1 UUID2:(NSUUID *)UUID2
{
    if ([UUID1.UUIDString isEqualToString:UUID2.UUIDString])
        return TRUE;
    else
        return FALSE;
}


-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2
{
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    
    if (memcmp(b1, b2, UUID1.data.length) == 0)
        return 1;
    else
        return 0;
}

-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2
{
    char b1[16];
    
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    
    if (memcmp(b1, (char *)&b2, 2) == 0)
        return 1;
    else
        return 0;
}

-(UInt16) CBUUIDToInt:(CBUUID *) UUID
{
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

-(CBUUID *) IntToCBUUID:(UInt16)UUID
{
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p
{
    for(int i = 0; i < p.services.count; i++)
    {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID])
            return s;
    }
    
    return nil; //Service not found on this peripheral
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service
{
    for(int i=0; i < service.characteristics.count; i++)
    {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    
    return nil; //Characteristic not found on this service
}



- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error)
    {
        //        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
    }
    else
    {
        NSLog(@"Error in setting notification state for characteristic with UUID %@ on service with UUID %@ on peripheral with UUID %@",
              [self CBUUIDToString:characteristic.UUID],
              [self CBUUIDToString:characteristic.service.UUID],
              peripheral.identifier.UUIDString);
        
        NSLog(@"Error code was %s", [[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
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
        [_centralManager connectPeripheral:device options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @(YES)}];
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

#pragma mark - CBPeripheralDelegate
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

    if (!error)
    {
        if ([((CBService*)_currentConnectedDevice.services.lastObject).UUID isEqual:service.UUID])
        {
            //did discover all char.
            [_currentConnectedDevice readRSSI];
            _isReadyToReadWrite = YES;
            [self enableReadNotification:_currentConnectedDevice];
            
            if (self.didDiscoverCharacteristics)
                self.didDiscoverCharacteristics(self.currentConnectedDevice);
            
            if (self.readyForReadWriteBlock)
                self.readyForReadWriteBlock();

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setName:@"Peprprpr"];
            });

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
    unsigned char data[20];
    
    static unsigned char buf[512];
    static int len = 0;
    NSInteger data_len;
    
    if (!error)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@RBL_CHAR_TX_UUID]])
        {
            data_len = characteristic.value.length;
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
        }
    }
    else
    {
        if (self.didFailUpdateCharacteristic)
            self.didFailUpdateCharacteristic(error, self.currentConnectedDevice);
    }
}





-(void) performSendData
{
    int onePortionLength = 20;
    if (_sendBuffer.length > 0)
    {
        if (_sendBuffer.length > onePortionLength)
        {
            NSData* dataToSend = [_sendBuffer subdataWithRange:NSMakeRange(0, onePortionLength)];
            [_sendBuffer replaceBytesInRange:NSMakeRange(0, onePortionLength) withBytes:NULL length:0];
            [self write:dataToSend];
            dispatch_async(dispatch_get_current_queue(), ^{
                [self performSendData];
            });

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

-(void) setName:(NSString*) newName
{
    CBUUID *uuid_service = [CBUUID UUIDWithString:@RBL_SERVICE_UUID];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@RBL_CHAR_NAME_UUID];
    NSData* dataName = [newName dataUsingEncoding:(NSASCIIStringEncoding)];
    [self writeValue:uuid_service characteristicUUID:uuid_char p:_currentConnectedDevice data:dataName withResponse:YES];

}
@end
