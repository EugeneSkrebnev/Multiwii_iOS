//
//  MW3dModelView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MW3dModelView.h"
#import <CoreMotion/CoreMotion.h>
#define CAMERA_HEIGHT 2

@implementation MW3dModelView
{
    NGLMesh* _mesh;
    NGLCamera* _camera;
    BOOL _wasInited;
    int _startRollAngle;
    int _startPitchAngle;
    int _startHeading;
    CMMotionManager* _cmm;
    float ang;
    
    float rx;
    float ry;
    float rz;
}
//    [_mesh rotateToX:-(self.pitchAngle + _startPitchAngle) toY:-(self.heading + _startHeading) toZ:-(self.rollAngle + _startRollAngle)];
//    self.heading = (self.heading + 1) % 360;
//    self.pitchAngle = (self.pitchAngle + 1) % 360;
//    self.rollAngle = (self.rollAngle + 1) % 360;
//    NSLog(@"pitch = %d; roll = %d; heading = %d;", self.pitchAngle, self.rollAngle, self.heading);
//    [_mesh rotateRelativeToX:self.pitchAngle + _startPitchAngle toY:self.heading + _startHeading toZ:self.rollAngle + _startRollAngle];
//    _camera.rotateY += 1;
//    _camera.rotateZ += 1;
//    _camera.rotateX += 1;
#define radiansToDegrees(x) (180/M_PI)*x
- (void) drawView
{
//	_mesh.rotateY = 1;
//	_mesh.rotateX += 1;
//	_mesh.rotateZ += 1;
//    CMQuaternion quat = _cmm.deviceMotion.attitude.quaternion;
//    float yaw = (float)_cmm.deviceMotion.attitude.yaw;
//
//    float pitch = atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z);
//    float roll  = atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z);
    

    

//    float rollDeg = radiansToDegrees(roll);
//    float pitchDeg = radiansToDegrees(pitch);
//    float yawDeg = radiansToDegrees(yaw);
    
    
//    float R = CAMERA_HEIGHT;
    ang = ang + 1;
//    _camera.rotateX = ang;
//    [_camera translateToX:R*cosf(nglDegreesToRadians(ang)) toY:R*sinf(nglDegreesToRadians(ang)) toZ:0];
//    rx += 0.1;
//    ry += 0.2;
//    rz += 0.3;
//    float mtrx[] = {R*sinf(nglDegreesToRadians(ang)), R*cosf(nglDegreesToRadians(ang)), 0, 0, 0, 0, 0.001, 0.001, 0.001, 1};
//    float mtrx[] = {rx, ry, rz, 0, 0, 0, 0.01, 0.01, 0.01};
//    NGLmat4 mtrx = {0, 0, 0, 0, 0, 0, 1, 1, 1};
//
//    NGLQuaternion *quat = [[NGLQuaternion alloc] init];
//    quat ro
//    [_camera rebaseWithMatrix:*quat.matrix scale:800 compatibility:NGLRebaseQualcommAR];
//    if (ang > 400)
//        [_camera lookAtPointX:0 toY:0 toZ:0];
//    NSLog(@"x = %f y = %f z = %f", _camera.rotateX, _camera.rotateY, _camera.rotateZ);
//
//    NSLog(@"roll : %f; pitch : %f; yaw : %f", rollDeg, pitchDeg, yawDeg);
//    roll = 0;

//    _camera.rotateX += 0.1;
//    [_camera rebaseWithMatrix:1 scale:1 compatibility:1];
//    [_camera translateToX:R*cosf(nglDegreesToRadians(ang)) toY:0 toZ:R*sinf(nglDegreesToRadians(ang))];
//    NSLog(@"parcing = %f", _mesh.parsing.progress);
//    [_camera translateToX:R*cosf(pitch)*sinf(roll) toY:R*cosf(pitch)*cosf(roll) toZ:R*sinf(pitch)];
    
//    float matrix[] = {R*cosf(nglDegreesToRadians(ang)), 0, R*sinf(nglDegreesToRadians(ang)),1,1,1,20,20,20};
//    [_camera rebaseWithMatrix:matrix scale:1 compatibility:NGLRebaseNone];
//    [_camera lookAtPointX:0 toY:0 toZ:0];
//    _camera.matrix
//    [_camera lookAtObject:_mesh];x
//    [_camera translateToX:R*cosf(nglDegreesToRadians(ang)) toY:R*sinf(nglDegreesToRadians(ang)) toZ:0];
    
//    [_camera lookAtPointX:0 toY:0 toZ:0];
//    if ((int)ang % 180 == 1)
//        _mesh.rotateZ -= 1;
//    _camera.rotateX += 1;
//    NGLQuaternion
//    [_camera translateToX:cosf(nglDegreesToRadians(myYaw))*CAMERA_HEIGHT toY:0 toZ:sinf(nglDegreesToRadians(myYaw))*CAMERA_HEIGHT];
//    [_camera translateRelativeToX:0 toY:cosf(nglDegreesToRadians(myRoll))*CAMERA_HEIGHT toZ:0];
//    [self cmm];
	[_camera drawCamera];
}
//-(void) cmm
//{
//
//    NSLog(@"roll = %f; pitch = %f; yaw = %f",
//        nglRadiansToDegrees(_cmm.deviceMotion.attitude.roll),
//        nglRadiansToDegrees(_cmm.deviceMotion.attitude.pitch),
//        nglRadiansToDegrees(_cmm.deviceMotion.attitude.yaw));
//
//}
-(void) makeInit
{
    if (!_wasInited)
    {
        ang = 0;
//        _cmm = [[CMMotionManager alloc] init];
//        [_cmm startDeviceMotionUpdates];
//        _startPitchAngle = 90;//90;
//        _startRollAngle = -40;
//        _startHeading = 180;
        self.backgroundColor = [UIColor clearColor];
        nglGlobalColorFormat(NGLColorFormatRGBA);
        nglGlobalTextureOptimize(NGLTextureOptimizeNone);
        nglGlobalTextureQuality(NGLTextureQualityTrilinear);
        nglGlobalLightEffects(NGLLightEffectsON);
        nglGlobalFlush();
        
//        NGLLight *light = [NGLLight defaultLight];
//        light.attenuation = 20;


//        [light translateToX:0 toY:CAMERA_HEIGHT * 0.6 toZ:0];
//        light.type = NGLLightTypeSky;
        self.antialias = NGLAntialias4X;
        _wasInited = YES;
        NSDictionary *settings;
        
        settings = @{/*kNGLMeshKeyOriginal: kNGLMeshOriginalYes,*/
                     kNGLMeshKeyCentralize: kNGLMeshCentralizeYes,
                     kNGLMeshKeyNormalize: @"2"
                     };
        _mesh = [[NGLMesh alloc] initWithFile:@"quadr.obj" settings:settings delegate:nil];
//        self.
        _camera = [[NGLCamera alloc] initWithMeshes:_mesh, nil];
        
        [_camera autoAdjustAspectRatio:YES animated:YES];


//        NSLog(@"x = %f y = %f z = %f", _camera.rotateX, _camera.rotateY, _camera.rotateZ);
        [_camera translateToX:0
                          toY:0.4
                          toZ:CAMERA_HEIGHT];
//        [_camera lookAtPointX:0 toY:0 toZ:0 ];
//        _camera.lookAtTarget = _mesh;


        self.delegate = self;

        
        
        [[NGLDebug debugMonitor] startWithView:self];
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

@end
