//
//  MWBluetoothManager.m
//  TestCoreBl
//
//  Created by Eugene Skrebnev on 6/16/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBluetoothManagerHM10.h"

#define fileService     0xFFE0
#define fileSub         0xFFE1

@implementation MWBluetoothManagerHM10
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
/*!
 *  @method notification:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for enabling and disabling notification services. It converts integers
 *  into CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the notfication is set.
 *
 */
-(void) notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}


#pragma mark - basic operations for SerialGATT service
-(void) write:(CBPeripheral *)peripheral data:(NSData *)data
{
    [self writeValue:fileService characteristicUUID:fileSub p:peripheral data:data];
    //[self writeValue:mainService characteristicUUID:mainSub3 p:peripheral data:data];
}



-(void) notify: (CBPeripheral *)peripheral on:(BOOL)on
{
    [self notification:fileService characteristicUUID:fileSub p:peripheral on:YES];
    
    //[peripheral setNotifyValue:on forCharacteristic:dataNotifyCharacteristic];
}

#pragma mark - Finding CBServices and CBCharacteristics

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)peripheral
{

    for (CBService *s in peripheral.services) {
        // compare s with UUID
        if ([[s.UUID data] isEqualToData:[UUID data]]) {
            return s;
        }
    }
    return  nil;
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID p:(CBPeripheral *)peripheral service:(CBService *)service
{
    for (CBCharacteristic *c in service.characteristics) {
        if ([[c.UUID data] isEqualToData:[UUID data]]) {
            return c;
        }
    }
    return nil;
}


#pragma mark - CBCentralManager Delegates

#pragma mark - CBPeripheral delegates

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    if (error) {
        if (self.didFailUpdateCharacteristic)
            self.didFailUpdateCharacteristic(error, self.currentConnectedDevice);
        return;
    }
    NSData *newData = characteristic.value;
    
    if (self.didRecieveData)
        self.didRecieveData(self.currentConnectedDevice, newData);
    NSString *value = [[NSString alloc] initWithData:newData encoding:NSASCIIStringEncoding];
    NSLog(@"val := %@", value);
//    [delegate serialGATTCharValueUpdated:@"FFE1" value:characteristic.value];
    
    
}

-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p{
    for (int i=0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        printf("Fetching characteristics for service with UUID : %s\r\n",[self CBUUIDToString:s.UUID]);
        [p discoverCharacteristics:nil forService:s];
    }
}



- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (!error) {
        printf("Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
        for(int i=0; i < service.characteristics.count; i++) {
            CBCharacteristic *c = [service.characteristics objectAtIndex:i];
            printf("Found characteristic %s\r\n",[ self CBUUIDToString:c.UUID]);
            CBService *s = [peripheral.services objectAtIndex:(peripheral.services.count - 1)];
            if([self compareCBUUID:service.UUID UUID2:s.UUID]) {
                printf("Finished discovering characteristics\n");
                //char data = 0x01;
                //NSData *d = [[NSData alloc] initWithBytes:&data length:1];
                //[self writeValue:mainService characteristicUUID:mainSub p:peripheral data:d];
                //[self writeValue:fileService characteristicUUID:fileSub p:peripheral data:d];
                [self notify:peripheral on:YES];
                
                
                //did discover all char.
                [_currentConnectedDevice readRSSI];
                _isReadyToReadWrite = YES;
                
                
                if (self.didDiscoverCharacteristics)
                    self.didDiscoverCharacteristics(self.currentConnectedDevice);
                

                
            }
        }
    }
    else {
        if (self.didFailToDiscoverCharacteristics)
            self.didFailToDiscoverCharacteristics(error, peripheral);

    }
}



- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        printf("Updated notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
        if (self.readyForReadWriteBlock)
            self.readyForReadWriteBlock();

    }
    else {
        printf("Error in setting notification state for characteristic with UUID %s on service with  UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:characteristic.UUID],[self CBUUIDToString:characteristic.service.UUID],[self UUIDToString:peripheral.UUID]);
        printf("Error code was %s\r\n",[[error description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
    }
}


-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}


-(int) compareCBUUIDToInt:(CBUUID *)UUID1 UUID2:(UInt16)UUID2 {
    char b1[16];
    [UUID1.data getBytes:b1];
    UInt16 b2 = [self swap:UUID2];
    if (memcmp(b1, (char *)&b2, 2) == 0) return 1;
    else return 0;
}

-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    char t[16];
    t[0] = ((UUID >> 8) & 0xff); t[1] = (UUID & 0xff);
    NSData *data = [[NSData alloc] initWithBytes:t length:16];
    return [CBUUID UUIDWithData:data];
}


/*
 *  @method findServiceFromUUID:
 *
 *  @param UUID CBUUID to find in service list
 *  @param p Peripheral to find service on
 *
 *  @return pointer to CBService if found, nil if not
 *
 *  @discussion findServiceFromUUID searches through the services list of a peripheral to find a
 *  service with a specific UUID
 *
 */
-(CBService *) findServiceFromUUIDEx:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    return nil; //Service not found on this peripheral
}

