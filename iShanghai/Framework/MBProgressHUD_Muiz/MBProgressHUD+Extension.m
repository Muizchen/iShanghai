//
//  MBProgressHUD+Extension.m
//  画板
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

#define CURRENT_WINDOW [[UIApplication sharedApplication].windows lastObject]

@interface MBProgressHUD ()

@end

@implementation MBProgressHUD (extension)

+ (void)showSuccess:(NSString *)message {
    
    [self showMessage:message toView:nil pic:@"success"];
}

+ (void)showError:(NSString *)message {
    
    [self showMessage:message toView:nil pic:@"error"];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view pic:(NSString *)picName {
    
    if (view == nil) {
        view = CURRENT_WINDOW;
    }
    
    // 快速显示一个信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // 设置消息内容
    hud.labelText = message;
    
    // 设置成功图片
    if (picName != nil) {
        
        hud.mode = MBProgressHUDModeCustomView;
    
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:picName]];
        
        hud.customView = imgView;
    }
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}



@end
