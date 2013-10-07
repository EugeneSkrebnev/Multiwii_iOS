//
//  MWMultiwiiProtocolManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MWMultiwiiProtocolManagerRecieveDataBlock)(NSData* recieveData);

#define MWI_BLE_MESSAGE_IDENT 100
#define MWI_BLE_MESSAGE_GET_PID 112
#define MWI_BLE_MESSAGE_SET_PID 202

#define MWI_BLE_MESSAGE_GET_BOX_NAMES 116
#define MWI_BLE_MESSAGE_GET_BOXES 113
#define MWI_BLE_MESSAGE_SET_BOXES 203

#define MWI_BLE_MESSAGE_GET_RC_TUNNING 111
#define MWI_BLE_MESSAGE_SET_RC_TUNNING 204

#define MWI_BLE_MESSAGE_ACC_CALIBRATION 205
#define MWI_BLE_MESSAGE_MAG_CALIBRATION 206

@interface MWMultiwiiProtocolManager : NSObject
+ (MWMultiwiiProtocolManager *)sharedInstance;

-(void) didReceiveDataFromBluetooth:(NSData*) newData;
-(void) sendRequestWithId:(int) identifier andPayload:(NSData*) payload responseBlock:(MWMultiwiiProtocolManagerRecieveDataBlock) callBackBlock;
-(void) setDefaultHandler:(MWMultiwiiProtocolManagerRecieveDataBlock) handler forRequestWith:(int) identifier;
@end
