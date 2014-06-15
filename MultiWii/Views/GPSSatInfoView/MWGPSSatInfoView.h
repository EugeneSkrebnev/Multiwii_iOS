//
//  MWGPSSatInfoView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/8/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWGPSSatInfoView : UIView
@property (nonatomic, assign) int satelliteCount;
@property (nonatomic, assign) BOOL satelliteFix;
@property (nonatomic, assign) BOOL satellitesEnabled;
@end
