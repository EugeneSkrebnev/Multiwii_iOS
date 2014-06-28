//
//  MWBluetoothDetailViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/28/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWBluetoothDetailViewController.h"

@interface MWBluetoothDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *uartSpeedContainer;
@property (strong, nonatomic) NSArray *uartCheckBoxes;

@property (weak, nonatomic) IBOutlet UIView *powerContainer;
@property (strong, nonatomic) NSArray *powerCheckBoxes;
@property (assign, nonatomic) int selectedUardSpeedIndex;
@property (assign, nonatomic) int selectedBoardTXPowerIndex;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *speedTitle;
@property (weak, nonatomic) IBOutlet UILabel *powerTitle;

@property (weak, nonatomic) IBOutlet UIButton *setNameBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel2;

@end

@implementation MWBluetoothDetailViewController


- (void)setupSpeedContainer {
    self.uartCheckBoxes = [self.uartSpeedContainer.subviews reject:^BOOL(UIView *view) {
        return ![view isKindOfClass:[UIButton class]];
    }];
    
    for (UIButton *checkbox in self.uartCheckBoxes) {
        checkbox.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *btn) {
            [self.uartCheckBoxes enumerateObjectsUsingBlock:^(UIButton *otherBtn, NSUInteger idx, BOOL *stop) {
                otherBtn.selected = otherBtn.tag == btn.tag;
                if (otherBtn.selected) {
                    self.selectedUardSpeedIndex = otherBtn.tag - 1000; // some magic
                }
            }];
            return [RACSignal empty];
        }];
    }
    
    RAC(self.speedLabel, text) = [RACObserve(self, selectedUardSpeedIndex) map:^id(NSNumber *value) {
        return [BLUETOOTH_MANAGER.supportedSpeeds[value.intValue] stringValue];
    }];
    
    [[RACObserve(self, selectedUardSpeedIndex) map:^id(NSNumber *value) {
        return BLUETOOTH_MANAGER.supportedSpeeds[value.intValue];
    }] subscribeNext:^(NSNumber *x) {
        [BLUETOOTH_MANAGER setSpeed:x.intValue];
    }];
}


- (void)setupPowerContainer {
    self.powerCheckBoxes = [self.powerContainer.subviews reject:^BOOL(UIView *view) {
        return ![view isKindOfClass:[UIButton class]];
    }];

    
    for (UIButton *checkbox in self.powerCheckBoxes) {
        checkbox.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *btn) {
            [self.powerCheckBoxes enumerateObjectsUsingBlock:^(UIButton *otherBtn, NSUInteger idx, BOOL *stop) {
                otherBtn.selected = otherBtn.tag <= btn.tag;
                if (otherBtn.selected) {
                    self.selectedBoardTXPowerIndex = otherBtn.tag - 2000; // some magic
                }
            }];
            return [RACSignal empty];
        }];
    }
    //    0: -23dbm
    //    1: -6dbm
    //    2: 0dbm
    //    3: 6dbm

    RAC(self.powerLabel, text) = [RACObserve(self, selectedBoardTXPowerIndex) map:^id(NSNumber *value) {
        int power[] = {-23, -6, 0, 6};
        return [NSString stringWithFormat:@"%d dbm", power[value.intValue]];
    }];
    
    [RACObserve(self, selectedBoardTXPowerIndex) subscribeNext:^(NSNumber* power) {
        [BLUETOOTH_MANAGER setTransmitterPower:power.intValue];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (UILabel* lblTitle in @[self.powerTitle, self.speedTitle, self.nameTitle]) {
        lblTitle.font = [UIFont fontWithName:@"Montserrat-Regular" size:16];
        lblTitle.textColor = RGB(250, 46, 9);
    }
    self.setNameBtn.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:12];

    
    for (UILabel* lblTitle in @[self.powerLabel, self.speedLabel]) {
        lblTitle.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    }
    self.viewControllerTitle = @"BLUETOOTH SETTINGS";
    [self setupSpeedContainer];
    [self setupPowerContainer];
    
    self.nameTextField.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    self.nameTextField.textColor = [UIColor whiteColor];
    
    self.setNameBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.nameTextField resignFirstResponder];
        [BLUETOOTH_MANAGER setName:self.nameTextField.text];
        return [RACSignal empty];
    }];
    
    self.infoLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
    self.infoLabel.textColor = [UIColor grayColor];
    self.infoLabel2.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
    self.infoLabel2.textColor = [UIColor grayColor];
    self.infoLabel2.text = @"* Name changes will be available \n after recconnect";
}


@end
