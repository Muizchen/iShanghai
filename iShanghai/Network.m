//
//  Network.m
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "Network.h"
#import "UserModel.h"

@implementation Network

// Get
+ (void)getData:(NSString *)url params:(NSDictionary *)params successBlock:(void (^)(id))successBlock failBlcok:(void (^)(NSError *))failBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置超时
    [manager.requestSerializer setTimeoutInterval:10.0f];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 成功请求到数据
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 数据请求失败
        DEBUGLog(@"%@", error.localizedDescription);
        failBlock(error);
    }];
}

// Post
+ (void)requestForData:(NSString *)url params:(NSDictionary *)params successBlock:(void (^)(id))successBlock failBlcok:(void (^)(NSError *))failBlock {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置post请求头部
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"14656D44-6C2A-497C-B18F-91E55DEC0C7D" forHTTPHeaderField:@"UDID"];
    [manager.requestSerializer setValue:@"1.0.10" forHTTPHeaderField:@"APP_VERSION"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"OS_NAME"];
    
    // 设置用户登录信息
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if (app.userModel.member_token != nil) {
        [manager.requestSerializer setValue:app.userModel.member_token forHTTPHeaderField:@"Member-Token"];
    }
    
    // 设置超时
    [manager.requestSerializer setTimeoutInterval:10.0f];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 成功请求到数据
        //DEBUGLog(@"%@", responseObject);
        successBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 数据请求失败
        DEBUGLog(@"%@", error.localizedDescription);
        failBlock(error);
    }];
}

+(NSString *) uuid {
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    
    CFRelease(puuid);
    CFRelease(uuidString);
    
    return result;
}


@end
