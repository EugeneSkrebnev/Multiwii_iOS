//
//  MWPidSettingsManager.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBoxSettingsManager.h"

@implementation MWBoxSettingsManager
{
    NSMutableArray* _boxEntities;
}

#pragma mark - init section

+ (MWBoxSettingsManager *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _boxEntities = [[NSMutableArray alloc] init];
    }
    return self;
}

- (MWBoxAuxSettingEntity*) boxEntityForIndex:(int) index
{
    return _boxEntities[index];
}

-(void) fillBoxesNamesFromPayload:(NSData*) payload
{
    NSLog(@"%@", payload);
    payload = [payload subdataWithRange:NSMakeRange(1, payload.length - 1)];
    NSString* boxes = [NSString stringWithCString:payload.bytes encoding:NSUTF8StringEncoding];
    NSLog(@"%@", boxes);
    NSArray* boxesNames = [boxes componentsSeparatedByString:@";"];
    for (int i = 0; i < boxesNames.count; i++)
    {
        if (_boxEntities.count <= i)
        {
            [_boxEntities addObject:[[MWBoxAuxSettingEntity alloc] init]];
        }
        MWBoxAuxSettingEntity* boxItem = _boxEntities[i];
        boxItem.name = boxesNames[i];
    }
}


-(void) fillBoxesValuesFromPayload:(NSData*) payload
{
    
}


-(NSData*) payloadFromBoxes
{
    return [NSData data];
}

@end
