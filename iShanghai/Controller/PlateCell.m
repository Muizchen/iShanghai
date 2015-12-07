//
//  PlateCell.m
//  IntoSH
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PlateCell.h"

#import "PlateModel.h"

@implementation PlateCell
{
    UIImageView     *_imageView;
    UILabel         *_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        
        UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.bounds];
        bgIV.image = [UIImage imageNamed:@"homePage_layerView"];
        [self addSubview:bgIV];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 25)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.center = CGPointMake(SCREENW / 4, SCREENW / 4);
        _label.font = Font(18.0f);
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
    }
    
    return self;
}

- (void)setModel:(PlateModel *)model
{
    [_imageView setImageWithURL:[NSURL URLWithString:model.image]];
    
    _label.text = model.plate;
}

+ (NSString *)identifier
{
    return @"PlateCellId";
}

@end
