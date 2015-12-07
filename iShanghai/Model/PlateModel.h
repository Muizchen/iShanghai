//
//  PlateModel.h
//  IntoSH
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlateModel : NSObject

@property (nonatomic, strong) NSString *plate;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSMutableArray *subPlates;

@end
