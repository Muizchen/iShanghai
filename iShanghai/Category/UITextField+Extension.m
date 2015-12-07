//
//  UITextField+Extension.m
//  iShanghai
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

+ (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder font:(CGFloat)font leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace {
    
    // Frame
    UITextField *textField = [[self alloc] initWithFrame:frame];
    
    // Placeholder
    textField.placeholder = placeholder;
    
    // Font
    textField.font = [UIFont systemFontOfSize:font];
    
    // Leftspacing
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftSpace, frame.size.height)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    // Rightspacing
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightSpace, frame.size.height)];
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    // 设置清除按钮
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    textField.returnKeyType = UIReturnKeyDone;
    
    return textField;
}

@end
