//
//  MWGPSSatInfoView.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 6/8/14.
//  Copyright (c) 2014 EugeneSkrebnev. All rights reserved.
//

#import "MWGPSSatInfoView.h"

@interface MWGPSSatInfoView()

@property (nonatomic, strong) UIImageView* satImageViewOrange;
@property (nonatomic, strong) UIImageView* satImageViewWhite;
@property (nonatomic, strong) UILabel* satCountLabel;
@property (nonatomic, assign) NSTimeInterval blinkTime;

@end

@implementation MWGPSSatInfoView

- (UIImageView *)satImageViewOrange {
    if (!_satImageViewOrange) {
        _satImageViewOrange = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pid_gps"]];
    }
    return _satImageViewOrange;
}

- (UIImageView *)satImageViewWhite {
    if (!_satImageViewWhite) {
        _satImageViewWhite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pid_gps_pressed"]];
    }
    return _satImageViewWhite;
}

- (UILabel *)satCountLabel {
    if (!_satCountLabel) {
        _satCountLabel = [[UILabel alloc] init];
        _satCountLabel.textColor = [UIColor whiteColor];
        _satCountLabel.text = @"-";
        _satCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _satCountLabel;
}

- (void)addSubviews {
    [self addSubview:self.satImageViewWhite];
    [self addSubview:self.satImageViewOrange];
    [self addSubview:self.satCountLabel];
}

- (void)setupConstrains {
    @weakify(self);
    [self.satImageViewOrange mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self.satImageViewWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self.satImageViewOrange);
    }];
    [self.satCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);        
        make.right.equalTo(self);
        make.centerY.equalTo(self);
    }];
}


- (void) blink {
    [UIView animateWithDuration:self.blinkTime animations:^{
        self.satImageViewOrange.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:self.blinkTime animations:^{
            self.satImageViewOrange.alpha = 0;
        } completion:^(BOOL finished) {
            [self blink];
        }];
    }];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
        [self setupConstrains];
        self.blinkTime = 0.2;
        [self blink];
    }
    return self;
}

- (void)setSatelliteFix:(BOOL)satelliteFix {
    _satelliteFix = satelliteFix;
    if (self.satellitesEnabled)
        self.blinkTime = _satelliteFix ? 0.8 : 0.3;
    else
        self.blinkTime = 0.08;
}

- (void)setSatellitesEnabled:(BOOL)satellitesEnabled {
    _satellitesEnabled = satellitesEnabled;

    if (!satellitesEnabled) {
        self.satCountLabel.text = @"Lost";
        self.blinkTime = 0.08;
    }
    else
        self.satelliteFix = self.satelliteFix;
}

- (void)setSatelliteCount:(int)satelliteCount {
    _satelliteCount = satelliteCount;
    self.satCountLabel.text = @(_satelliteCount).stringValue;
}
@end
