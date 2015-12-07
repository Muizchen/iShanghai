//
//  HeaderView.h
//  iShanghai
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicModel;

@interface HeaderView : UITableViewHeaderFooterView
/**
 *  HeaderView数据源
 */
@property (nonatomic, strong) TopicModel *topicModel;

+ (instancetype)headerViewWith:(UITableView *)tableView;

@end
