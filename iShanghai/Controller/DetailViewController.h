//
//  DetailViewController.h
//  iShanghai
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeModel;

@interface DetailViewController : UIViewController
/**
 *  数据源
 */
@property (nonatomic, strong) HomeModel *homeModel;

@end
