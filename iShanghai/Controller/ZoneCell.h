//
//  ZoneCell.h
//  IntoSH
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoneModel;

@interface ZoneCell : UICollectionViewCell

@property (nonatomic, strong) ZoneModel *model;

+ (NSString *)identifier;

@end
