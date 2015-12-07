//
//  FindCollectionView.h
//  IntoSH
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FindListController;

@protocol FindCollectionViewDelegate <NSObject>

- (void)jumpIntoFindListVC:(FindListController *)vc;

- (void)jumpIntoFindListVCWithAnimate:(FindListController *)vc;

@end


@interface FindCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

/**
 *  CollectionView
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  CollectionView的数据
 */
@property (nonatomic, strong) NSArray *dataArr;

/**
 *  创建自定义CollectionView的实例
 *
 *  @param frame     Frame
 *  @param dataArr   数据
 *  @param cellClass Cell类
 *  @param reuseID   Cell ID
 *  @param color     背景颜色
 *  @param space     行和列的间距
 *
 *  @return RootMaterialView实例(包括其子类)
 */
- (instancetype)initWithFrame:(CGRect)viewFrame dataArr:(NSArray *)dataArr cellClass:(Class)cellClass reuseID:(NSString *)reuseID bgColor:(UIColor *)color collectionViewFrame:(CGRect)collectionFrame lineAndItemSpace:(CGSize)space;

/**
 *  刷新界面的方法
 */
- (void)reloadData ;

@property (nonatomic, weak) id<FindCollectionViewDelegate> delegate;

@end
