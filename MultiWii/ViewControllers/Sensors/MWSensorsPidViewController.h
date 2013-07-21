//
//  MWSensorsPidViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/21/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"

@interface MWSensorsPidViewController : MWBaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *calibrateAccButton;
@property (weak, nonatomic) IBOutlet UIButton *calibrateMagButton;

@end
