//
//  MWTelemetryGPS.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/7/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWTelemetryGPS : NSObject
@property (nonatomic, assign) int head; //16 bit
@property (nonatomic, assign) int fix; //8 bit
@property (nonatomic, assign) int satelliteCount; //8 bit
@property (nonatomic, assign) double latitude; //32 bit
@property (nonatomic, assign) double longitude;//32 bit
@property (nonatomic, assign) int altitude; //16 bit
@property (nonatomic, assign) int speed;//16 bit
@property (nonatomic, assign) int groundCourse;//16 bit


-(void) fillGPSValuesFromPayload:(NSData*) payload;
@end
