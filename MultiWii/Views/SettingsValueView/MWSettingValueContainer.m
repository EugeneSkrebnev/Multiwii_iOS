//
//  MWSettingValueContainer.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 10/8/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWSettingValueContainer.h"

@implementation MWSettingValueContainer
{
    BOOL _wasInited;
}

-(void) makeInit
{
    if (!_wasInited)
    {
        _wasInited = YES;

        self.backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundImage.image = [[UIImage imageNamed:@"field.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];

        
        self.backgroundActiveImage = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundActiveImage.image = [[UIImage imageNamed:@"field_active.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        self.backgroundActiveImage.hidden = YES;
        self.valueLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 2, 2)];
        
        self.valueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
        self.valueLabel.textColor = [UIColor whiteColor];
        
        self.valueLabel.backgroundColor = [UIColor clearColor];
//        self.valueLabel.backgroundColor = [UIColor blueColor];
        self.valueLabel.textAlignment = UITextAlignmentCenter;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.backgroundImage];
        [self addSubview:self.backgroundActiveImage];
        
        [self addSubview:self.valueLabel];
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self makeInit];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", _settingEntity.value];
    [self.backgroundActiveImage setHidden:_settingEntity.saved animated:YES duration:0.6];
}

-(void)setSettingEntity:(MWSettingsEntity *)settingEntity
{
    if (_settingEntity)
    {
        [_settingEntity removeObserver:self forKeyPath:@"value"];
        [_settingEntity removeObserver:self forKeyPath:@"saved"];
    }
    
    _settingEntity = settingEntity;
    
    if (_settingEntity)
    {
        [_settingEntity addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
        [_settingEntity addObserver:self forKeyPath:@"saved" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    }else
        self.valueLabel.text = @"-";
}

-(void)dealloc
{
    if (_settingEntity)
    {
        [_settingEntity removeObserver:self forKeyPath:@"value"];
        [_settingEntity removeObserver:self forKeyPath:@"saved"];
    }
}
@end
