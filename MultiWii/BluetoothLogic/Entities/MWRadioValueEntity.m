//
//  MWRadioValueEntity.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/19/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWRadioValueEntity.h"

@implementation MWRadioValueEntity

-(void) setValueLowBits:(int) lo andHigh:(int) hi
{
    self.value = hi << 8 | lo;
}

@end
