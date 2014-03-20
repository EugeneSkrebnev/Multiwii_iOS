//
//  MWOrientationViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 11/12/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWOrientationViewController.h"
#import "MWCompassViewContainer.h"
#import "MWOrientationViewContainer.h"

@interface MWOrientationViewController ()
@property (weak, nonatomic) IBOutlet MWCompassViewContainer *compassViewContainer;
@property (weak, nonatomic) IBOutlet MWOrientationViewContainer *orientationViewContainer;

@end

@implementation MWOrientationViewController
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" ORIENTATION ";

    [self sendOrientationRequest];
    self.orientationViewContainer.top = 0;
    int selfHeight = self.view.height - self.navigationController.navigationBar.height - (IS_IOS7 ? 0 : 20);
    self.orientationViewContainer.height = selfHeight / 2;
    self.compassViewContainer.height = self.orientationViewContainer.height;
    self.compassViewContainer.top = self.orientationViewContainer.height;

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
