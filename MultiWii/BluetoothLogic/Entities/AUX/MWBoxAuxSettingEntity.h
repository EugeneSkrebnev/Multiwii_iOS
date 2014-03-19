//
//  MWBoxAuxSettingEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/4/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWSaveableSettingEntity.h"
@interface MWBoxAuxSettingEntity : MWSaveableSettingEntity
@property (nonatomic, assign) int bitMask;
@property (nonatomic, assign) int savedBitMask;
@property (nonatomic, assign) BOOL checked;

-(BOOL) isCheckedForAux:(int) auxIndex andPosition:(int) position; // 0 - low 1 - mid 2 - high
-(BOOL) isSavedForAux:(int) auxIndex andPosition:(int) position; // 0 - low 1 - mid 2 - high
-(void) setValue:(BOOL) value forAux:(int) auxIndex andPosition:(int) position; // 0 - low 1 - mid 2 - high
-(void) fillbitMaskFromLowBits:(int) lowbits andHighBits:(int) highBits;
@end
