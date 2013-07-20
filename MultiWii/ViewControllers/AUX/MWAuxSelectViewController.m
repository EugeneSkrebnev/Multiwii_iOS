//
//  MWAuxSelectViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAuxSelectViewController.h"
#import "MWHeader3LabelView.h"
#import "MWAUXCheckBoxCell.h"
@interface MWAuxSelectViewController ()

@end

@implementation MWAuxSelectViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @"- AUX -";
    
    for (int i = 1; i <= 4; i++)
    {
        [self.segmentControlForAuxChannel setTitle:[NSString stringWithFormat:@"AUX %d", i] forSegmentAtIndex:i - 1];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
}

- (void)viewDidUnload {
    [self setSegmentControlForAuxChannel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MWHeader3LabelView* headerView = [[MWHeader3LabelView alloc] init];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MWAUXCheckBoxCell* cell = (MWAUXCheckBoxCell*)[MWAUXCheckBoxCell loadView];
    
    return cell;
}


@end
