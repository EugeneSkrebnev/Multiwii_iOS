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
    
    self.pitchAngle  = (short)((short)bytes[2] << 8) | (short)bytes[1];
    self.rollAngle   = (short)((short)bytes[4] << 8) | (short)bytes[3];
    self.heading     = (short)((short)bytes[6] << 8) | (short)bytes[5];
    
    NSLog(@"roll = %d; pitch = %d; heading = %d", self.rollAngle, self.pitchAngle, self.heading);
}
@end
