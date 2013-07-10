//
//  MWAboutViewController.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAboutViewController.h"

@interface MWAboutViewController ()

@end

@implementation MWAboutViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllerTitle = @"- ABOUT -";
}

-(NSArray*) titlesForMenu
{
    return @[@"ABOUT PROGRAM", @"HOW TO CONNECT", @"ASK QUESTION", @"SUBMIT BUG", @"ABOUT AUTHOR"];
}

-(NSArray*) iconsForMenu
{
    return @[@"about_program", @"how_to_connect", @"ask", @"bug", @"about_author"];
}


@end
