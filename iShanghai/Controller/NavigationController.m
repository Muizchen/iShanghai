//
//  NavigationController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条标题的文字属性
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:18.0f]
        }];
    
    // 设置导航条背景
    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
}

@end
