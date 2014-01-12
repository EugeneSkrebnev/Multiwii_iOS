//
//  MW3dModelView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/13/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MW3dModelView.h"
#import <CoreMotion/CoreMotion.h>

#define CAMERA_HEIGHT 10

@implementation MW3dModelView
{
    NGLMesh* _mesh;
    NGLCamera* _camera;
    BOOL _wasInited;

    CMMotionManager* _cmm;
    float roll_a;
    float pitch_a;
    float yaw_a;
    float ang;
    float ang2;
    
    float ang3;
    float ang4;
    
    float ang5;
    float ang6;
    
    float roll__;
    float yaw__;
    float i;
    
    float rollDeg;
    float pitchDeg;
    float yawDeg;
}

void writeMatrix(NGLmat4 x)
{
    NSLog(@"Write Matrix:");

    for (int i = 0 ; i < 4; i++)
    {
        NSLog(@"%0.2f   %0.2f   %0.2f   %0.2f", x[i * 4 + 0], x[i * 4 + 1], x[i * 4 + 2], x[i * 4 + 3]);
    }
    
}

void applyMatrix(NGLmat4 input, NGLmat4 transform, NGLmat4 output)
{
    NGLmat4 inpInvers;
    nglMatrixInverse(input, inpInvers);
    nglMatrixMultiply(transform, inpInvers, output);
};

void applyMatrixInv(NGLmat4 input, NGLmat4 transform, NGLmat4 output)
{
    NGLmat4 inpInvers;
    nglMatrixInverse(input, inpInvers);
    nglMatrixMultiply(inpInvers, transform, output);
};


//-(void) cmm
//{
//
//    NSLog(@"roll = %f; pitch = %f; yaw = %f",
//        nglRadiansToDegrees(_cmm.deviceMotion.attitude.roll),
//        nglRadiansToDegrees(_cmm.deviceMotion.attitude.pitch),
//        nglRadiansToDegrees(_cmm.deviceMotion.attitude.yaw));
//
//}
//
//- (void) drawView
//{
//    if (!_mesh.parsing.isComplete)
//        return;
//    CMQuaternion quat = _cmm.deviceMotion.attitude.quaternion;
//    float yaw = (float)_cmm.deviceMotion.attitude.yaw;
//    
//    float pitch = atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z);
//    float roll  = atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z);
//    float ___myYaw = (2*(quat.x*quat.y + quat.w*quat.z));
//
//    float rollDeg = nglRadiansToDegrees(roll);
//    float pitchDeg = nglRadiansToDegrees(-pitch);
//    float yawDeg = nglRadiansToDegrees(___myYaw);
//
//    
//    float x =  CAMERA_HEIGHT*cosf(nglDegreesToRadians(rollDeg))*cosf(nglDegreesToRadians(pitchDeg));
//    float y = CAMERA_HEIGHT*cosf(nglDegreesToRadians(rollDeg)) * sinf(nglDegreesToRadians(pitchDeg));
//    float z = CAMERA_HEIGHT*sinf(nglDegreesToRadians(rollDeg));
//
//    [_camera translateToX:x toY:y toZ:z];
//    [_camera lookAtObject:_mesh];
//    
//    [_camera drawCamera];
//}

- (void) drawView
{
    if (!_mesh.parsing.isComplete)
        return;


    CMQuaternion quat = _cmm.deviceMotion.attitude.quaternion;
    float yaw = (float)_cmm.deviceMotion.attitude.yaw;

    float pitch = atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z);
    float roll  = atan2(2*(quat.y*quat.w - quat.x*quat.z), 1 - 2*quat.y*quat.y - 2*quat.z*quat.z);
    float ___myYaw = (2*(quat.x*quat.y + quat.w*quat.z));
    
    float rollDeg = nglRadiansToDegrees(roll);
    float pitchDeg = nglRadiansToDegrees(pitch);
    float yawDeg = nglRadiansToDegrees(___myYaw);
    
//    float rollDeg = nglRadiansToDegrees(_cmm.deviceMotion.attitude.roll);
//    float pitchDeg = nglRadiansToDegrees(_cmm.deviceMotion.attitude.pitch);
//    float yawDeg = nglRadiansToDegrees(_cmm.deviceMotion.attitude.yaw);
//    rollDeg = MIN(90, rollDeg);
//    rollDeg = MAX(-90, rollDeg);
    
//    rollDeg = (int)(rollDeg + 1) % 180;
//    pitchDeg = (int)(pitchDeg + 2) % 180;
//    yawDeg +=3;
    

    yaw__ =  ( roundf(-yawDeg * 10) / 10. );
    ang =   ( roundf((-pitchDeg +90)*10) / 10. );
    roll__ =  ( roundf(-rollDeg*10) / 10. );

    NSLog(@"rollDeg = %.1f; pitchDeg = %.1f; yawDeg = %.1f ", rollDeg, pitchDeg, yawDeg);
