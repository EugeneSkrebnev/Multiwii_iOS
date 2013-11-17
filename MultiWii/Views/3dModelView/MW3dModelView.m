//
//  MW3dModelView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MW3dModelView.h"
#import <CoreMotion/CoreMotion.h>
#define CAMERA_HEIGHT 1

@implementation MW3dModelView
{
    NGLMesh* _mesh;
    NGLCamera* _camera;
    BOOL _wasInited;

    CMMotionManager* _cmm;
    float roll_a;
    float pitch_a;
    float yaw_a;
    
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
    
//    float R = CAMERA_HEIGHT;

//    pitch works
    pitch_a += 2;
//    _mesh.rotateZ = pitch_a;
    _mesh.rotateY = pitch_a;
//    _mesh.rotateZ = pitch_a / 2;
//    _camera.rotateX = -pitch_a / 2;
//    float pitch = nglDegreesToRadians(pitch_a);
//    [_camera translateToX:0
//                      toY:R*sinf(pitch)
//                      toZ:R*cosf(pitch)];
    [_camera lookAtObject:_mesh];
//    //    roll works
//    roll_a += 4;
//    _mesh.scaleY = fabsf(1*sinf(nglDegreesToRadians(roll_a)));
//    _mesh.scaleX = fabsf(1*sinf(nglDegreesToRadians(roll_a)));
//    _mesh.scaleZ = fabsf(1*sinf(nglDegreesToRadians(roll_a)));
//    _camera.rotateY = roll_a;
//    _camera.rotateX = -90;
//    float roll = nglDegreesToRadians(roll_a);
//    [_camera translateToX:R*sinf(roll)
//                      toY:R*cosf(roll)
//                      toZ:0];
    

////    pitch_a += 1;
//    roll_a += 1;
//
////    NGLmat4
//    float pitch = nglDegreesToRadians(pitch_a);
//    float roll = nglDegreesToRadians(roll_a);
//    
//    [_camera translateToX:R*sinf(roll)*sinf(pitch)
//                      toY:R*cosf(roll)*sinf(pitch)
//                      toZ:R*cosf(pitch)];
//    
//    [_camera lookAtPointX:0 toY:0 toZ:0];

    //    roll works




    

    
    
//    yaw_a += 1;
//    _camera.rotateY = yaw_a;
//    _camera.rotateZ = roll_a;
    
//    roll_a  += 1;
//    _camera.rotateX = -90;
//    _camera.rotateY += 1;
//    _camera.rotateX = roll_a;
//    [_camera lookAtPointX:0 toY:0 toZ:0];
//    float roll = nglDegreesToRadians(roll_a);
////
//    [_camera translateToX:R*sinf(roll)
//                      toY:R*cosf(roll)
//                      toZ:0];

//    [_camera translateToX:R*sinf(pitch)
//                      toY:R*cosf(pitch)*cosf(roll)
//                      toZ:R*cosf(pitch)*sinf(roll)];
//    
//    [_camera translateToX:R*sinf(roll)
//                      toY:R*cosf(roll)*cosf(pitch)
//                      toZ:R*cosf(roll)*sinf(pitch)];
//
    
//    NSLog(@"%f%f", R, roll);
    
//    NSLog(@"%f%f", R, roll);
    if (_mesh.parsing.isComplete)
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
        _wasInited = YES;
        roll_a = 0;
        pitch_a = 0;
        yaw_a = 0;
        
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
        
        NGLLight *light = [NGLLight defaultLight];
        light.attenuation = 200;


        [light translateToX:CAMERA_HEIGHT * 0.8 toY:CAMERA_HEIGHT * 0.8 toZ:0];
        light.type = NGLLightTypeSky;
        self.antialias = NGLAntialias4X;


        
        NSDictionary *settings = @{kNGLMeshKeyOriginal: kNGLMeshOriginalYes,
                                   kNGLMeshKeyCentralize: kNGLMeshCentralizeYes,
                                   kNGLMeshKeyNormalize: @(CAMERA_HEIGHT*0.7).stringValue
                                   };
        

        _mesh = [[NGLMesh alloc] initWithFile:@"quadr.obj" settings:settings delegate:self];

        _camera = [[NGLCamera alloc] initWithMeshes:_mesh, nil];

        [_camera translateToX:0
                          toY:CAMERA_HEIGHT
                          toZ:0];

        
        [[NGLDebug debugMonitor] startWithView:self];
    }
}
- (void) meshLoadingProgress:(NGLParsing)parsing
{
    NSLog(@"%f", parsing.progress);
}

- (void) meshLoadingDidFinish:(NGLParsing)parsing
{
    self.delegate = self;
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
