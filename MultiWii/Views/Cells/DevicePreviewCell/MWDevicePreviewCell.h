//
//  MWDevicePreviewCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/22/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWBaseTableViewCell.h"

@interface MWDevicePreviewCell : MWBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BLESettingArrow;
@property (weak, nonatomic) IBOutlet UIButton *detailsButton;

@property (nonatomic, assign) BOOL connected;
@end
