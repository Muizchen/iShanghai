//
//  Tool.h
//  iShanghai
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tool : NSObject

+ (void)setLoadingIndicatorStyle:(MJRefreshGifHeader *)header;

+ (BOOL)isInt:(double)num;

// 判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;

// 判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;

// 图片拉伸
+ (UIImage *)resizeImage:(UIImage *)image;

@end
