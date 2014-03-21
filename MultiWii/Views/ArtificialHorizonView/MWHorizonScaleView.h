//
//  MWHorizonScaleView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/13/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWHorizonScaleView : UIView
@property (nonatomic, assign) int scaleStep;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int minValue;
@property (nonatomic, assign) int value;

-(CGAffineTransform) transformForPitch:(int) value;
-(CGAffineTransform) transformForPitchInverted:(int) value;
@end
