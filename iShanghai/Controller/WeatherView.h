//
//  WeatherView.h
//  iShanghai
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView
/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *date;
/**
 *  星期：
 */
@property (weak, nonatomic) IBOutlet UILabel *weekDay;
/**
 *  天气图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *weatherPic;
/**
 *  摄氏度
 */
@property (weak, nonatomic) IBOutlet UILabel *celsius;
/**
 *  遮罩
 */
@property (weak, nonatomic) IBOutlet UIView *cover;
/**
 *  信息层
 */
@property (weak, nonatomic) IBOutlet UIView *informationView;

@end
