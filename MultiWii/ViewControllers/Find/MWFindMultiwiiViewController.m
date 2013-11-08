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
//    float _val;
}

-(float) distanceFromRSSI:(float) rssi
{
    float result = rssi;
    float A = 67; //RSSI IN ONE METR
    float C = 2.; //signal loss constant
    
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
    self.percentLabel = [[UILabel alloc] init];
    self.percentLabel.text = @"%";
    self.percentLabel.width  = 30;
    self.percentLabel.height = 30;
    self.percentLabel.left = 240;
    self.percentLabel.backgroundColor = [UIColor clearColor];
    self.percentLabel.textAlignment = UITextAlignmentCenter;
    self.percentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18];
    self.percentLabel.textColor = RGB(165, 165, 165);
    
    
    self.distanceLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:120];
    self.distanceLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text_finder_pattern@2x.png"]];
    self.distanceLabel.textAlignment = UITextAlignmentCenter;
    self.distanceLabel.width = 320 - (320 - self.mLabel.left);
    self.distanceLabel.left = 0;
    
    self.mLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:30];
    self.mLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text_finder_pattern_m@2x.png"]];
    self.mLabel.top += 3;
    
    if (IS_IPHONE_5)
    {
        self.percentLabel.top = 340;
        self.signalIndicator.top = 260;
        //        self.percentLabel.top = self.signalIndicator.top + self.signalIndicator.height - 11;
        if (!IS_IOS7)
        {
            self.infoLabel1.top -= 15;
            self.infoLabel2.top -= 10;
            self.percentLabel.top += 12;
        }
    }
    else
    {
        self.percentLabel.top = 285;
        self.signalIndicator.top = 205;
        self.mLabel.top -= 30;
        self.distanceLabel.top -= 30;
        if (!IS_IOS7)
        {
            self.percentLabel.top += 12;
        }
    }

    
    [self.view addSubview:self.percentLabel];
    
    for (UILabel* lbl in @[self.infoLabel1, self.infoLabel2])
    {
        lbl.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
        lbl.textColor = RGB(165, 165, 165);
        lbl.numberOfLines = 0;
    }
    
    self.infoLabel1.text = @"*To convert the distance to feet,\n tap the number.";
    self.infoLabel2.text = @"**The locating accuracy depends on the radio interferences, weather conditions, and other environmental factors.";
    self.metrPoundsButton.frame = CGRectMake(0, self.distanceLabel.top, 320, self.distanceLabel.height);
}

- (IBAction)metrPoundsButtonTapped:(id)sender
{
    self.metrPoundsButton.selected = !self.metrPoundsButton.selected;
    if (!self.metrPoundsButton.selected)
    {
        self.mLabel.text = @"M";
    }
    else
    {
        self.mLabel.text = @"FT";
        
    }
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
    if (!self.metrPoundsButton.selected)
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", distance];
        self.mLabel.text = @"M";
    }
    else
    {
        self.distanceLabel.text = [NSString stringWithFormat:@"%.0f", distance * 3.2808399];
        self.mLabel.text = @"FT";
        
    }
//    self.rssiLabel.text = [NSString stringWithFormat:@"%d%%", (int)(signalStrength * 100)];
    [self.signalIndicator setValue:signalStrength animated:YES duration:1];
    
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
    self.signalIndicator.value = 0;
//    _val = 0;
//    [self testVal];
}

//-(void) testVal
//{
//    _val += 0.25;
//    if (_val > 1.8)
//        _val = 0;
//    [self.signalIndicator setValue:_val animated:YES];
//    double delayInSeconds = 1.7;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self testVal];
//    });
//}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MWBluetoothManager sharedInstance].rssiNotificationOn = NO;
    [MWBluetoothManager sharedInstance].didUpdateRssi = nil;
}

@end
