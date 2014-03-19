//
//  MWSaveableSettingEntity.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/18/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWSaveableSettingEntity.h"
typedef MWSaveableSettingEntity* (^WeakObjectStoreBlock)(void);

@implementation MWSaveableSettingEntity

static NSMutableArray* _allObjects; //tricky

+(void)initialize
{
    [super initialize];
    _allObjects = [[NSMutableArray alloc] init];
}

+(void) addObjectToStore:(MWSaveableSettingEntity*) saveableEntity
{
    __weak MWSaveableSettingEntity* weakSettingEntity = saveableEntity;
    WeakObjectStoreBlock storeBlock = ^MWSaveableSettingEntity*(){
        return weakSettingEntity;
    };
    [_allObjects addObject:storeBlock];
}

+(void) removeObjectFromStore:(MWSaveableSettingEntity*) saveableEntity
{
    __block int indToDelete = -1;
    
    [_allObjects enumerateObjectsUsingBlock:^(WeakObjectStoreBlock storeBlock, NSUInteger idx, BOOL *stop)
    {
        MWSaveableSettingEntity* storedObj = storeBlock();
        if (storedObj)
        {
            if (storedObj == saveableEntity)
            {
                indToDelete = idx;
                *stop = YES;
            }
        }
        else
        {
            NSAssert(YES, @"Logic error in MWSaveableSettingEntity store");
        }
    }];
    if (indToDelete != -1)
        [_allObjects removeObjectAtIndex:indToDelete];
}

+(BOOL) haveUnsavedItems
{
    for (WeakObjectStoreBlock storeBlock in _allObjects)
    {
        MWSaveableSettingEntity* storedObj = storeBlock();
        if (storedObj)
        {
            if (!storedObj.saved)
                return YES;
        }
    }
    return NO;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        if ([self isMemberOfClass:[MWSaveableSettingEntity class]])
            NSAssert(YES, @"MWSaveableSettingEntity abstract entity");
        else
        {
            
        }
    }
    return self;
}

-(void)setSaved:(BOOL)saved
{
    NSAssert(YES, @"MWSaveableSettingEntity abstract entity");
}

-(BOOL)saved
{
    NSAssert(YES, @"MWSaveableSettingEntity abstract entity");
    return NO;
}

-(void)dealloc
{
    [MWSaveableSettingEntity removeObjectFromStore:self];
}

@end
