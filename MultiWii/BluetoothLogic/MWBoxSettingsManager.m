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
    //payload[0] == code 116 MWI_BLE_MESSAGE_GET_BOX_NAMES
    payload = [payload subdataWithRange:NSMakeRange(1, payload.length - 1)];
    NSString* boxes = [NSString stringWithCString:payload.bytes encoding:NSUTF8StringEncoding];

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
    
    while (_boxEntities.count > boxesNames.count)
        [_boxEntities removeObject:_boxEntities.lastObject];

}


-(void) fillBoxesValuesFromPayload:(NSData*) payload
{
    //payload[0] == code 113 MWI_BLE_MESSAGE_GET_BOXES
    payload = [payload subdataWithRange:NSMakeRange(1, payload.length - 1)];
    unsigned char *bytes = (unsigned char*)payload.bytes;
    if (payload.length >= _boxEntities.count * 2)
    {
        for (int i = 0; i < _boxEntities.count; i++)
        {
            int lowBits  = bytes[i * 2];
            int highBits = bytes[i * 2 + 1];
            MWBoxAuxSettingEntity* boxItem = _boxEntities[i];
            [boxItem fillbitMaskFromLowBits:lowBits andHighBits:highBits];
        }
    }
}


-(NSData*) payloadFromBoxes
{
    return [NSData data];
}

@end
