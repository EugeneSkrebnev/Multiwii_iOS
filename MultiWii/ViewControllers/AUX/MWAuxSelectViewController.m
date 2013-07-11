//
//  MWAuxSelectViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAuxSelectViewController.h"

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
    
}

- (void)viewDidUnload {
    [self setSegmentControlForAuxChannel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
