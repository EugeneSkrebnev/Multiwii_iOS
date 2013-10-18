//
//  MWDevicePreviewCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWDevicePreviewCell.h"

@implementation MWDevicePreviewCell

+(NSString*) cellId
{
    return @"MWDevicePreviewCell_ID";
}

+(MWDevicePreviewCell *)loadView
{
    return (MWDevicePreviewCell*) [super loadView];
}

-(void)makeInit
{
    [super makeInit];
    self.nameLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
}
@end
