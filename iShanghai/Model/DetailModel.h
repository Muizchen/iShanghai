//
//  DetailModel.h
//  iShanghai
//
//  Created by qianfeng on 15/10/14.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "HomeModel.h"

@interface DetailModel : HomeModel
/**
 *  轮播图片
 */
@property (nonatomic, strong) NSArray *images;
/**
 *  优惠数组
 */
@property (nonatomic, strong) NSArray *deal_rows;
/**
 *  详情
 */
@property (nonatomic, strong) NSArray *review_rows;
/**
 *  想要去的用户
 */
@property (nonatomic, strong) NSArray *wish_rows;
/**
 *  想要去的用户总数
 */
@property (nonatomic, assign) NSInteger wish_count;
/**
 *  去过的用户
 */
@property (nonatomic, strong) NSArray *do_rows;
/**
 *  去过的用户总数
 */
@property (nonatomic, assign) NSInteger do_count;
/**
 *  经度
 */
@property (nonatomic, strong) NSString *map_longitude;
/**
 *  纬度
 */
@property (nonatomic, strong) NSString *map_lattitude;
/**
 *  地址
 */
@property (nonatomic, strong) NSString *address;
/**
 *  街区
 */
@property (nonatomic, strong) NSString *district;
/**
 *  价格
 */
@property (nonatomic, strong) NSString *price_list;
/**
 *  评论数
 */
@property (nonatomic, strong) NSString *member_review_row_count;
/**
 *  所有评论
 */
@property (nonatomic, strong) NSArray *member_review_rows;
/**
 *  clock
 */
@property (nonatomic, strong) NSString *time2_string;

@end

