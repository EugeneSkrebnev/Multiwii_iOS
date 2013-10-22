//
//  MWRadarActivityIndicator.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWRadarActivityIndicator : UIView
@property (nonatomic, assign) NSTimeInterval spinSpeed;

-(void) startSpin;
-(void) stopSpin;

@end
