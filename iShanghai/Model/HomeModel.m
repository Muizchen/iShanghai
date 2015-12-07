//
//  HomeModel.m
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    // 不存在的键，
    
    if ([key isEqualToString:@"wish"]) {
        
        _isWish = value;
    } else if ([key isEqualToString:@"do"]) {
        
        _isDo = value;
    }
}

@end
