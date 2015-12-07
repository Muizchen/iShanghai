//
//  PersonalSectionHeader.h
//  iShanghai
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSectionHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *following_num;
@property (weak, nonatomic) IBOutlet UILabel *following_label;
@property (weak, nonatomic) IBOutlet UIButton *followingBtn;

@property (weak, nonatomic) IBOutlet UILabel *fans_num;
@property (weak, nonatomic) IBOutlet UILabel *fans_label;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;

@property (weak, nonatomic) IBOutlet UILabel *wish_num;
@property (weak, nonatomic) IBOutlet UILabel *wish_label;
@property (weak, nonatomic) IBOutlet UIButton *wishBtn;

@property (weak, nonatomic) IBOutlet UILabel *do_num;
@property (weak, nonatomic) IBOutlet UILabel *do_label;
@property (weak, nonatomic) IBOutlet UIButton *doBtn;

@end
