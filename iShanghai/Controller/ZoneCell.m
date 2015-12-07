//
//  ZoneCell.m
//  IntoSH
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZoneCell.h"

#import "ZoneModel.h"

@implementation ZoneCell
{
    UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _label = [UILabel createLabelWithFrame:self.bounds text:nil font:Font(15) textColor:[UIColor whiteColor]];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.borderWidth = 2.0;
        _label.layer.borderColor = [UIColor whiteColor].CGColor;
        _label.layer.cornerRadius = self.bounds.size.width / 2;
        _label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_label];
    }
    
    return self;
}

- (void)setModel:(ZoneModel *)model
{
    _label.text = model.zone;
}

+ (NSString *)identifier
{
    return @"ZoneCellId";
}

@end
