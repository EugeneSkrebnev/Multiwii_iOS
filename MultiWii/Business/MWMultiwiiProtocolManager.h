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

@interface MWMultiwiiProtocolManager : NSObject
+ (MWMultiwiiProtocolManager *)sharedInstance;

-(void) didReceiveDataFromBluetooth:(NSData*) newData;
-(void) sendRequestWithId:(int) identifier andPayload:(NSData*) payload responseBlock:(MWMultiwiiProtocolManagerRecieveDataBlock) callBackBlock;
-(void) setDefaultHandler:(MWMultiwiiProtocolManagerRecieveDataBlock) handler forRequestWith:(int) identifier;
@end