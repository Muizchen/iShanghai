//
//  HomeModel.h
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
/**
 *  图片
 */
@property (nonatomic, strong) NSString *image;
/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;
/**
 *  地点
 */
@property (nonatomic, strong) NSString *venue;
/**
 *  地区
 */
@property (nonatomic, strong) NSString *zone;
/**
 *  类型
 */
@property (nonatomic, strong) NSString *help_tags;
/**
 *  价格
 */
@property (nonatomic, strong) NSString *price_desc;
/**
 *  持续时间
 */
@property (nonatomic, strong) NSString *time_string;
/**
 *  项目的编号
 */
@property (nonatomic, strong) NSString *item_id;
/**
 *  wish标签
 */
@property (nonatomic, strong) NSString *isWish;
/**
 *  do标签
 */
@property (nonatomic, strong) NSString *isDo;

@end
