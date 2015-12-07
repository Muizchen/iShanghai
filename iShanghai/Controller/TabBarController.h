//
//  TabBarController.h
//  PMArchDay
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) UserModel *model;

@property (nonatomic, strong) UIView *tabBarView;

- (void)hideTabBar;

@end
