//
//  MWMainMenuCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainMenuCell.h"

@implementation MWMainMenuCell
{
    UIView* _dimGrayView;
    UIImageView* _ribbonView;
}
@synthesize title = _title;

+(NSString*) cellId
{
    return @"MWMainMenuCell_ID";
}

-(void) makeInit
{
    self.labelForTitle.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    self.selectedLabelForTitle.font = [UIFont fontWithName:@"Montserrat-Bold" size:14];
    
    UIImage* patternColorForUnselectedMenuItem = [UIImage imageNamed:@"gradient_menu-text@2x.png"];// stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    self.labelForTitle.textColor = [UIColor colorWithPatternImage:patternColorForUnselectedMenuItem];
    self.selectedLabelForTitle.textColor = [UIColor whiteColor];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.labelForTitle.text = title;
    self.selectedLabelForTitle.text = title;
}

-(NSString *)title
{
    return _title;
}



-(void)setCommingsoon:(BOOL)commingsoon
{
    if (commingsoon && !_commingsoon)
    {
        if (!_dimGrayView)
        {
            _dimGrayView = [[UIView alloc] init];
            _ribbonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ribbon_green.png"]];
        }
        _dimGrayView.backgroundColor = [UIColor blackColor];
        _dimGrayView.frame = self.bounds;
        _dimGrayView.alpha = 0.3;
        _ribbonView.left = self.width - _ribbonView.width;
        _ribbonView.top = 0;

        [self addSubview:_dimGrayView];
        [self addSubview:_ribbonView];
    }
    
    if (!commingsoon && _commingsoon)
    {
        [_dimGrayView removeFromSuperview];
    }
    
    _commingsoon = commingsoon;
    self.arrowImageView.hidden = commingsoon;
    self.selectionStyle = commingsoon ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
}
@end
