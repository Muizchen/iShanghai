//
//  UILabel+Extension.m
//  iShanghai
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |        NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading
        attributes:attribute context:nil].size;
    
    return retSize;
}

// 创建Label
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = color;
    
    return label;
}

@end
