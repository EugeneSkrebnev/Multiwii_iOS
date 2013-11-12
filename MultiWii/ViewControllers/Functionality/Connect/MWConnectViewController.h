//
//  MWConnectViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"
#import "MWRadarActivityIndicator.h"
@interface MWConnectViewController : MWBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) MWRadarActivityIndicator* radar;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end
