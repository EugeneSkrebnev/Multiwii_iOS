//
//  MWSplashView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/1/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWSplashView : UIView
{
    UIImageView* _background;
}

-(void) makeFlyInAnimation;
-(void) makeFlyOutAnimation;

@property (nonatomic, readonly) NSTimeInterval animateInTime;
@property (nonatomic, readonly) NSTimeInterval animateOutTime;
@end
