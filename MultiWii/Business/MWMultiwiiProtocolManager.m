//
//  MWMultiwiiProtocolManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMultiwiiProtocolManager.h"

@implementation MWMultiwiiProtocolManager
{
    NSMutableData* _buffer;
    NSMutableDictionary* _callbacks;
    NSMutableDictionary* _defaultHandlers;
}

//+ (MWMultiwiiProtocolManager *)sharedInstance
//{
//    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
//        return [[self alloc] init];
//    });
//}


-(void) didReceiveDataFromBluetooth:(NSData*) newData
{
    if (newData)
        [_buffer appendData:newData];
    [self writeMessageDebug:newData];
    unsigned char *rawData = (unsigned char*)_buffer.bytes;
    //"$M>"
    if (_buffer.length > 4) //or maybe 5? $M>
    {
        int beginMessageIndex = -1;
        for (int i = 0; i < _buffer.length - 3; i++)
        {
            int startSymb1 = rawData[i]; 
            int startSymb2 = rawData[i + 1];
            int direction = rawData[i + 2];
            if ((startSymb1 == 36/* $ */) && (startSymb2 == 77/* M */) && (direction == 62/* > */))
            {
                beginMessageIndex = i;
                break; // use while but... anybody care?
            }
        }
        if (beginMessageIndex != -1)
        {
            int messageLength = rawData[beginMessageIndex + 3];
            [_buffer replaceBytesInRange:NSMakeRange(0, beginMessageIndex) withBytes:NULL length:0];
            [self writeMessageDebug:_buffer];

            int fullLength = 3/* "$M>" */ + 3 /* lenght crc messagetype*/ + messageLength;
            if (_buffer.length >= fullLength)
            {
                NSData* message = [_buffer subdataWithRange:NSMakeRange(0, fullLength)];
                [_buffer replaceBytesInRange:NSMakeRange(0, fullLength) withBytes:NULL length:0];
                dispatch_async(dispatch_get_current_queue(), ^{
                    [self processMessage:message];
                });

                if (_buffer.length > 0)
                    [self didReceiveDataFromBluetooth:[NSData data]];
            }
            else
            {
                NSLog(@"waiting for next portion of data");
            }
        }
        
    }
}

-(BOOL) checkMessageCRC:(NSData*) message
{
    unsigned char *rawData = (unsigned char*)message.bytes;
    int crc = rawData[3];
    for (int i = 4; i < message.length - 1; i++)
    {
        crc = crc ^ rawData[i];
    }
    int messageCrc = rawData[message.length];
    return crc == messageCrc;
}

-(void) writeMessageDebug:(NSData*) message
{
    return;
    NSLog(@"begin message");
    NSLog(@"message with length : %d", message.length);
    for (int i = 0; i < message.length; i++)
    {
        unsigned char *x = (unsigned char*)message.bytes;
        NSLog(@"%d - %d - %c", i, x[i], (char)x[i]);
    }
    NSLog(@"end message");
    
}

-(void) processMessage:(NSData*) message
{
    [self writeMessageDebug:message];
    
    unsigned char *bytes = (unsigned char*)message.bytes;
    


    int length = bytes[3];
    NSData* payload = [message subdataWithRange:NSMakeRange(4, length + 1)];
    int identifier = bytes[4];
    int crc = bytes[3 + length + 2]; // "$M>" - 3  id - 1 crc - 1
    int crcCheck = [self crcForPayload:[message subdataWithRange:NSMakeRange(3, length + 2)]];
    
    if (crcCheck == crc)
    {
        MWMultiwiiProtocolManagerRecieveDataBlock handler = [_defaultHandlers objectForKey:@(identifier)];
        MWMultiwiiProtocolManagerRecieveDataBlock callback = [_callbacks objectForKey:@(identifier)];
        
        if (handler)
        {
            handler(payload);
        }
        
        if (callback)
        {
            callback(payload);
            [_callbacks removeObjectForKey:@(identifier)];
        }
        if (!handler)
        {
            NSLog(@"NO HANDLER FOR :");
            [self writeMessageDebug:payload];
        }
    }
    else
    {
        NSLog(@"CRC ERROR");
        NSLog(@"CRC ERROR");
        [self writeMessageDebug:message];
        NSLog(@"CRC ERROR");
        NSLog(@"CRC ERROR");
    }
}

-(int) crcForPayload:(NSData*) payload
{
    if (payload.length == 0)
        return 0;
    unsigned char *x = (unsigned char*)payload.bytes;
    int result;// = (char)payload.length;
    result = x[0];
    
    for (int i = 1; i < payload.length; i++)
    {
        int symb = x[i];
        result = result ^ symb;
    }
    
    NSLog(@"crc = %d", result);
    return result;
}

-(int) crcForPayload:(NSData*) payload andId:(int) identifier
{
    unsigned char *x = (unsigned char*)payload.bytes;
    int result = (char)payload.length;
    result = result ^ identifier;
    
    for (int i = 0; i < payload.length; i++)
    {
        int symb = x[i];
        result = result ^ symb;
    }
    
    NSLog(@"%d", result);
    return result;
}

-(void) sendRequestWithId:(int) identifier andPayload:(NSData*) payload responseBlock:(MWMultiwiiProtocolManagerRecieveDataBlock) callBackBlock
{
    NSMutableData* messageToSend = [[NSMutableData alloc] init];
    unsigned char bytes[5];
    bytes[0] = 36; //begin
    bytes[1] = 77; //message
    bytes[2] = 60; //out
    bytes[3] = payload.length;
    bytes[4] = (char)identifier;

    
    [messageToSend appendData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
    
    if (payload.length > 0)
        [messageToSend appendData:payload];
    
    unsigned char crc[1];
    crc[0] = [self crcForPayload:payload andId:identifier];
//    if (payload.length > 0)
//        crc[0] = crc[0] ^ bytes[3] ^ bytes[4];
    [messageToSend appendData:[NSData dataWithBytes:crc length:sizeof(crc)]];
    
    [self writeMessageDebug:messageToSend];
    if (callBackBlock)
        [_callbacks setObject:callBackBlock forKey:@(identifier)];
    [[MWBluetoothManager sharedInstance] sendData:messageToSend];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _buffer = [[NSMutableData alloc] init];
        _callbacks = [[NSMutableDictionary alloc] init];
        _defaultHandlers = [[NSMutableDictionary alloc] init];
        [MWBluetoothManager sharedInstance].didRecieveData = ^(CBPeripheral* connectedDevice, NSData* incomingData)
        {
            [self didReceiveDataFromBluetooth:incomingData];
        };
    }
    return self;
}

-(void) setDefaultHandler:(MWMultiwiiProtocolManagerRecieveDataBlock) handler forRequestWith:(int) identifier
{
    [_defaultHandlers setObject:handler forKey:@(identifier)];
}

@end
