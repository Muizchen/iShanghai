//
//  Network.h
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Network : NSObject

+ (void)getData:(NSString *)url params:(NSDictionary *)params successBlock:(void (^)(id))successBlock failBlcok:(void (^)(NSError *))failBlock;

/**
 *  网络请求方法
 *
 *  @param url          网络地址
 *  @param params       参数字典
 *  @param successBlock 成功块
 *  @param failBlock    失败块
 *
 */
+ (void)requestForData:(NSString *)url params:(NSDictionary *)params successBlock:(void (^)(id data))successBlock failBlcok:(void (^)(NSError *error))failBlock;

@end
