//
//  HomeCell.m
//  iShanghai
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "HomeCell.h"
#import "HomeModel.h"
#import "TopicModel.h"

@interface HomeCell ()
{
    // 背景图片
    UIImageView *_backgroundIV;
    
    // 标题
    UILabel *_titleLabel;
    
    // 标签
    UILabel *_tagLabel;

    // 持续时间
    UILabel *_timeLabel;
    
    // 大头针图标
    UIImageView *_pinIV;
    
    // 街道
    UILabel *_venueLabel;
    
    // 地区
    UILabel *_zoneLabel;
    
    // 价格
    UILabel *_priceLabel;
    
    // RMB
    UILabel *_rmbLabel;
    
    // 遮罩图片
    UIImageView *_coverIV;
}
@end

@implementation HomeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"homeCell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell initCell];
    }
    
    return cell;
}

#pragma mark - 设置Cell样式
- (void)initCell {

    NSArray *colorArr = @[
                          [UIColor colorWithRed:252/255.0 green:157/255.0 blue:154/255.0 alpha:1],  // 浅红
                          [UIColor colorWithRed:249/255.0 green:205/255.0 blue:173/255.0 alpha:1],  // 浅黄
                          [UIColor colorWithRed:200/255.0 green:200/255.0 blue:169/255.0 alpha:1],  // 浅绿
                          [UIColor colorWithRed:131/255.0 green:175/255.0 blue:155/255.0 alpha:1]   // 深绿
                           ];
    
    // Cell随机背景颜色
    self.backgroundColor = colorArr[arc4random()%3];
    
    // 0. cell样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 1. 添加背景图片
    _backgroundIV = [[UIImageView alloc] init];
    _backgroundIV.frame = CGRectMake(0, 0, SCREENW, HomeCellHeight);
    [self.contentView addSubview:_backgroundIV];
    
    // 2. 添加遮罩
    _coverIV = [[UIImageView alloc] init];
    _coverIV.frame = CGRectMake(0, 30, SCREENW, HomeCellHeight - 30);
    [self.contentView addSubview:_coverIV];
    
    // 设置遮罩图片
    _coverIV.image = [UIImage imageNamed:@"homePage_layerViewNew"];
    
    // 3. 大头针图标
    _pinIV = [[UIImageView alloc] init];
    _pinIV.frame = CGRectMake(Margin, HomeCellHeight - Margin - SmallLabelHeight, SmallLabelHeight + 2, SmallLabelHeight + 2);
    [self.contentView addSubview:_pinIV];
    
    // 4. 街道
    CGFloat pinMaxX = CGRectGetMaxX(_pinIV.frame);
    _venueLabel = [[UILabel alloc] init];
    _venueLabel.frame = CGRectMake(pinMaxX + 3, HomeCellHeight - Margin - SmallLabelHeight, SCREENW/2.0, SmallLabelHeight);
    _venueLabel.textColor = lightGray;
    _venueLabel.font = Font(11);
    [self.contentView addSubview:_venueLabel];
    
    // 5. 地区
    CGFloat venueMaxX = CGRectGetMaxX(_venueLabel.frame);
    _zoneLabel = [[UILabel alloc] init];
    _zoneLabel.frame = CGRectMake(venueMaxX + 3, HomeCellHeight - Margin - SmallLabelHeight, SCREENW/2.0, SmallLabelHeight);
    _zoneLabel.textColor = lightGray;
    _zoneLabel.font = Font(11);
    [self.contentView addSubview:_zoneLabel];
    
    // 6. 持续时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(SCREENW*3/5.0, HomeCellHeight - Margin - SmallLabelHeight, SCREENW*2/5.0 - Margin, SmallLabelHeight);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = lightGray;
    _timeLabel.font = Font(11);
    [self.contentView addSubview:_timeLabel];
    
    // 7. RMB
    _rmbLabel = [[UILabel alloc] init];
    _rmbLabel.frame = CGRectMake(SCREENW - Margin - 33, 0, 33, 11);
    _rmbLabel.textAlignment = NSTextAlignmentRight;
    _rmbLabel.textColor = lightGray;
    _rmbLabel.text = @"RMB";
    _rmbLabel.font = Font(11);
    [self.contentView addSubview:_rmbLabel];
    
    // 8. 价格
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.frame = CGRectMake(SCREENW*3/5.0, 0, SCREENW*2/5.0 - Margin - 33, BigLabelHeight);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.textColor = lightGray;
    [self.contentView addSubview:_priceLabel];
    
    // 9. 标签
    CGFloat venueMinY = CGRectGetMinY(_venueLabel.frame);
    _tagLabel = [[UILabel alloc] init];
    _tagLabel.frame = CGRectMake(Margin, venueMinY - LineSpace - SmallLabelHeight - 4, SCREENW/2.0, SmallLabelHeight + 4);
    _tagLabel.font = Font(14);
    _tagLabel.textColor = lightBlue;
    [self.contentView addSubview:_tagLabel];
    
    // 10. 添加标题
    CGFloat tagMinY = CGRectGetMinY(_tagLabel.frame);
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(Margin, tagMinY - LineSpace - BigLabelHeight, SCREENW * (2 / 3.0) - Margin, BigLabelHeight);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
}

