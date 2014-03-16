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
    CMMotionManager* _cmm;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" ORIENTATION ";
    _cmm = [[CMMotionManager alloc] init];
    [_cmm startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                              withHandler:^(CMDeviceMotion *motion, NSError *error) {

                                  self.horizonView.pitch = motion.attitude.pitch * (180 / M_PI);
                                  self.horizonView.roll = motion.attitude.roll * (180 / M_PI);
                                  self.compassView.direction = motion.attitude.yaw* (180 / M_PI);
                              }];

}

-(void) sendRequest
{
    NSLog(@"enter send request");
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_ATTITUDE andPayload:nil responseBlock:^(NSData *recieveData) {
    NSLog(@"enter request answer");    
        unsigned char *bytes = (unsigned char*)recieveData.bytes;
        short val1 = ((short)bytes[2] << 8) | (short)bytes[1];
        NSLog(@"v1 = %@",@(val1));
        short val2 = ((short)bytes[4] << 8) | (short)bytes[3];
        NSLog(@"v2 = %@",@(val2));
        short val3 = ((short)bytes[6] << 8) | (short)bytes[5];
        NSLog(@"v3 = %@",@(val3));

        self.statusLabel.text = [NSString stringWithFormat:@"v1 = %@, v2 = %@, v3 = %@", @(val1), @(val2), @(val3)];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.width = 320;
        self.statusLabel.left = 0;
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"call send request");
            [self sendRequest];

        });
    }];
}
@end
