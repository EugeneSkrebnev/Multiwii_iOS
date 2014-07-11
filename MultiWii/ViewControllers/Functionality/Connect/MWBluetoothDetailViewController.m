//
//  MWBluetoothDetailViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/28/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWBluetoothDetailViewController.h"
#import "MWTXPowerView.h"
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
@property (weak, nonatomic) IBOutlet MWTXPowerView *powerView;

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
    
    RAC(self.speedLabel, text) = [[RACObserve(self, selectedUardSpeedIndex) skip:1] map:^id(NSNumber *value) {
        return [BLUETOOTH_MANAGER.supportedSpeeds[value.intValue] stringValue];
    }];
    
    [[[RACObserve(self, selectedUardSpeedIndex) skip:1] map:^id(NSNumber *value) {
        return BLUETOOTH_MANAGER.supportedSpeeds[value.intValue];
    }] subscribeNext:^(NSNumber *x) {
        [BLUETOOTH_MANAGER setSpeed:x.intValue];
    }];
}


- (void)setupPowerContainer {
    self.powerCheckBoxes = [self.powerContainer.subviews reject:^BOOL(UIView *view) {
        return ![view isKindOfClass:[UIButton class]];
    }];
    
    [[RACSignal merge:@[
                       [self.powerView.slider rac_signalForControlEvents:(UIControlEventTouchUpInside)],
                       [self.powerView.slider rac_signalForControlEvents:(UIControlEventTouchUpOutside)]
                      ]] subscribeNext:^(UISlider *slider) {
        self.selectedBoardTXPowerIndex = slider.value - 1;
    }];
    
//    [self.powerCheckBoxes enumerateObjectsUsingBlock:^(UIButton *checkbox, NSUInteger idx, BOOL *stop) {
//        checkbox.layer.anchorPoint = CGPointMake(0, 1);
//        checkbox.transform = CGAffineTransformMakeScale(0.25 * (idx+1), 0.25 * (idx+1));
//        checkbox.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *btn) {
//            [self.powerCheckBoxes enumerateObjectsUsingBlock:^(UIButton *otherBtn, NSUInteger idx, BOOL *stop) {
//                otherBtn.selected = otherBtn.tag <= btn.tag;
//                if (otherBtn.selected) {
//                    self.selectedBoardTXPowerIndex = otherBtn.tag - 2000; // some magic
//                }
//            }];
//            return [RACSignal empty];
//        }];
//    }];


    RAC(self.powerLabel, text) = [[RACObserve(self, selectedBoardTXPowerIndex) skip:1] map:^id(NSNumber *value) {
        int power[] = {-23, -6, 0, 4};
        return [NSString stringWithFormat:@"%d dBm", power[value.intValue]];
    }];
    
    [[RACObserve(self, selectedBoardTXPowerIndex) skip:1] subscribeNext:^(NSNumber* power) {
        [BLUETOOTH_MANAGER setTransmitterPower:power.intValue];
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (UILabel* lblTitle in @[self.powerTitle, self.speedTitle, self.nameTitle]) {
        lblTitle.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
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
    @weakify(self)
    self.setNameBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.nameTextField resignFirstResponder];
        [BLUETOOTH_MANAGER setName:self.nameTextField.text];
        return [RACSignal empty];
    }];
    
    self.infoLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
    self.infoLabel.textColor = [UIColor grayColor];
    self.infoLabel2.font = [UIFont fontWithName:@"Montserrat-Regular" size:13];
    self.infoLabel2.textColor = [UIColor grayColor];
    self.infoLabel2.text = @"* Name changes will be available \n after recconnect";
    

    self.nameTextField.backgroundColor = RGBA(0, 0, 0, 0.3);
    self.nameTextField.layer.cornerRadius = 12;
    

    [[[RACSignal interval:0.1 onScheduler:[RACScheduler mainThreadScheduler]] take:5] subscribeNext:^(id x) {
        
        UIButton* btnSelectedBaud = (UIButton*)[self.view viewWithTag:1000 + BLUETOOTH_MANAGER.speedIndex];
        [btnSelectedBaud.rac_command execute:btnSelectedBaud];
        
        
        self.powerView.slider.value = BLUETOOTH_MANAGER.speedIndex + 1;
        self.nameTextField.text = BLUETOOTH_MANAGER.name;
    }];
}


@end
