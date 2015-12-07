//
//  HeaderView.m
//  iShanghai
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "HeaderView.h"
#import "TopicModel.h"

@interface HeaderView ()
{
    // 分类名
    UILabel *_titleLabel;
    
    // 总数
    UILabel *_totalLabel;
    
    // 点击查看
    UILabel *_clickLabel;
}
@end

@implementation HeaderView

+ (instancetype)headerViewWith:(UITableView *)tableView {
    
    static NSString *HEADER = @"header";
    
    // 创建headerView对象
    HeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADER];
    
    if (headerView == nil) {
        
        headerView = [[self alloc] initWithReuseIdentifier:HEADER];
        
        [headerView createUIWithHeaderView];
    }

    return headerView;
}

#pragma mark - 创建headerView视图UI
- (void)createUIWithHeaderView {
    
    // 点击查看
    _clickLabel = [[UILabel alloc] init];
    _clickLabel.frame = CGRectMake(SCREENW/2.0 - 40, SCREENW/4.0 - 10 - 4, 80, 10);
    _clickLabel.text = @"点击查看全部";
    _clickLabel.textColor = [UIColor lightGrayColor];
    _clickLabel.font = Font(10);
    _clickLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_clickLabel];
    
    // 总数
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.frame = CGRectMake(SCREENW/2.0 - 30, SCREENW*(3/16.0) - 13, 60, BigLabelHeight);
    _totalLabel.textColor = [UIColor whiteColor];
    _totalLabel.backgroundColor = lightBlue;
    _totalLabel.layer.cornerRadius = 7.0f;
    _totalLabel.clipsToBounds = YES;
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.font = Font(13);
    [self.contentView addSubview:_totalLabel];
    
    // 分类
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, SCREENW / 8.0 - BigLabelHeight, SCREENW, BigLabelHeight);
    _titleLabel.font = Font(BigLabelHeight);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    UIImageView *layerView = [[UIImageView alloc] initWithImage:Image(@"homepage_layeriew_list")];
    layerView.frame = CGRectMake(0, SCREENW / 4.0, SCREENW, SCREENW * 10 / 128.0);
    [self.contentView addSubview:layerView];
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)setTopicModel:(TopicModel *)topicModel {
    
    _topicModel = topicModel;
    
    _titleLabel.text = topicModel.title;
    
    _totalLabel.text = topicModel.desc;
}

@end
