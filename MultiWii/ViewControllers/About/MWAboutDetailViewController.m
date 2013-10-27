//
//  MWAboutDetailViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/28/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAboutDetailViewController.h"

@interface MWAboutDetailViewController ()

@end

@implementation MWAboutDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.textView.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
    self.textView.textColor = [UIColor grayColor];
    self.textView.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.textView.layer.shadowOffset = CGSizeMake(1.f, 1.0f);
    self.textView.layer.shadowOpacity = .0f;
    self.textView.layer.shadowRadius = .0f;

    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.text = self.text;
}


@end
