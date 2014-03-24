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
}

-(void) sendOrientationRequest
{
    __weak typeof(self) weakSelf = self;
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_ATTITUDE andPayload:nil responseBlock:^(NSData *recieveData)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf sendOrientationRequest];
        });
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendOrientationRequest) object:nil];
    [self performSelector:@selector(sendOrientationRequest) withObject:nil afterDelay:.3]; // bluetooth firmware lag or code bug protection
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TELEMETRY_MANAGER.attitude addObserver:self forKeyPath:@"rollAngle" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    [TELEMETRY_MANAGER.attitude addObserver:self forKeyPath:@"pitchAngle" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    [TELEMETRY_MANAGER.attitude addObserver:self forKeyPath:@"heading" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    [self sendOrientationRequest];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [TELEMETRY_MANAGER.attitude removeObserver:self forKeyPath:@"rollAngle"];
    [TELEMETRY_MANAGER.attitude removeObserver:self forKeyPath:@"pitchAngle"];
    [TELEMETRY_MANAGER.attitude removeObserver:self forKeyPath:@"heading"];
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
    _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
    _separator.width = self.view.width;
    _separator.top = self.compassViewContainer.top;
    [self.view addSubview:_separator];
}


-(void) updateOrientation
{
    [self.orientationViewContainer setRoll  : TELEMETRY_MANAGER.attitude.rollAngle  ];
    [self.orientationViewContainer setPitch : TELEMETRY_MANAGER.attitude.pitchAngle ];
    [self.compassViewContainer setHeading   : TELEMETRY_MANAGER.attitude.heading    ];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateOrientation];
}


@end
