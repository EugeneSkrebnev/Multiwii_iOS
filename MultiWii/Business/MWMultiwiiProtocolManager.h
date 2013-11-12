//
//  MWMultiwiiProtocolManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MWMultiwiiProtocolManagerRecieveDataBlock)(NSData* recieveData);

#define MWI_BLE_MESSAGE_IDENT 100 //out message         multitype + multiwii version + protocol version + capability variable
#define MWI_BLE_MESSAGE_GET_PID 112 //out message         P I D coeff (9 are used currently)
#define MWI_BLE_MESSAGE_SET_PID 202 //in message          P I D coeff (9 are used currently)

#define MWI_BLE_MESSAGE_GET_BOX_NAMES 116 //out message         the aux switch names
#define MWI_BLE_MESSAGE_GET_BOXES 113 //out message         BOX setup (number is dependant of your setup)
#define MWI_BLE_MESSAGE_SET_BOXES 203 //in message          BOX setup (number is dependant of your setup)

#define MWI_BLE_MESSAGE_GET_RC_TUNNING 111 //out message         rc rate, rc expo, rollpitch rate, yaw rate, dyn throttle PID
#define MWI_BLE_MESSAGE_SET_RC_TUNNING 204 //in message          rc rate, rc expo, rollpitch rate, yaw rate, dyn throttle PID

#define MWI_BLE_MESSAGE_ACC_CALIBRATION 205 //in message          no param
#define MWI_BLE_MESSAGE_MAG_CALIBRATION 206 //in message          no param

#define MWI_BLE_MESSAGE_SET_SAVE_EPROM 250 //in message          no param

//telemetry
#define MWI_BLE_MESSAGE_GET_RAW_IMU 102   //out message         9 DOF
#define MWI_BLE_MESSAGE_GET_ATTITUDE 108   //out message         2 angles 1 heading

@interface MWMultiwiiProtocolManager : NSObject
//+ (MWMultiwiiProtocolManager *)sharedInstance;

-(void) didReceiveDataFromBluetooth:(NSData*) newData;
-(void) sendRequestWithId:(int) identifier andPayload:(NSData*) payload responseBlock:(MWMultiwiiProtocolManagerRecieveDataBlock) callBackBlock;
-(void) setDefaultHandler:(MWMultiwiiProtocolManagerRecieveDataBlock) handler forRequestWith:(int) identifier;
@end
