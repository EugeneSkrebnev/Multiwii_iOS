//
//  MWPidSettingsManager.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWBoxAuxSettingEntity.h"

@interface MWBoxSettingsManager : NSObject

+ (MWBoxSettingsManager *)sharedInstance;

- (MWBoxAuxSettingEntity*) boxEntityForIndex:(int) index;

-(void) fillBoxesNamesFromPayload:(NSData*) payload;
-(void) fillBoxesValuesFromPayload:(NSData*) payload;
-(NSData*) payloadFromBoxes;

@end