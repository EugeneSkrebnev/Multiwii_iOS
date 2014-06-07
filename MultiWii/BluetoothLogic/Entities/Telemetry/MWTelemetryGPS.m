//
//  MWTelemetryGPS.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/7/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryGPS.h"

@implementation MWTelemetryGPS

-(int) value16LowBits8:(int) lo andHigh8:(int) hi
{
    return hi << 8 | lo;
}
    
-(int) value32LowBits16:(int) lo andHigh16:(int) hi
{
    return hi << 16 | lo;
}

-(int) value32bits0:(int) bits0_7 bits1:(int) bits8_15 bits2:(int) bits16_23 bits3:(int) bits24_31
{
    return [self value32LowBits16:[self value16LowBits8:bits0_7 andHigh8:bits8_15]
                        andHigh16:[self value16LowBits8:bits16_23 andHigh8:bits24_31]];
}


-(void) fillGPSValuesFromPayload:(NSData*) payload
{
    unsigned char *bytes = (unsigned char*)payload.bytes;
    if (payload.length >= 7) //2bytes for 8 channels and message code bit
    {
        self.head = [self value16LowBits8:bytes[1] andHigh8:bytes[2]];
        self.fix = bytes[1];
        self.satelliteCount = bytes[2];        
        self.latitude = [self value32bits0:bytes[3] bits1:bytes[4] bits2:bytes[5] bits3:bytes[6]] / (double)10000000.;

        self.longitude = [self value32bits0:bytes[7] bits1:bytes[8] bits2:bytes[9] bits3:bytes[10]] / (double)10000000.;
        
        NSLog(@"lat = %f", self.latitude);
        NSLog(@"lon = %f", self.longitude);
        
    }

}
@end
