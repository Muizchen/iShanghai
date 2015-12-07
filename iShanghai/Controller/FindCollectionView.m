//
//  FindCollectionView.m
//  IntoSH
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FindCollectionView.h"

@implementation FindCollectionView

- (instancetype)initWithFrame:(CGRect)viewFrame dataArr:(NSArray *)dataArr cellClass:(Class)cellClass reuseID:(NSString *)reuseID bgColor:(UIColor *)color collectionViewFrame:(CGRect)collectionFrame lineAndItemSpace:(CGSize)space{
    if (self = [super initWithFrame:viewFrame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = space.width;
        layout.minimumInteritemSpacing = space.height;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.backgroundColor = color;
        
        [self addSubview:_collectionView];
        
        [_collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseID];
        
        _dataArr = dataArr;
    }
    
    return  self;
}

// 子类相同的方法都由父类具体实现，不同方法由子类具体实现.
- (void)reloadData {
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

// 填充cell:每个collectionView都有不同的Cell.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