#pragma mark - 设置homeModel数据模型
- (void)setHomeModel:(HomeModel *)homeModel {
    [self setModel:homeModel];
}

- (void)setModel:(HomeModel *)model {
        
    _homeModel = model;
    
    // 1. 背景图片
    [_backgroundIV  setImageWithURL:[NSURL URLWithString:model.image]];
    
    // 2. 添加标题
    _titleLabel.text = model.title;
    
    // 计算标题文字高度
    CGFloat titleHeight = [_titleLabel boundingRectWithSize:CGSizeMake(_titleLabel.frame.size.width, MAXFLOAT)].height;
    
    // 重新设置标题的frame
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.origin.y = titleFrame.origin.y - (titleHeight - titleFrame.size.height);
    titleFrame.size.height = titleHeight;
    _titleLabel.frame = titleFrame;
    
    // 3. 标签
    _tagLabel.text = model.help_tags;
    
    // 4. 大头针图标
    _pinIV.image = [UIImage imageNamed:@"addresspage_mapimage"];
    
    // 5. 地区
    if (![model.zone isEqualToString:@""]) {
        _zoneLabel.text = [NSString stringWithFormat:@" | %@", model.zone];
    } else {
        _zoneLabel.text = @"";
    }
    
    CGFloat zoneWidth = [_zoneLabel boundingRectWithSize:CGSizeMake(MAXFLOAT, _zoneLabel.frame.size.height)].width;
    
    // 6. 街道
    _venueLabel.text = model.venue;
    
    // 计算街道文字宽度
    CGFloat venueWidth = [_venueLabel boundingRectWithSize:CGSizeMake(MAXFLOAT, SmallLabelHeight)].width;
    
    CGRect venueFrame = _venueLabel.frame;
    
    // 街道文字过长，就隐藏部分
    venueFrame.size.width = venueWidth;
    
    if ([model.time_string isEqualToString:@""]) {
        
        if (venueWidth > (SCREENW*3/5.0 - Margin - zoneWidth)) {
            venueFrame.size.width = SCREENW*3/5.0 - Margin - zoneWidth;
        }
    } else {
        
        if (venueWidth > (SCREENW*3/5.0 - 2.5*Margin - zoneWidth)) {
            venueFrame.size.width = SCREENW*3/5.0 - 2.5*Margin - zoneWidth;
        }
    }
    
    // 重设街道frame宽度
    _venueLabel.frame = venueFrame;
    
    // 重设地区frame宽度
    CGRect zoneFrame = _zoneLabel.frame;
    zoneFrame.size.width = zoneWidth;
    zoneFrame.origin.x = CGRectGetMaxX(_venueLabel.frame);
    _zoneLabel.frame = zoneFrame;
    
    // 6. 持续时间
    // 重新设置价格frame，并设置数据
    CGFloat timeMinY = CGRectGetMinY(_timeLabel.frame);
    CGRect priceFrame = _priceLabel.frame;
    CGRect rmbFrame = _rmbLabel.frame;
    
    if ([model.time_string isEqualToString:@""]) {
        
        // 重新设置时间frame
        CGRect frame = _timeLabel.frame;
        frame.size.height = 0;
        _timeLabel.frame = frame;

        priceFrame.origin.y = HomeCellHeight - BigLabelHeight - Margin;
        rmbFrame.origin.y = HomeCellHeight - 11 - Margin;
        
    } else {
        
        // 重新设置时间frame
        CGRect frame = _timeLabel.frame;
        frame.size.height = SmallLabelHeight;
        frame.origin.y = HomeCellHeight - Margin - SmallLabelHeight;
        
        _timeLabel.frame = frame;
        
        priceFrame.origin.y = timeMinY - BigLabelHeight - LineSpace;
        rmbFrame.origin.y = timeMinY - 11 - LineSpace;
    }
    
    // 根据price内容不同设置price与RMB的frame
    if ([Tool isPureInt:model.price_desc] ||
        [Tool isPureFloat:model.price_desc]) {
        
        rmbFrame.origin.x = SCREENW - Margin - 33;
        rmbFrame.size.width = 33;
    } else {
        
        rmbFrame.origin.x = SCREENW - Margin;
        rmbFrame.size.width = 0;
    }
    
    CGFloat rmbMinX = CGRectGetMinX(rmbFrame);
    priceFrame.origin.x = rmbMinX - priceFrame.size.width;
    
    _priceLabel.frame = priceFrame;
    _rmbLabel.frame = rmbFrame;
    
    // 设置时间
    _timeLabel.text = model.time_string;
    
    // 设置价格
    if ([model.price_desc isEqualToString:@""]) {
        _priceLabel.text = @"";
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"%@", model.price_desc];
    }
}

@end
