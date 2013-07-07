//
//  MWMainViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainViewController.h"
#import "MAQuadrocopterFrame.h"

@implementation MWMainViewController

static BOOL firstTimeShow = YES;

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (firstTimeShow)
    {
        firstTimeShow = NO;
    }
}


@end
