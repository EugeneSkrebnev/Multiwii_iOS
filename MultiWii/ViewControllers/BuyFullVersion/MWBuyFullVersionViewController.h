//
//  MWBuyFullVersionViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/20/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"
#import "MWInAppButton.h"
#import "MAKnobView.h"

@interface MWBuyFullVersionViewController : MWBaseViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet MWInAppButton *buy5;
@property (weak, nonatomic) IBOutlet MWInAppButton *buy7;
@property (weak, nonatomic) IBOutlet MWInAppButton *buy10;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet MWInAppButton *restoreBtn;
@property (weak, nonatomic) IBOutlet MAKnobView *priceSelectKnobView;

@end
