//
//  MWBasePidSettingsViewController.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/5/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseViewController.h"

@interface MWBasePidSettingsViewController : MWBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* _titles;
    NSArray* _iconsTitles;
    NSArray* _pids;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void) readPidButtonTapped;
-(void) writePidButtonTapped;
@end
