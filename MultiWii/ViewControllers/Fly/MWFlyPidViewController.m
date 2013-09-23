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
{
    NSArray* _titles;
    NSArray* _iconsTitles;
    NSArray* _pids;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @"- PID FLY -";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 98;
    
    _titles = @[@"ROLL", @"PITCH", @"YAW", @"LEVEL"];
    _iconsTitles = @[@"roll.png", @"pitch.png", @"yaw.png", @"level.png"];
    
    MWFlyPidSettings* flyPid = [MWPidSettingsManager sharedInstance].flyPid;
    _pids = @[flyPid.roll, flyPid.pitch, flyPid.yaw, flyPid.level];

    MWTopbarButton* readTopButton = [[MWTopbarButton alloc] init];
    MWTopbarButton* writeTopButton = [[MWTopbarButton alloc] init];
    int spaceBetweenbtns = 2;
    [readTopButton addTarget:self action:@selector(readPidButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [writeTopButton addTarget:self action:@selector(writePidButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [readTopButton setTitle:@"READ" forState:(UIControlStateNormal)];
    [writeTopButton setTitle:@"WRITE" forState:(UIControlStateNormal)];
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, readTopButton.width + writeTopButton.width + spaceBetweenbtns, readTopButton.height)];
    [container addSubview:readTopButton];
    writeTopButton.left = readTopButton.width + spaceBetweenbtns;
    [container addSubview:writeTopButton];
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

-(void) readPidButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_PID andPayload:nil responseBlock:^(NSData *recieveData) {
        NSLog(@"read success");
    }];

}

-(void) writePidButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_SET_PID
                                                       andPayload:[[MWGlobalManager sharedInstance].pidManager payloadFromPids]
                                                    responseBlock:^(NSData *recieveData) {
        NSLog(@"write success");
    }];
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MWHeader3LabelView* headerView = [[MWHeader3LabelView alloc] init];
    headerView.label1.text = @"P";
    headerView.label2.text = @"I";
    headerView.label3.text = @"D";
    headerView.leftCap = 45;
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWPidAdjustCell* cell = (MWPidAdjustCell*)[MWPidAdjustCell loadView];

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
    cell.titleLabel.text = _titles[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:_iconsTitles[indexPath.row]];
    cell.pid = _pids[indexPath.row];
    return cell;

}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
