//
//  MBProgressHUD+Extension.h
//  画板
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (extension)

+ (void)showSuccess:(NSString *)message;

+ (void)showError:(NSString *)message;
/**
 *  显示信息
 *
 *  @param message 消息内容
 *  @param view    显示在哪个视图上，默认为window
 *  @param type    图片名
 */
+ (void)showMessage:(NSString *)message toView:(UIView *)view pic:(NSString *)picName;

@end
