//
//  MWMenuSubtitleCell.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/10/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWMainMenuCell.h"

@interface MWMenuSubtitleCell : MWMainMenuCell

@property (weak, nonatomic) IBOutlet UILabel *labelForSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabelForSubtitle;

@property (nonatomic, strong) NSString* subtitle;

@end
