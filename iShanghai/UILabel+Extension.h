//
//  UILabel+Extension.h
//  iShanghai
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
/**
 *  计算文字宽高
 *
 *  @param size Label宽度与高度（一般设置某一项为: MAXFLOAT， 以获得其值）
 *
 *  @return 文字和宽高
 */
- (CGSize)boundingRectWithSize:(CGSize)size;

// 创建Label
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color;

@end
