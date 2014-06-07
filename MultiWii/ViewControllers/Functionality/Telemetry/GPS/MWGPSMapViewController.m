//
//  MWGPSMapViewController
//  MultiWii
//
//  Created by Eugene Skrebnev on 07/06/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWGPSMapViewController.h"
#import <MapKit/MapKit.h>
//#import "MWTelemetryManager.h"
//#import "MWGlobalManager.h"

@interface MWGPSMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MWGPSMapViewController
{
    int _radioRequestCount;
    BOOL _isOnScreen;
    MKPointAnnotation *_copterPin;
}

-(void) sendRadioUpdateRequest
{
    __weak typeof(self) weakSelf = self;
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_RAW_GPS andPayload:nil responseBlock:^(NSData *recieveData)
    {
        typeof(self) selfSt = weakSelf;
        if (!selfSt->_isOnScreen)
            return ;
        selfSt->_radioRequestCount++;
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [selfSt sendRadioUpdateRequest];
        });
        if (selfSt->_radioRequestCount > 100)
        {
            selfSt->_radioRequestCount = 0;
            [selfSt showBuyDialog];
        }
        [weakSelf updatePin];
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendRadioUpdateRequest) object:nil];
    [self performSelector:@selector(sendRadioUpdateRequest) withObject:nil afterDelay:.3]; //lag protection
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" GPS ";///MOTOR VALUES ";
    _radioRequestCount = 0;
    _copterPin = [[MKPointAnnotation alloc] init];
    _copterPin.title = @"X";
    self.mapView.mapType = MKMapTypeHybrid;

}

-(void) showBuyDialog
{
    if (!__delegate.isFullVersionUnlocked)
        [__delegate showBuyDialogFromVC:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self sendRadioUpdateRequest];
    
    [self showBuyDialog];
    self->_radioRequestCount = 0;
    _isOnScreen = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _isOnScreen = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendRadioUpdateRequest) object:nil];
    [super viewWillDisappear:animated];
}

- (void)updatePin
{
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = TELEMETRY_MANAGER.gps.longitude;
    coordinate.latitude = TELEMETRY_MANAGER.gps.latitude;
    _copterPin.coordinate = coordinate;
    [self.mapView addAnnotation:_copterPin];
}

@end
