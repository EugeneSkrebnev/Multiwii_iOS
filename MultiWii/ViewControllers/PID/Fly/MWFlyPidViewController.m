//
//  MWFlyPidViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWFlyPidViewController.h"
#import "MWHeader3LabelView.h"
#import "MWFlyPidSettings.h"
#import "MWPidAdjustCell.h"
#import "MWTopbarButton.h"

@interface MWFlyPidViewController ()

@end

@implementation MWFlyPidViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" PID FLY ";
    
    
    _titles = @[@"ROLL", @"PITCH", @"YAW", @"LEVEL"];
    _iconsTitles = @[@"roll.png", @"pitch.png", @"yaw.png", @"level.png"];
    
    MWFlyPidSettings* flyPid = [MWPidSettingsManager sharedInstance].flyPid;
    _pids = @[flyPid.roll, flyPid.pitch, flyPid.yaw, flyPid.level];

    [self.tableView reloadData];

}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MWFlyPidSettings* flyPid = [MWPidSettingsManager sharedInstance].flyPid;
    [flyPid.roll.p addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void *)(flyPid.roll)];
    [flyPid.roll.i addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void *)(flyPid.roll)];
    [flyPid.roll.d addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void *)(flyPid.roll)];
    
    [flyPid.pitch.p addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void *)(flyPid.pitch)];
    [flyPid.pitch.i addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void *)(flyPid.pitch)];
    [flyPid.pitch.d addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:(__bridge void *)(flyPid.pitch)];
    
    [self readPidButtonTapped];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     MWFlyPidSettings* flyPid = [MWPidSettingsManager sharedInstance].flyPid;
    [flyPid.roll.p removeObserver:self forKeyPath:@"value"];
    [flyPid.roll.i removeObserver:self forKeyPath:@"value"];
    [flyPid.roll.d removeObserver:self forKeyPath:@"value"];

    [flyPid.pitch.p removeObserver:self forKeyPath:@"value"];
    [flyPid.pitch.i removeObserver:self forKeyPath:@"value"];
    [flyPid.pitch.d removeObserver:self forKeyPath:@"value"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.rollPitchLockSwitch.locked)
    {
        MWFlyPidSettings* flyPid = [MWPidSettingsManager sharedInstance].flyPid;

        if (context == (__bridge void *)(flyPid.roll))
        {
            [flyPid.pitch.p setValueWithoutNotification:flyPid.roll.p.value];
            [flyPid.pitch.i setValueWithoutNotification:flyPid.roll.i.value];
            [flyPid.pitch.d setValueWithoutNotification:flyPid.roll.d.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MAKnobViewUpdateAnimatedNotification" object:nil];
        }
        else
        {
            [flyPid.roll.p setValueWithoutNotification:flyPid.pitch.p.value];
            [flyPid.roll.i setValueWithoutNotification:flyPid.pitch.i.value];
            [flyPid.roll.d setValueWithoutNotification:flyPid.pitch.d.value];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MAKnobViewUpdateAnimatedNotification" object:nil];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWPidAdjustCell* cell = (MWPidAdjustCell*)[super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0)
    {
        if (! self.rollPitchLockSwitch)
        {
            self.rollPitchLockSwitch = [[MASwitch alloc] init];
            MWGlobalManagerQuadType copterType = [MWGlobalManager sharedInstance].copterType;
            if ((copterType == MWGlobalManagerQuadTypeX) ||
                (copterType == MWGlobalManagerQuadTypePlus) ||
                (copterType == MWGlobalManagerQuadTypeHexPlus) ||
                (copterType == MWGlobalManagerQuadTypeHexX))
            {
                self.rollPitchLockSwitch.locked = YES;
            }

        }
        self.rollPitchLockSwitch.center = CGPointMake(42, 67);

        [cell addSubview:self.rollPitchLockSwitch];
    }
    return cell;
}


@end
