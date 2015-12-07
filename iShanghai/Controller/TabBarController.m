
//
//  TabBarController.m
//  PMArchDay
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "TabBarController.h"
#import "ViewController.h"
#import "NavigationController.h"

@interface TabBarController ()

@end

@implementation TabBarController
{
    NSArray *_tabBarPics;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    NSArray *classes = @[@"HomeViewController", @"CalendarViewController", @"FindViewController", @"PersonalViewController"];
    _tabBarPics = @[@"home", @"calendar", @"find", @"personal"];
    
    _tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    _tabBarView.tag = HEIGHT;
    _tabBarView.backgroundColor = [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
    [self.view addSubview:_tabBarView];
    
    //隐藏系统tabBar
    self.tabBar.hidden = YES;
    
    for (int i = 0; i < classes.count; i++) {
        
        //循环创建类对象
        Class class = NSClassFromString(classes[i]);
        
        //创建导航栏
        ViewController *root = [[class alloc]init];
        
        NavigationController *nav = [[NavigationController alloc]initWithRootViewController:root];
        
        //工具栏添加按钮功能
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*2+i*(WIDTH-6)/classes.count, 0, (WIDTH-6)/classes.count, 49)];
        NSString *imgName = [NSString stringWithFormat:@"rootpage_%@btn_before", _tabBarPics[i]];
        NSString *pressedImgName = [NSString stringWithFormat:@"rootpage_%@btn_after", _tabBarPics[i]];
        
        // 设置按钮普通样式
        [btn setImage:[[UIImage imageNamed:imgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        [btn setImage:[[UIImage imageNamed:pressedImgName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        //默认选择第一个
        if (i == 0) {
            btn.selected = YES;
        }
        
        //给btn绑定事件
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(tabBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //将按钮添加到底部
        [_tabBarView addSubview:btn];
        
        //将所有对象加入到数组
        [controllers addObject:nav];
    }
    self.viewControllers = controllers;
}

- (void)tabBarBtnClicked:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    
    // tabBar跳转到对应的ViewController
    self.selectedIndex = index;
    
    //获取tabBarView对象
    UIView *tabBarView = [self.view viewWithTag:HEIGHT];
    for (UIView *view in tabBarView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            
            //切换对应按钮样式
            if (btn.tag == sender.tag) {
                
                btn.selected = YES;
            } else {
                
                btn.selected = NO;
            }
        }
    }
}

// 隐藏方法
- (void)hideTabBar {
    
    // 隐藏自定义TabBar
    UIView *view = [[UIView alloc] viewWithTag:HEIGHT];
    view.hidden = YES;
}

@end
