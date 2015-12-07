//
//  ZoneCollectionView.m
//  IntoSH
//
//  Created by qianfeng on 15/10/16.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZoneCollectionView.h"

#import "FindListController.h"

#import "ZoneModel.h"

#import "ZoneCell.h"

@implementation ZoneCollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ZoneCell identifier] forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENW / 5.0, SCREENW / 5.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREENW, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREENW, Margin);
}

#pragma mark 点击cell添加材料
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FindListController *findListVC = [[FindListController alloc] init];
    NSString *zoneId = ((ZoneModel *)self.dataArr[indexPath.item]).zone_id;
    NSString *zone = ((ZoneModel *)self.dataArr[indexPath.item]).zone;
    NSDictionary *dict = @{@"zone_id" : zoneId,
                           };
    findListVC.params = dict;
    findListVC.listTitle = zone;
    
    if ([self.delegate respondsToSelector:@selector(jumpIntoFindListVC:)]) {
        [self.delegate jumpIntoFindListVCWithAnimate:findListVC];
    }
}

@end
