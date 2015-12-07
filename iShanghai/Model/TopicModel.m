//
//  TopicModel.m
//  iShanghai
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.homeModels = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
