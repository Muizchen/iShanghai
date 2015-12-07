//
//  PersonalSectionHeader.m
//  iShanghai
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "PersonalSectionHeader.h"

@interface PersonalSectionHeader ()

@end

@implementation PersonalSectionHeader

- (instancetype)init {
    
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"PersonalSectionHeader" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[UILabel class]]) {
            
                ((UILabel *)view).textColor = fontBlack;
            }
        }
        
        _following_label.textColor = lightBlue;
        _following_num.textColor = lightBlue;
    } else if ([sender.titleLabel.text isEqualToString:@"粉丝"]) {
        
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[UILabel class]]) {
                
                ((UILabel *)view).textColor = fontBlack;
            }
        }
        
        _fans_label.textColor = lightBlue;
        _fans_num.textColor = lightBlue;
    } else if ([sender.titleLabel.text isEqualToString:@"想去"]) {
        
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[UILabel class]]) {
                
                ((UILabel *)view).textColor = fontBlack;
            }
        }
        
        _wish_label.textColor = lightBlue;
        _wish_num.textColor = lightBlue;
    } else {
        
        for (UIView *view in self.subviews) {
            
            if ([view isKindOfClass:[UILabel class]]) {
                
                ((UILabel *)view).textColor = fontBlack;
            }
        }
        
        _do_label.textColor = lightBlue;
        _do_num.textColor = lightBlue;
    }
}

@end
