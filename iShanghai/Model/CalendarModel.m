//
//  CalendarModel.m
//  iShanghai
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "CalendarModel.h"

@implementation CalendarModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.topicModels = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

@end
