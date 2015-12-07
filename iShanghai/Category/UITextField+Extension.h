//
//  UITextField+Extension.h
//  iShanghai
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

/**
 *  创建一个TextField对象
 *
 *  @param frame       大小，位置
 *  @param placeholder 提示字
 *  @param font        字体
 *  @param leftSpace   左边距
 *  @param rightSpace  右边距
 *
 *  @return 返回一个TextField实例
 */
+ (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(CGFloat)font leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace;

@end
