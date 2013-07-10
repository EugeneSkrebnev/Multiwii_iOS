//
//  MWMenuSubtitleCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMenuSubtitleCell.h"

@implementation MWMenuSubtitleCell
@synthesize subtitle = _subtitle;
+(NSString*) cellId
{
    return @"MWMenuSubtitleCell_ID";
}

-(NSString *)subtitle
{
    return _subtitle;
}

-(void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    self.labelForSubtitle.text = subtitle;
    self.selectedLabelForSubtitle.text = subtitle;
}

-(void) makeInit
{
    [super makeInit];
    self.labelForSubtitle.textColor = [UIColor colorWithRed:165./255 green:165./255 blue:165./255 alpha:1];
    self.selectedLabelForSubtitle.textColor = [UIColor colorWithRed:200./255 green:200./255 blue:200./255 alpha:1];
    
    self.selectedLabelForSubtitle.font = [UIFont fontWithName:@"Montserrat-Bold" size:12];
    self.labelForSubtitle.font = [UIFont fontWithName:@"Montserrat-Bold" size:12];
}

@end
