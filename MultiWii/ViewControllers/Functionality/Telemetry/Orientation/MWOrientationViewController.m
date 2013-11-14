//
//  MWOrientationViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/12/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWOrientationViewController.h"
#import "MWTelemetryManager.h"
@interface MWOrientationViewController ()

@end

@implementation MWOrientationViewController
{
    BOOL _isViewControllerActive;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" ORIENTATION ";
    [self sendRequest];
    _isViewControllerActive = NO;
}

-(void) sendRequest
{
    if ([MWBluetoothManager sharedInstance].isReadyToReadWrite)
    {
        [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_ATTITUDE andPayload:nil responseBlock:^(NSData *recieveData) {
            if (_isViewControllerActive)
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendRequest) object:nil];
                [self performSelector:@selector(sendRequest) withObject:nil afterDelay:0.0];
        //        self.model3dView.heading = [MWTelemetryManager sharedInstance].attitude.heading;
                self.model3dView.rollAngle = [MWTelemetryManager sharedInstance].attitude.rollAngle / 10;
                self.model3dView.pitchAngle = [MWTelemetryManager sharedInstance].attitude.pitchAngle / 10;
                NSLog(@"roll = %.0f ; pitch = %.0f", self.model3dView.rollAngle, self.model3dView.pitchAngle);
                NSLog(@"roll = %d ; pitch = %d", [MWTelemetryManager sharedInstance].attitude.rollAngle, [MWTelemetryManager sharedInstance].attitude.pitchAngle);
            }
        }];
        [self performSelector:@selector(sendRequest) withObject:nil afterDelay:0.4];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isViewControllerActive = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isViewControllerActive = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendRequest) object:nil];
}

-(void)dealloc
{
    NSLog(@"dealloc");
}
@end