//    ang =  90;// + 70 * sinf(nglDegreesToRadians(i));//90;//0;//30 * sinf(nglDegreesToRadians(i));//90;// sinf(nglDegreesToRadians(i))*90; //180 * sinf(nglDegreesToRadians(i));//45;
    ang2 = 180 + ang;
    
//    roll__ = 0;// 70 * sinf(nglDegreesToRadians(i));
//    yaw__ = 20 * sinf(nglDegreesToRadians(i));
    ang3 = roll__;
//    ang3 = cosf(nglDegreesToRadians(ang)) * yaw__ + sinf(nglDegreesToRadians(ang)) * roll__;// 70 * sinf(nglDegreesToRadians(i));
    ang4 = ang3;//10;//10;

    ang5 = yaw__;
//    ang5 = sinf(nglDegreesToRadians(ang)) * yaw__ + cosf(nglDegreesToRadians(ang)) * roll__;;//0 ;20 * sinf(nglDegreesToRadians(i));;//0;//180 * sinf(nglDegreesToRadians(i)) ;
    ang6 = 0;

    NGLmat4 identity;
    nglMatrixIdentity(identity);
    
//    float xInverse[] =
//       {(float)-1., (float)0., (float)0., 0,
//        (float)0., (float)1., (float)0., (float)0.,
//        (float)0., (float)0., (float)1., (float)0.,
//        (float)0., (float)0., (float)0., (float)1.};

    float x =  self.cameraHeigth*sinf(nglDegreesToRadians(ang4+180))*sinf(nglDegreesToRadians(ang2+180));
    float y = self.cameraHeigth*sinf(nglDegreesToRadians(ang2)) * cosf(nglDegreesToRadians(ang4));
    float z = self.cameraHeigth*cosf(nglDegreesToRadians(ang2));

    float translationPitch[] =
    {
        1., 0., 0., 0,
        0., 1., 0., 0,
        0., 0., 1., 0,
//        0., cosf(nglDegreesToRadians(-ang)), -sinf(nglDegreesToRadians(-ang)), 0,
//        0., sinf(nglDegreesToRadians(-ang)), cosf(nglDegreesToRadians(-ang)), 0,
//        0., 0., 10., 1};
//        1, 3*fabsf(sinf(nglDegreesToRadians(ang2))), CAMERA_HEIGHT*fabsf(sinf(nglDegreesToRadians(ang))), (float)1.};
//        0, 0, 0, 1.
        x, y, z, 1.
    };
    
    float x2 = 0;
    float y2 = 0;//y;// CAMERA_HEIGHT* cosf(nglDegreesToRadians(ang4+180));;
    float z2 = 0;
    float translationRoll[] =
    {
        1., 0., 0., 0,
        0., 1., 0., 0,
        0., 0., 1., 0,
        //        0., cosf(nglDegreesToRadians(-ang)), -sinf(nglDegreesToRadians(-ang)), 0,
        //        0., sinf(nglDegreesToRadians(-ang)), cosf(nglDegreesToRadians(-ang)), 0,
        //        0., 0., 10., 1};
        //        1, 3*fabsf(sinf(nglDegreesToRadians(ang2))), CAMERA_HEIGHT*fabsf(sinf(nglDegreesToRadians(ang))), (float)1.};
        //        0, 0, 0, 1.
        x2, y2, z2, 1.
    };

    
    float rotateMatrixX[] =
    {
        1., 0., 0., 0,
        0., cosf(nglDegreesToRadians(-ang)), sinf(nglDegreesToRadians(-ang)), 0,
        0., -sinf(nglDegreesToRadians(-ang)), cosf(nglDegreesToRadians(-ang)), 0,
        0., 0., 0., 1
    };
    float rotateMatrixZ[] =
    {
        cosf(nglDegreesToRadians(-ang5)), 0., sinf(nglDegreesToRadians(-ang5)), 0,
        0., 1, 0, 0,
        -sinf(nglDegreesToRadians(-ang5)), 0, cosf(nglDegreesToRadians(-ang5)), 0,
        0., 0., 0., 1.
    };
    float rotateMatrixY[] =
    {
        cosf(nglDegreesToRadians(-ang3)),  sinf(nglDegreesToRadians(-ang3)), 0, 0,
        -sinf(nglDegreesToRadians(-ang3)), cosf(nglDegreesToRadians(-ang3)), 0, 0,
        0, 0, 1, 0,
        0., 0., 0., 1
    };
    
    NGLmat4 cameraMatrix;

    nglMatrixIdentity(cameraMatrix);

    applyMatrix(rotateMatrixX, cameraMatrix, cameraMatrix);
    applyMatrix(rotateMatrixY, cameraMatrix, cameraMatrix);

    applyMatrix(translationPitch, cameraMatrix , cameraMatrix);
//    applyMatrix(translationRoll, cameraMatrix , cameraMatrix);
    applyMatrix(rotateMatrixZ, cameraMatrix, cameraMatrix); // если после переноса то крутиться коптер как не крути, если до то камера
    
//    applyMatrix( rotateMatrixY, cameraMatrix, outMatrix);
//    applyMatrix( rotateMatrixZ, cameraMatrix, outMatrix);

