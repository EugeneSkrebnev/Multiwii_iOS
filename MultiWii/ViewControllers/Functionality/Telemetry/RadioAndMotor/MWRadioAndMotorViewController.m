//
//  MWRadioAndMotorViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 3/12/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWRadioAndMotorViewController.h"
#import "MWTelemetryRadioValuesCell.h"

@interface MWRadioAndMotorViewController ()

@property (nonatomic, strong) MWTelemetryRadioValuesCell* controlRadioValues; // pitch/thr/roll/yaw
@property (nonatomic, strong) MWTelemetryRadioValuesCell* auxRadioValues;     // aux1-4
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MWRadioAndMotorViewController
{
    int _radioRequestCount;
    BOOL _isOnScreen;
    NSMutableArray* _resposes;
    NSMutableArray* _results;
}

-(void) addResponseTime {
    [_resposes addObject:[NSDate date]];
    while (fabs([(NSDate*)_resposes[0] timeIntervalSinceNow]) > 1) {
        [_resposes removeObjectAtIndex:0];
    }
    [_results addObject:@(_resposes.count)];

    while (_results.count > 1000) {
        [_results removeObjectAtIndex:0];
    }
    double sma = [[_results valueForKeyPath: @"@sum.self"] doubleValue];
    NSLog(@"requests = %f", sma / (double)_results.count);
}

-(void) sendRadioUpdateRequest
{

    CONTROL_MANAGER.aux1 = 2000;
    [CONTROL_MANAGER save:^{
        [self addResponseTime];
    }];
    [CONTROL_MANAGER save:^{
        [self addResponseTime];
    }];
    dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self sendRadioUpdateRequest];
                        });
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sendRadioUpdateRequest) object:nil];
    [self performSelector:@selector(sendRadioUpdateRequest) withObject:nil afterDelay:.3]; //lag protection
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" RADIO ";///MOTOR VALUES ";
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    _radioRequestCount = 0;
    _resposes = [[NSMutableArray alloc] init];
    _results = [[NSMutableArray alloc] init];
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

#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2; //3 3- for motor values
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWTelemetryRadioValuesCell* cell;
    if (indexPath.row == 0)
    {
        cell = [MWTelemetryRadioValuesCell loadView];
        self.controlRadioValues = cell;
    }
    if (indexPath.row == 1)
    {
        cell = [MWTelemetryRadioValuesCell loadView];
        self.auxRadioValues = cell;
    }

    return cell;
}

-(void)setControlRadioValues:(MWTelemetryRadioValuesCell *)controlRadioValues
{
    _controlRadioValues = controlRadioValues;
    for (int i = 0; i < 4; i++)
    {
        [_controlRadioValues setSettingsEntity:TELEMETRY_MANAGER.radio.allChannels[i] forIndex:i];
    }
}

-(void)setAuxRadioValues:(MWTelemetryRadioValuesCell *)auxRadioValues
{
    _auxRadioValues = auxRadioValues;
    for (int i = 4; i < 8; i++)
    {
        [_auxRadioValues setSettingsEntity:TELEMETRY_MANAGER.radio.allChannels[i] forIndex:i - 4];
    }
}


@end
