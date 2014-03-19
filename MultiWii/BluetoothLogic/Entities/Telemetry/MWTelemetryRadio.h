//
//  MWTelemetryRadio.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/19/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWRadioValueEntity.h"

@interface MWTelemetryRadio : NSObject

@property (nonatomic, readonly) MWRadioValueEntity* channel0;
@property (nonatomic, readonly) MWRadioValueEntity* channel1;
@property (nonatomic, readonly) MWRadioValueEntity* channel2;
@property (nonatomic, readonly) MWRadioValueEntity* channel3;
@property (nonatomic, readonly) MWRadioValueEntity* channel4;
@property (nonatomic, readonly) MWRadioValueEntity* channel5;
@property (nonatomic, readonly) MWRadioValueEntity* channel6;
@property (nonatomic, readonly) MWRadioValueEntity* channel7;

@property (nonatomic, readonly) NSArray* allChannels;

-(MWRadioValueEntity*) radioEntityForChannel:(int) channelIndex;
-(void) fillRadioValuesFromPayload:(NSData*) payload;
@end
