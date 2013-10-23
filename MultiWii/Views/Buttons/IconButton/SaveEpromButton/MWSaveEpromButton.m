//
//  MWSaveEpromButton.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/23/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSaveEpromButton.h"

@implementation MWSaveEpromButton

-(void)makeInit
{
    [super makeInit];
    self.orangeButton = YES;
    [self setTitle:@"SAVE TO EPROM" forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"save.png"] forState:(UIControlStateNormal)];
}

@end
