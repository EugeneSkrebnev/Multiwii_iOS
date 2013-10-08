//
//  MWRatesGraphicAdjustCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/7/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"
#import "MWGraphicView.h"
#import "MWSliderView.h"

@interface MWRatesGraphicAdjustCell : MWBaseTableViewCell

@property (weak, nonatomic) IBOutlet MWGraphicView *graphicView;
@property (weak, nonatomic) IBOutlet MWSliderView *sliderBottom;
@property (weak, nonatomic) IBOutlet MWSliderView *sliderRight;

@property (weak, nonatomic) IBOutlet UILabel *titleLabelForRightSlider;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelForBottomSlider;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *slidersTitleLabels;
@end
