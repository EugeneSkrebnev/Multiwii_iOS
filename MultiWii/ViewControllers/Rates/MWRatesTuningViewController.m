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
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_GET_RC_TUNNING andPayload:nil responseBlock:^(NSData *recieveData) {
        NSLog(@"RCRates read success");
    }];
    

   
}

-(void) writeRCRatesButtonTapped
{
    [[MWMultiwiiProtocolManager sharedInstance] sendRequestWithId:MWI_BLE_MESSAGE_SET_RC_TUNNING
                                                       andPayload:[[MWGlobalManager sharedInstance].pidManager payloadFromRcTunning]
                                                    responseBlock:^(NSData *recieveData) {
                                                        NSLog(@"write RCRates success");
                                                    }];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWRateAdjustCell* cell = (MWRateAdjustCell*)[MWRateAdjustCell loadView];
    
    cell.knobEntities = @[[MWGlobalManager sharedInstance].pidManager.RCRates.rollPitchRate,
                          [MWGlobalManager sharedInstance].pidManager.RCRates.yawRate,
                          [MWGlobalManager sharedInstance].pidManager.RCRates.throttlePidAttenuationRate];
    
    return cell;
}


@end
