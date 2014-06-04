//
//  MWTelemetryRadio.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/19/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWTelemetryRadio.h"

@implementation MWTelemetryRadio


- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray* channelsNames = @[@"THROTTLE", @"PITCH", @"ROLL", @"YAW",
                                   @"AUX 1", @"AUX 2", @"AUX 3", @"AUX 4"];
        _allChannels = ({
            NSMutableArray* tmpChannelArr = [NSMutableArray array];
            for (int i = 0; i < 8; i++)
            {
                MWRadioValueEntity* nextEnt = [[MWRadioValueEntity alloc] init];
                nextEnt.name = channelsNames[i];
                [tmpChannelArr addObject:nextEnt];
                [self setValue:nextEnt forKey:[NSString stringWithFormat:@"channel%d", i]];
            }
            [tmpChannelArr copy];
        });
        
    }
    return self;
}

-(MWRadioValueEntity*) radioEntityForChannel:(int) channelIndex
{
    return self.allChannels[channelIndex];
}

-(void) fillRadioValuesFromPayload:(NSData*) payload
{
    unsigned char *bytes = (unsigned char*)payload.bytes;
    if (payload.length >= 17) //2bytes for 8 channels and message code bit
    {
        for (int i = 0; i < 8; i++)
        {
            MWRadioValueEntity* currentEnt = self.allChannels[i];
            [currentEnt setValueLowBits:bytes[1 + i * 2]
                                andHigh:bytes[1 + i * 2 + 1]];
            
        }
    }
}

@end