/*
 *  @method findCharacteristicFromUUID:
 *
 *  @param UUID CBUUID to find in Characteristic list of service
 *  @param service Pointer to CBService to search for charateristics on
 *
 *  @return pointer to CBCharacteristic if found, nil if not
 *
 *  @discussion findCharacteristicFromUUID searches through the characteristic list of a given service
 *  to find a characteristic with a specific UUID
 *
 */
-(CBCharacteristic *) findCharacteristicFromUUIDEx:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}


/*!
 *  @method writeValue:
 *
 *  @param serviceUUID Service UUID to write to (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to write to (e.g. 0x2401)
 *  @param data Data to write to peripheral
 *  @param p CBPeripheral to write to
 *
 *  @discussion Main routine for writeValue request, writes without feedback. It converts integer into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, value is written. If not nothing is done.
 *
 */

-(void) writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data {
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


/*!
 *  @method readValue:
 *
 *  @param serviceUUID Service UUID to read from (e.g. 0x2400)
 *  @param characteristicUUID Characteristic UUID to read from (e.g. 0x2401)
 *  @param p CBPeripheral to read from
 *
 *  @discussion Main routine for read value request. It converts integers into
 *  CBUUID's used by CoreBluetooth. It then searches through the peripherals services to find a
 *  suitable service, it then checks that there is a suitable characteristic on this service.
 *  If this is found, the read value is started. When value is read the didUpdateValueForCharacteristic
 *  routine is called.
 *
 *  @see didUpdateValueForCharacteristic
 */

-(void) readValue: (int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p {
    printf("In read Value");
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUIDEx:su p:p];
    if (!service) {
        printf("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUIDEx:cu service:service];
    if (!characteristic) {
        printf("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    [p readValueForCharacteristic:characteristic];
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
    
    id res = nil ;//_metaDataForDevices[@(device.hash)][RSSI_KEY];
    if (!res)
    {
        NSLog(@"No RSSI for device : %@", device);
    }
    return res;
}

-(NSDictionary*) metaDataForDevice:(CBPeripheral*) device
{
    id res = nil;// _metaDataForDevices[@(device.hash)][ADVDATA_KEY];
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
//    NSDictionary* dict = [NSDictionary dictionaryWithObjects:@[RSSI, advertisementData] forKeys:@[RSSI_KEY, ADVDATA_KEY]];
//    [_metaDataForDevices setObject:dict forKey:@(peripheral.hash)];
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
//    [self performSendData];
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

        [self getAllCharacteristicsFromKeyfob:peripheral];
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
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    unsigned char data[20];
//    
//    static unsigned char buf[512];
//    static int len = 0;
//    NSInteger data_len;
//    
//    if (!error)
//    {
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@RBL_CHAR_TX_UUID]])
//        {
//            data_len = characteristic.value.length;
//            [characteristic.value getBytes:data length:data_len];
//            
//            if (data_len == 20)
//            {
//                memcpy(&buf[len], data, 20);
//                len += data_len;
//                
//                if (len >= 64)
//                {
//                    NSData *newData = [NSData dataWithBytes:buf length:len];
//                    if (self.didRecieveData)
//                        self.didRecieveData(self.currentConnectedDevice, newData);
//
//                    len = 0;
//                }
//            }
//            else if (data_len < 20)
//            {
//                memcpy(&buf[len], data, data_len);
//                len += data_len;
//                
//                NSData *newData = [NSData dataWithBytes:buf length:len];
//                if (self.didRecieveData)
//                    self.didRecieveData(self.currentConnectedDevice, newData);
//
//                len = 0;
//            }
//        }
//    }
//    else
//    {
//        if (self.didFailUpdateCharacteristic)
//            self.didFailUpdateCharacteristic(error, self.currentConnectedDevice);
//    }
//}


//-(void) performSendData
//{
//    int onePortionLength = 20;
//    if (_sendBuffer.length > 0)
//    {
//        if (_sendBuffer.length > onePortionLength)
//        {
//            NSData* dataToSend = [_sendBuffer subdataWithRange:NSMakeRange(0, onePortionLength)];
//            [_sendBuffer replaceBytesInRange:NSMakeRange(0, onePortionLength) withBytes:NULL length:0];
//            [self write:dataToSend];
//            dispatch_async(dispatch_get_current_queue(), ^{
//                [self performSendData];
//            });
//
//        }
//        else
//        {
//            NSData* dataToSend = [NSData dataWithData:_sendBuffer];
//            
//            [self write:dataToSend];
//            [_sendBuffer replaceBytesInRange:NSMakeRange(0, _sendBuffer.length) withBytes:NULL length:0];
//            
//        }
//    }
//}

-(void) sendData:(NSData*) dataToSend
{
//    -(void) write:(CBPeripheral *)peripheral data:(NSData *)data
    [self write:self.currentConnectedDevice data:dataToSend];
    //check for sending on main only thread in future, or on separate thread
    //
//    BOOL needToSend = YES;
//    if (_sendBuffer.length > 0)
//        needToSend = NO;
//    
//    [_sendBuffer appendData:dataToSend];
//    
//    if (needToSend)
//        [self performSendData];
}

-(void) clearSearchList
{
    [_deviceList removeAllObjects];
}

@end
