//
//  MWAuxSelectViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWRatesTuningViewController.h"
#import "MWTopbarButton.h"
#import "MWPidSettingsManager.h"
#import "MWRateAdjustCell.h"
#import "MWRatesGraphicAdjustCell.h"

@interface MWRatesTuningViewController ()

@end

@implementation MWRatesTuningViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @" RATES ";
    

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self createReadWriteBtns];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BLUETOOTH_MANAGER.didFailToFindService = ^(NSError* err, CBPeripheral* device)
    {
        if (!device)
        {
            [UIAlertView alertErrorWithMessage:@"No connected device. Please connect first."];
        }
    };
    [self readRCRatesButtonTapped];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    BLUETOOTH_MANAGER.didFailToFindService = nil;
}

-(void) createReadWriteBtns
{
    MWTopbarButton* readTopButton = [[MWTopbarButton alloc] init];
    MWTopbarButton* writeTopButton = [[MWTopbarButton alloc] init];
    int spaceBetweenbtns = 2;
    [readTopButton addTarget:self action:@selector(readRCRatesButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    [writeTopButton addTarget:self action:@selector(writeRCRatesButtonTapped) forControlEvents:(UIControlEventTouchUpInside)];
    
    [readTopButton setTitle:@"READ" forState:(UIControlStateNormal)];
    [writeTopButton setTitle:@"WRITE" forState:(UIControlStateNormal)];
    
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, readTopButton.width + writeTopButton.width + spaceBetweenbtns, readTopButton.height)];
    [container addSubview:readTopButton];
    writeTopButton.left = readTopButton.width + spaceBetweenbtns;
    [container addSubview:writeTopButton];
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
}

-(void) readRCRatesButtonTapped
{
    [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_GET_RC_TUNNING andPayload:nil responseBlock:^(NSData *recieveData) {
        NSLog(@"RCRates read success");
    }];
}

-(void) writeRCRatesButtonTapped
{
    if (__delegate.isFullVersionUnlocked)
    {
        BOOL needToSaveEprom = [MWSaveableSettingEntity haveUnsavedItems];
        [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_SET_RC_TUNNING
                                 andPayload:[PID_MANAGER payloadFromRcTunning]
                              responseBlock:^(NSData *recieveData) {
                                  NSLog(@"write RCRates success");
                                  if (COMBINE_WRITE_AND_SAVE_EPROM)
                                      if (needToSaveEprom)
                                      {
                                          [PROTOCOL_MANAGER sendRequestWithId:MWI_BLE_MESSAGE_SET_SAVE_EPROM
                                                                   andPayload:nil
                                                                responseBlock:^(NSData *recieveData)
                                           {
                                               NSLog(@"Eprom saved");
                                           }];
                                          
                                      }

                              }];
    }
    else
    {
        [__delegate showBuyDialogFromVC:self];
    }
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int inc = IS_IPHONE_5 ? 22 : 0;
    return indexPath.row > 1 ? 120 + inc : 148 + inc;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* result;
    
    
    if (indexPath.row == 2)
    {
        MWRateAdjustCell* cell = [MWRateAdjustCell loadView];
    
        cell.knobEntities = @[PID_MANAGER.RCRates.rollPitchRate,
                              PID_MANAGER.RCRates.yawRate,
                              PID_MANAGER.RCRates.throttlePidAttenuationRate];
        result = cell;
    }
    else
    {
        MWRatesGraphicAdjustCell* cell = [MWRatesGraphicAdjustCell loadView];
        if (indexPath.row == 0)
        {
            cell.titleLabelForTopValueContainer.text = @"RC Expo";
            cell.titleLabelForBottomValueContainer.text = @"RC Rate";
            cell.titleLabelForRightSlider.text = @"RC Rate";
            cell.titleLabelForBottomSlider.text = @"RC Expo";
            
            cell.sliderRight.settingsEntity = PID_MANAGER.RCRates.rcRate;
            cell.sliderBottom.settingsEntity = PID_MANAGER.RCRates.rcExpo;
            
            cell.settingsValueContainerTop.settingEntity = PID_MANAGER.RCRates.rcExpo;
            cell.settingsValueContainerBottom.settingEntity = PID_MANAGER.RCRates.rcRate;
            
            cell.graphicView.entityX = PID_MANAGER.RCRates.rcExpo;
            cell.graphicView.entityY = PID_MANAGER.RCRates.rcRate;
            
            cell.graphicView.graphicType = MWGraphicViewTypeRates;
            
        }
        else
        {
            cell.titleLabelForTopValueContainer.text = @"Thr. Mid.";
            cell.titleLabelForBottomValueContainer.text = @"Thr. Expo";
            cell.titleLabelForRightSlider.text = @"Thr. Expo";
            cell.titleLabelForBottomSlider.text = @"Thr. Mid.";
            
            cell.sliderRight.settingsEntity = PID_MANAGER.RCRates.throttleExpo;
            cell.sliderBottom.settingsEntity = PID_MANAGER.RCRates.throttleMiddle;
            
            cell.settingsValueContainerTop.settingEntity = PID_MANAGER.RCRates.throttleMiddle;
            cell.settingsValueContainerBottom.settingEntity = PID_MANAGER.RCRates.throttleExpo;
            
            cell.graphicView.entityX = PID_MANAGER.RCRates.throttleMiddle;
            cell.graphicView.entityY = PID_MANAGER.RCRates.throttleExpo;
            
            cell.graphicView.graphicType = MWGraphicViewTypeThrottle;

        }
        result = cell;
    }

    return result;
}


@end
