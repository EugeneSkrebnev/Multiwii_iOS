//
//  MWMainMenuCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"

@interface MWMainMenuCell : MWBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewForIcon;

@property (weak, nonatomic) IBOutlet UILabel *selectedLabelForTitle;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageViewForIcon;

@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) BOOL commingsoon;
@end
