//
//  AppDelegate.h
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserModel *userModel;

@end

