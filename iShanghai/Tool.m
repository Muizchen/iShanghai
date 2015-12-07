//
//  Tool.m
//  iShanghai
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (void)setLoadingIndicatorStyle:(MJRefreshGifHeader *)header {
    
    // 设置普通状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tmall_loading_%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    for (NSUInteger i = 9; i >= 1; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"tmall_loading_%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [header setImages:refreshingImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 隐藏状态
    header.stateLabel.hidden = YES;
}

+ (BOOL)isInt:(double)num {
    
    int tmp = num;
    
    if (num - tmp == 0) {
        return true;
    } else {
        return false;
    }
}

// 判断是否为整型：
+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

// 判断是否为浮点型：
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

// 图片拉伸
+ (UIImage *)resizeImage:(UIImage *)image
{
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    return [image stretchableImageWithLeftCapWidth:w / 2 topCapHeight:h / 2];
}

@end
