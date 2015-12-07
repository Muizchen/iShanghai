//
//  WeatherView.m
//  iShanghai
//
//  Created by qianfeng on 15/10/17.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

- (instancetype)init {
    
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil];
    
    return [nibView objectAtIndex:0];
}

@end
