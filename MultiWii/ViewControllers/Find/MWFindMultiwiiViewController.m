//
//  MWFindMultiwiiViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/27/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWFindMultiwiiViewController.h"

@interface MWFindMultiwiiViewController ()

@end

#define FILTER_COUNT 5
#define MAGICAL_INIT_VALUE 999

@implementation MWFindMultiwiiViewController
{
    float _rssi[FILTER_COUNT];
}

-(float) distanceFromRSSI:(float) rssi
{
    float result = rssi;
    float A = 68;
    float C = 2.;
    result = (result + A) / (-10 * C);
    
    result = powf(10, result);
    
    return result;
}

-(float) signalStrengthFromDistance:(float) distance
{
    float maxDistance = 15;
    float minDistance = 1;
    float res = (1 - ((distance - minDistance) / (maxDistance - minDistance)));
    if (res > 1)
        res = 1;
    if (res < 0)
        res = 0;
    return res;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rssiLabel.textColor = [UIColor whiteColor];
    self.viewControllerTitle = @"FIND MY MULTIWII";
    self.rssiLabel.text = @"";
}

-(void) updateRssiLabelWithNewValue:(float) newRssi
{
    if (_rssi[0] == MAGICAL_INIT_VALUE)
    {
        for (int i = 0; i < FILTER_COUNT; i++)
        {
            _rssi[i] = newRssi;
        }
    }
    else
    {
        int rssiSum = 0;
        for (int i = 0; i < FILTER_COUNT - 1; i++)
        {
            _rssi[i] = _rssi[i + 1];
            rssiSum += _rssi[i];
        }
        _rssi[FILTER_COUNT - 1] = (float)(rssiSum + newRssi) / FILTER_COUNT;
    }
    float distance = [self distanceFromRSSI:_rssi[FILTER_COUNT - 1]];
    float signalStrength = [self signalStrengthFromDistance:distance];

    self.distanceLabel.text = @(distance).stringValue;
    self.rssiLabel.text = [NSString stringWithFormat:@"%d%%", (int)(signalStrength * 100)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MWBluetoothManager sharedInstance].rssiNotificationOn = YES;
    _rssi[0] = MAGICAL_INIT_VALUE;
    [MWBluetoothManager sharedInstance].didUpdateRssi = ^(CBPeripheral* device)
    {
        [self updateRssiLabelWithNewValue:device.RSSI.floatValue];
    };
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MWBluetoothManager sharedInstance].rssiNotificationOn = NO;
    [MWBluetoothManager sharedInstance].didUpdateRssi = nil;
}

@end
