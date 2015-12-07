//
//  UserCell.m
//  iShanghai
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "UserCell.h"
#import "UserModel.h"

@implementation UserCell

- (void)awakeFromNib {
   
    _avatar.layer.cornerRadius = 24.0f;
    _avatar.clipsToBounds = YES;
}

- (void)setUserModel:(UserModel *)userModel {
    
    _userModel = userModel;
    
    [_avatar setImageWithURL:[NSURL URLWithString:userModel.avatar]];
    
    _name.text = userModel.name;
    
    _following_num.text = userModel.following_num;
    
    _fan_num.text = userModel.fans_num;
    
    _wish_num.text = userModel.wish_num;
    
    _do_num.text = userModel.do_num;
}

@end
