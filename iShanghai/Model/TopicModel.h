//
//  TopicModel.h
//  iShanghai
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeModel;

@interface TopicModel : NSObject
/**
 *  单个数据
 */
@property (nonatomic, strong) NSMutableArray *homeModels;
/**
 *  分组名
 */
@property (nonatomic, strong) NSString *title;
/**
 *  描述
 */
@property (nonatomic, strong) NSString *desc;

@end
