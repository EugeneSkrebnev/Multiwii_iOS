//
//  MWRawImuEntity.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWRawImuEntity : NSObject

@property (nonatomic, assign) int roll;
@property (nonatomic, assign) int pitch;
@property (nonatomic, assign) int yaw;
@end
