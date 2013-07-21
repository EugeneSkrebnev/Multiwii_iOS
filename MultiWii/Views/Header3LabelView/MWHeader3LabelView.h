//
//  MWHeader3LabelView.h
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWHeader3LabelView : UIView
@property (nonatomic, strong) NSArray* labels;

@property (nonatomic, strong) UILabel* label1;
@property (nonatomic, strong) UILabel* label2;
@property (nonatomic, strong) UILabel* label3;
@property (nonatomic, assign) int leftCap;
@end
