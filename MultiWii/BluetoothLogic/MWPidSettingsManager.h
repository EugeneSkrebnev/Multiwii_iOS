//
//  MWPidSettingsManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFlyPidSettings.h"
#import "MWSensorsPidSettings.h"
#import "MWGPSPidSettings.h"
#import "MWRatesSettings.h"
@interface MWPidSettingsManager : NSObject

+ (MWPidSettingsManager *)sharedInstance;

@property (nonatomic, strong) MWFlyPidSettings* flyPid;
@property (nonatomic, strong) MWSensorsPidSettings* sensorsPid;
@property (nonatomic, strong) MWGPSPidSettings* gpsPid;

@property (nonatomic, strong) MWRatesSettings* RCRates;

-(void) fillPidFromPayload:(NSData*) payload;
-(NSData*) payloadFromPids;

-(void) fillRcTunningFromPayload:(NSData*) payload;
-(NSData*) payloadFromRcTunning;

-(void) savePids;
@end
