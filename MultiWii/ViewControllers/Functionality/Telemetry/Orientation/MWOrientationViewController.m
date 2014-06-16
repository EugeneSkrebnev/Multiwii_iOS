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
    UIImageView* _separator;
    BOOL _isOnScreen;
}

-(void) sendOrientationRequest
{
    __weak typeof(self) weakSelf = self;
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_ATTITUDE andPayload:nil responseBlock:^(NSData *recieveData)
     {
         typeof(self) selfSt = weakSelf;
         if (!selfSt->_isOnScreen)
             return ;
         [selfSt updateOrientation];
         dispatch_async(dispatch_get_main_queue(), ^{
             [selfSt sendOrientationRequest];
         });
     }];

    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_ATTITUDE andPayload:nil responseBlock:^(NSData *recieveData)
     {
         typeof(self) selfSt = weakSelf;
         if (!selfSt->_isOnScreen)
             return ;
         [selfSt updateOrientation];
         dispatch_async(dispatch_get_main_queue(), ^{
             [selfSt sendOrientationRequest];
         });
     }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendOrientationRequest) object:nil];
    [self performSelector:@selector(sendOrientationRequest) withObject:nil afterDelay:5]; // bluetooth firmware lag or code bug protection
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isOnScreen = YES;
    [self sendOrientationRequest];
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isOnScreen = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendOrientationRequest) object:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" ORIENTATION ";
    self.orientationViewContainer.top = 0;
    int selfHeight = self.view.height - self.navigationController.navigationBar.height - (IS_IOS7 ? 0 : 20);
    self.orientationViewContainer.height = selfHeight / 2;
    self.compassViewContainer.height = self.orientationViewContainer.height;
    self.compassViewContainer.top = self.orientationViewContainer.height;
    if (IS_IPHONE_5)
        self.compassViewContainer.top -= 20;
    else
    {
        if (IS_IOS7)
            self.compassViewContainer.top -= 15;
        else
            self.compassViewContainer.top += 5;
    }
    _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
    _separator.width = self.view.width;
    _separator.top = self.compassViewContainer.top;
    if (!IS_IPHONE_5 && !IS_IOS7)
        _separator.top -= 7;
    [self.view addSubview:_separator];
}

static int requests = 0;

-(void) updateOrientation
{
    static NSDate* dat;
    NSLog(@"requests per sec: %@", @((double)requests / [[NSDate date] timeIntervalSinceDate:dat]));
    if (requests == 0) {
        dat = [NSDate date];
    }
    requests++;
    if (requests > 100)
        requests = 0;

    [self.orientationViewContainer setRoll  : TELEMETRY_MANAGER.attitude.rollAngle  ];
    [self.orientationViewContainer setPitch : TELEMETRY_MANAGER.attitude.pitchAngle ];
    [self.compassViewContainer setHeading   : TELEMETRY_MANAGER.attitude.heading    ];
}



@end
