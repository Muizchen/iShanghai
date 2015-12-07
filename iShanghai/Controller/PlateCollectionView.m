//
//  PlateCollectionView.m
//  IntoSH
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "PlateCollectionView.h"

#import "PlateCell.h"

#import "PlateModel.h"

#import "FindListController.h"

@implementation PlateCollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PlateCell identifier] forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENW / 2, SCREENW / 2);
}

#pragma mark 点击cell添加材料
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FindListController *findListVC = [[FindListController alloc] init];
    
    NSMutableArray *subPlates = [self.dataArr[indexPath.item] subPlates];
    NSString *plate = [self.dataArr[indexPath.item] plate];
    NSDictionary *dict = @{@"subPlates" : subPlates,
                           @"plate" : plate,
                           @"sub_plate" : @"全部"
                           };
    findListVC.params = dict;
    findListVC.listTitle = plate;
    
    if ([self.delegate respondsToSelector:@selector(jumpIntoFindListVC:)]) {
        [self.delegate jumpIntoFindListVC:findListVC];
    }
}

@end
