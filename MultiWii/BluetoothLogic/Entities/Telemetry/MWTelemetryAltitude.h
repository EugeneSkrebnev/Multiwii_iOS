//
//  MWTelemetryAltitude.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWTelemetryAltitude : NSObject

@property (nonatomic, assign) int variometr;
@property (nonatomic, assign) int altitude;

-(void) fillValuesFromPayload:(NSData*) payload;
@end
