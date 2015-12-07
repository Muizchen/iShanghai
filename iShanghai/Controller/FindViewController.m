//
//  DiscoverController.m
//  IntoSH
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FindViewController.h"
#import "FindListController.h"

#import "PlateModel.h"
#import "ZoneModel.h"

#import "PlateCell.h"
#import "ZoneCell.h"

#import "PlateCollectionView.h"
#import "ZoneCollectionView.h"

@interface FindViewController () <FindCollectionViewDelegate, UITextFieldDelegate>
{
    UITextField             *_searchBar;            // 搜索框
    
    NSMutableArray          *_plateDataArr;         // 分类数据
    NSMutableArray          *_zoneDataArr;          // 地点数据
    
    PlateCollectionView     *_plateCollectionView;  // 分类collectionView
    ZoneCollectionView      *_zoneCollectionView;   // 地点collectionView
}

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景色
    //    self.view.backgroundColor = [UIColor blackColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化数据
    [self initData];
    
    // 获取分类数据
    [self getPlateData];
    
    // 获取地点数据
    [self getZoneData];
    
    // 创建collectionView
    [self createCollectionView];
    
    // 创建导航
    [self createNav];
    
    
}

#pragma mark 初始化数据
- (void)initData
{
    _plateDataArr = [NSMutableArray arrayWithCapacity:0];
    _zoneDataArr = [NSMutableArray arrayWithCapacity:0];
}


#pragma mark 创建导航
- (void)createNav
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, IFindNavH)];
    navView.backgroundColor = lightBlack;
    [self.view addSubview:navView];
    
    // 地点
    UIButton *zoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zoneBtn.frame = CGRectMake(13, 32, 20, 20);
    [zoneBtn setBackgroundImage:[UIImage imageNamed:@"detalpage_loctionbtn"] forState:UIControlStateNormal];
    zoneBtn.tag = 11;
    [zoneBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:zoneBtn];
    
    // 附近推荐
//    UIButton *nearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    nearBtn.frame = CGRectMake(SCREENW - 10 - 24, 32, 20, 20);
//    [nearBtn setBackgroundImage:[UIImage imageNamed:@"detalpage_nearbybtn"] forState:UIControlStateNormal];
//    nearBtn.tag = 12;
//    [nearBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:nearBtn];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 24)];
    titleLabel.center = CGPointMake(SCREENW / 2, 30 + 24 / 2.0);
    titleLabel.text = @"发现";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = Font(18);
    [navView addSubview:titleLabel];
    
    // 创建搜索框
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(10, IFindNavH - 10 - 35, SCREENW - 20, 32)];
    _searchBar.layer.borderWidth = 1.5f;
    _searchBar.layer.borderColor = [UIColor grayColor].CGColor;
    _searchBar.layer.cornerRadius = 7.0f;
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.textColor = [UIColor whiteColor];
    _searchBar.tintColor = [UIColor redColor];
    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.clearButtonMode=UITextFieldViewModeAlways;
    _searchBar.tag = 21;
    _searchBar.delegate = self;
    _searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName : lightGray,NSFontAttributeName : Font(18)}];
    UIView *iconView = [[UIView alloc] init];
    iconView.width = 35;
    iconView.height = 30;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"discoveryPage_searchbutton_up"];
    searchIcon.width = 17.0f;
    searchIcon.height = 17.0f;
    searchIcon.center = iconView.center;
    [iconView addSubview:searchIcon];
    
    _searchBar.leftView = iconView;
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    [navView addSubview:_searchBar];
    
}

#pragma mark 导航按钮点击
- (void)navBtnClick:(UIButton *)btn
{
    if (btn.tag == 11) {
        if (_zoneCollectionView.y != IFindNavH) {
            [UIView animateWithDuration:0.4f animations:^{
                CGRect frame = _zoneCollectionView.frame;
                frame.origin.y += _zoneCollectionView.frame.size.height;
                _zoneCollectionView.frame = frame;
            }];
        }
        else {
            [UIView animateWithDuration:0.4f animations:^{
                CGRect frame = _zoneCollectionView.frame;
                frame.origin.y -= _zoneCollectionView.frame.size.height;
                _zoneCollectionView.frame = frame;
            }];
        }
    }
}


#pragma mark 请求分类数据
- (void)getPlateData
{
    [Network requestForData:http_of_find params:nil successBlock:^(id data) {
        
        NSArray *dataArr = data[@"rows"];
        for (NSDictionary *dict in dataArr) {
            PlateModel *model = [[PlateModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *array = dict[@"sub_plates"];
            model.subPlates = array;
            
            [_plateDataArr addObject:model];
        }

        [_plateCollectionView reloadData];
    } failBlcok:^(NSError *error) {
        
    }];
}

#pragma mark 请求地点数据
- (void)getZoneData
{
    [Network requestForData:http_of_zone params:nil successBlock:^(id data) {
        
        NSArray *dataArr = data[@"rows"];
        for (NSDictionary *dict in dataArr) {
            ZoneModel *model = [[ZoneModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_zoneDataArr addObject:model];
        }
        
        [_zoneCollectionView reloadData];
    } failBlcok:^(NSError *error) {
        
    }];
}

#pragma mark FindCollectionView 代理
- (void)jumpIntoFindListVC:(FindListController *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpIntoFindListVCWithAnimate:(FindListController *)vc
{
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = _zoneCollectionView.frame;
        frame.origin.y -= _zoneCollectionView.frame.size.height;
        _zoneCollectionView.frame = frame;
    } completion:^(BOOL finished) {
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

#pragma mark UITextField 代理
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if ([textField.text isEqualToString:@""]) {
//        textField.enablesReturnKeyAutomatically = YES;
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // 如果没有内容就不搜索
    if (![textField.text isEqualToString:@""]) {
        FindListController *findListVC = [[FindListController alloc] init];
        NSDictionary *dict = @{@"keyword" : textField.text
                               };
        findListVC.params = dict;
        findListVC.listTitle = textField.text;
        
        [self.navigationController pushViewController:findListVC animated:YES];
    }
    return YES;
}

#pragma mark 创建collectionView
- (void)createCollectionView
{
    // 创建分类视图
    _plateCollectionView = [[PlateCollectionView alloc] initWithFrame:CGRectMake(0, IFindNavH, SCREENW, SCREENH - IFindNavH - 49) dataArr:_plateDataArr cellClass:[PlateCell class] reuseID:[PlateCell identifier] bgColor:lightBlack collectionViewFrame:CGRectMake(0, 0, SCREENW, SCREENH - IFindNavH - 49) lineAndItemSpace:CGSizeZero];
    _plateCollectionView.delegate = self;
    [self.view addSubview:_plateCollectionView];
    
    // 创建地点视图
    _zoneCollectionView = [[ZoneCollectionView alloc] initWithFrame:CGRectMake(0, IFindNavH - SCREENH*0.5, SCREENW, SCREENH*0.5) dataArr:_zoneDataArr cellClass:[ZoneCell class] reuseID:[ZoneCell identifier] bgColor:lightBlack collectionViewFrame:CGRectMake(SCREENW*11/80.0, 0, SCREENW - SCREENW*11/40.0, SCREENH*0.5 - Margin) lineAndItemSpace:CGSizeMake(SCREENW/16.0, SCREENW/16.0)];
    _zoneCollectionView.backgroundColor = lightBlack;
    _zoneCollectionView.alpha = 0.8;
    _zoneCollectionView.delegate = self;
    [self.view addSubview:_zoneCollectionView];
}

@end
