//
//  MWTelemetryAttitude.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWTelemetryAttitude : NSObject

@property (nonatomic, assign) int rollAngle;
@property (nonatomic, assign) int pitchAngle;
@property (nonatomic, assign) int heading;

-(void) fillValuesFromPayload:(NSData*) payload;
@end
