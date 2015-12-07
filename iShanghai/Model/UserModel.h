//
//  UserModel.h
//  iShanghai
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
/**
 *  登录会员信息
 */
@property (nonatomic, strong) NSString *member_token;
/**
 *  姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 *  Icon
 */
@property (nonatomic, strong) NSString *avatar;
/**
 *  member_id
 */
@property (nonatomic, strong) NSString *member_id;
/**
 *  去过的总数
 */
@property (nonatomic, strong) NSString *do_num;
/**
 *  想去的总数
 */
@property (nonatomic, strong) NSString *wish_num;
/**
 *  粉丝数
 */
@property (nonatomic, strong) NSString *fans_num;
/**
 *  关注数
 */
@property (nonatomic, strong) NSString *following_num;

@end
