//
//  MWAUXCheckBoxCell.m
//  MultiWii
//
//  Created by Eugene Skrebnev on 7/11/13.
//  Copyright (c) 2013 EugeneSkrebnev. All rights reserved.
//

#import "MWAUXCheckBoxCell.h"

@implementation MWAUXCheckBoxCell

-(void)makeInit
{
    [super makeInit];
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
    self.titleLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient_title-text@2x"]];
    for (MACheckBox* checkBox in self.checkBoxes)
    {
        [checkBox addTarget:self action:@selector(checkBoxChange:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    self.backgroundImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern_100.png"]];
    self.backgroundImageView.image = [UIImage imageNamed:@"cell@2x"];
}

-(void)setData:(MWBoxAuxSettingEntity *)data
{
    if (_data)
    {
        [_data removeObserver:self forKeyPath:@"saved"];
    }
    _data = data;
    if (_data)
    {
        [_data addObserver:self forKeyPath:@"saved" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    }
    self.titleLabel.text = data.name;
    
    for (int i = 0; i < 3; i++)
    {
        if (data)
        {
            MACheckBox* checkBox = self.checkBoxes[i];
            checkBox.selected = [data isCheckedForAux:self.selectedAuxChannel andPosition:i];
            checkBox.saved = [data isSavedForAux:self.selectedAuxChannel andPosition:i];
        }
        else
        {
            NSLog(@"no data");
        }
    }
}

-(void) updateSavedValues
{
    for (int i = 0; i < 3; i++)
    {
        MACheckBox* checkBox = self.checkBoxes[i];
        checkBox.saved = [self.data isSavedForAux:self.selectedAuxChannel andPosition:i];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateSavedValues];
}
-(void)setSelectedAuxChannel:(int)selectedAuxChannel
{
    _selectedAuxChannel = selectedAuxChannel;
    [self setData:self.data]; //refresh
}

-(void) checkBoxChange:(MACheckBox*) checkBox
{
    [self.data setValue:checkBox.selected forAux:self.selectedAuxChannel andPosition:checkBox.tag];
}

-(void)dealloc
{
    if (_data)
    {
        [_data removeObserver:self forKeyPath:@"saved"];
    }
}
@end
