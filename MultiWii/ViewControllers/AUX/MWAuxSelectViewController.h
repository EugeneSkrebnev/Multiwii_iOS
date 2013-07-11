//
//  MWAuxSelectViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"

@interface MWAuxSelectViewController : MWBaseViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControlForAuxChannel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
