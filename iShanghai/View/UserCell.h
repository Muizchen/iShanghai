//
//  UserCell.h
//  iShanghai
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;

@interface UserCell : UITableViewCell

@property (nonatomic, strong) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *following_num;

@property (weak, nonatomic) IBOutlet UILabel *fan_num;

@property (weak, nonatomic) IBOutlet UILabel *wish_num;

@property (weak, nonatomic) IBOutlet UILabel *do_num;

@end
