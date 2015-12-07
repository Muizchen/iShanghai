//
//  CalendarModel.h
//  iShanghai
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarModel : NSObject
/**
 *  周：英文
 */
@property (nonatomic, strong) NSString *week;
/**
 *  周：中文
 */
@property (nonatomic, strong) NSString *week_cn;
/**
 *  日期：中文
 */
@property (nonatomic, strong) NSString *date_cn;
/**
 *  日
 */
@property (nonatomic, strong) NSString *day;
/**
 *  天气
 */
@property (nonatomic, strong) NSString *weather;
/**
 *  天气图编号
 */
@property (nonatomic, strong) NSString *weather_pic_num;
/**
 *  温度
 */
@property (nonatomic, strong) NSString *temp;

@property (nonatomic, strong) NSMutableArray *topicModels;

@end
