//
//  MWSignalIndicatorView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/31/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWSignalIndicatorView : UIView

@property (nonatomic, assign) float value; // 0..1
-(void)setValue:(float)value animated:(BOOL)animated;
-(void)setValue:(float)value animated:(BOOL)animated duration:(NSTimeInterval) duration;
@end
