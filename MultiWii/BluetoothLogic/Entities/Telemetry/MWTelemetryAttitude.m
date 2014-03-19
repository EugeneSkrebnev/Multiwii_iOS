//
//  MWTelemetryAttitude.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryAttitude.h"

@implementation MWTelemetryAttitude

-(void) fillValuesFromPayload:(NSData*) payload
{
    unsigned char *bytes = (unsigned char*)payload.bytes;
    self.rollAngle  = ((short)bytes[2] < 8) | (short)bytes[1];
    self.pitchAngle = ((short)bytes[4] < 8) | (short)bytes[3];
    self.heading    = ((short)bytes[6] < 8) | (short)bytes[5];    
}
@end
