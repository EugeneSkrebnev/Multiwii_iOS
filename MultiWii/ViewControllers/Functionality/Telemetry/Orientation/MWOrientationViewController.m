//
//  MWOrientationViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/12/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWOrientationViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface MWOrientationViewController ()

@end

@implementation MWOrientationViewController
{
//    CMMotionManager* _cmm;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" ORIENTATION ";
//    _cmm = [[CMMotionManager alloc] init];
//    [_cmm startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
//                              withHandler:^(CMDeviceMotion *motion, NSError *error) {
//
//                                  self.horizonView.pitch = motion.attitude.pitch * (180 / M_PI);
//                                  self.horizonView.roll = motion.attitude.roll * (180 / M_PI);
//                                  self.compassView.direction = motion.attitude.yaw* (180 / M_PI);
//                              }];
//    
    [self sendOrientationRequest];

}

-(void) sendOrientationRequest
{
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_ATTITUDE andPayload:nil responseBlock:^(NSData *recieveData) {
        double delayInSeconds = .3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self sendOrientationRequest];
        });
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendOrientationRequest) object:nil];
    [self performSelector:@selector(sendOrientationRequest) withObject:nil afterDelay:2.5];
}

@end
