//
//  HomeCell.h
//  iShanghai
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel;
@class TopicModel;

@interface HomeCell : UITableViewCell
/**
 *  推荐模型
 */
@property (nonatomic, strong) HomeModel *homeModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
