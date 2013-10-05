//
//  MWBoxAuxSettingEntity.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBoxAuxSettingEntity.h"

@implementation MWBoxAuxSettingEntity


-(BOOL) isCheckedForAux:(int) auxIndex andPosition:(int) position // 0 - low 1 - mid 2 - high
{
    return YES;
}
-(BOOL) isSavedForAux:(int) auxIndex andPosition:(int) position// 0 - low 1 - mid 2 - high
{
    return YES;
}

-(void) setValue:(BOOL) value forAux:(int) auxIndex andPosition:(int) position // 0 - low 1 - mid 2 - high
{
    
}

-(void) fillbitMaskFromLowBits:(int) lowbits andHighBits:(int) highBits
{
    self.bitMask = lowbits | highBits << 8;
}

@end
