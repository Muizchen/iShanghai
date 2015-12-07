//
//  PlateCell.h
//  IntoSH
//
//  Created by qianfeng on 15/10/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlateModel;

@interface PlateCell : UICollectionViewCell

@property (nonatomic, strong) PlateModel *model;

+ (NSString *)identifier;

@end