//    _camera.rotateZ += 1;


////    applyMatrix(rotateMatrixX, initMatrx, cameraMatrix);
////    //    applyMatrix( rotateMatrixY, cameraMatrix, outMatrix);
////    //    applyMatrix( rotateMatrixZ, cameraMatrix, outMatrix);
////    applyMatrix(translationMatrix, cameraMatrix , cameraMatrixWithoutTranslate);
////    //    _camera.rotateZ += 1;

//    applyMatrix( rotateMatrixY, outMatrix, outMatrix2);
//    applyMatrix(cameraMatrixWithoutTranslate, xInverse, cameraMatrixInvX);
//    [_camera translateToX:x toY:y toZ:z];
    
    
    [_camera rebaseWithMatrix:cameraMatrix scale:1.0 compatibility:NGLRebaseQualcommAR];
    NGLmat4 light;
    nglMatrixInverse(cameraMatrix, light);
//    [[NGLLight defaultLight] rebaseWithMatrix:light scale:1.0 compatibility:NGLRebaseQualcommAR];


    x = CAMERA_HEIGHT*sinf(nglDegreesToRadians(ang4+180))*sinf(nglDegreesToRadians(ang2+180));;
    y = CAMERA_HEIGHT*sinf(nglDegreesToRadians(-ang2-90));
    z = CAMERA_HEIGHT*cosf(nglDegreesToRadians(-ang2-90));
    x =  self.cameraHeigth*sinf(nglDegreesToRadians(-ang4+180))*sinf(nglDegreesToRadians(-ang2 - 90 +180));
    y = self.cameraHeigth*sinf(nglDegreesToRadians(-ang2 - 90)) * cosf(nglDegreesToRadians(-ang4));
//    z = 0;
    z = self.cameraHeigth*cosf(nglDegreesToRadians(-ang2 - 90));
    
    [[NGLLight defaultLight] translateToX:x toY:y toZ:z];
    
    //    writeMatrix(cameraMatrixInvX);
//    nglMatrixMultiply(identityQualcomInverse, rotateMatrix, cameraMatrixWithoutTranslate);
//    nglMatrixMultiply(cameraMatrixWithoutTranslate, translationMatrix, cameraMatrix);
//
//    _camera.rotateX = -ang; //works
////    _camera.rotateY = ang2;
////    writeMatrix(cameraMatrix);
////    writeMatrix(cameraMatrixWithoutRotate);

//    [_camera rebaseWithMatrix:cameraMatrix scale:1.0 compatibility:NGLRebaseQualcommAR];
//    [_camera rebaseWithMatrix:cameraMatrixWithoutRotate scale:1.0 compatibility:NGLRebaseQualcommAR];

    _mesh.rotateX = -self.pitchAngle;
    _mesh.rotateY = -self.heading;
    _mesh.rotateZ = self.rollAngle + 180;
    
    if (_mesh.parsing.isComplete)
        [_camera drawCamera];
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;
        roll_a = 0;
        pitch_a = 0;
        yaw_a = 0;
        self.cameraHeigth = CAMERA_HEIGHT + 3;

        self.backgroundColor = [UIColor clearColor];
        nglGlobalColorFormat(NGLColorFormatRGBA);
        nglGlobalTextureOptimize(NGLTextureOptimizeNone);
        nglGlobalTextureQuality(NGLTextureQualityTrilinear);
        nglGlobalLightEffects(NGLLightEffectsON);
        nglGlobalFlush();
        
        NGLLight *light = [NGLLight defaultLight];
        light.attenuation = 200;


        [light translateToX:0 toY:self.cameraHeigth * 0.8 toZ:0];
        light.type = NGLLightTypeSky;
        self.antialias = NGLAntialias4X;


        
        NSDictionary *settings = @{//kNGLMeshKeyOriginal: kNGLMeshOriginalYes,
                                   kNGLMeshKeyCentralize: kNGLMeshCentralizeYes,
                                   kNGLMeshKeyNormalize: @(self.cameraHeigth*0.7).stringValue
                                   };
        

        _mesh = [[NGLMesh alloc] initWithFile:@"quadr.obj" settings:settings delegate:self];
//        _mesh.material = [NGLMaterial materialCooper];
        _camera = [[NGLCamera alloc] initWithMeshes:_mesh, nil];
        _mesh.rotateX = 180;

        
        [[NGLDebug debugMonitor] startWithView:self];
    }
}
- (void) meshLoadingProgress:(NGLParsing)parsing
{
    NSLog(@"%f", parsing.progress);
}

- (void) meshLoadingDidFinish:(NGLParsing)parsing
{
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.delegate = self;
    });
    _cmm = [[CMMotionManager alloc] init];
    [_cmm startDeviceMotionUpdates];
    
    delayInSeconds = 10;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self updateSmth];
    });
}

-(void) updateSmth
{
    [_cmm stopDeviceMotionUpdates];

    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_cmm startDeviceMotionUpdates];
        double delayInSeconds = 10;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self updateSmth];
        });

    });

    
    
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
