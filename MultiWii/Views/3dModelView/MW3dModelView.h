//
//  MW3dModelView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <NinevehGL/NinevehGL.h>

@interface MW3dModelView : NGLView<NGLViewDelegate>

@property (nonatomic, assign) float rollAngle;
@property (nonatomic, assign) float pitchAngle;
@property (nonatomic, assign) float heading;


@property (nonatomic, assign) float deviceRollAngle;
@property (nonatomic, assign) float devicePitchAngle;
@property (nonatomic, assign) float deviceHeading;

@end
