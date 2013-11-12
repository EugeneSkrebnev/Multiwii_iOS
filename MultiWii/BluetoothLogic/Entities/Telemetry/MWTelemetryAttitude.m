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
    short val1 = ((short)bytes[2] < 8) | (short)bytes[1];
    NSLog(@"v1 = %@",@(val1));
    short val2 = ((short)bytes[4] < 8) | (short)bytes[3];
    NSLog(@"v2 = %@",@(val2));
    short val3 = ((short)bytes[6] < 8) | (short)bytes[5];
    NSLog(@"v3 = %@",@(val3));
    
}
@end
