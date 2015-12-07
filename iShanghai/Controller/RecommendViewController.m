//
//  RecommendViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "RecommendViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"
#import "HomeModel.h"
#import "HomeCell.h"

@interface RecommendViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    
    NSInteger _maxPage;
    
    UITableView *_tableView;
    
    NSInteger _pageNo;
}
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    // 1. 设置导航栏
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, SCREENW, 64);
    [self.view addSubview:navView];
    
    // 展示颜色
    UIView *navBg = [[UIView alloc] init];
    navBg.frame = CGRectMake(0, 0, SCREENW, 64);
    navBg.backgroundColor = lightBlack;
    navView.alpha = 0.99;
    [navView addSubview:navBg];
    
    // 2. 返回按钮
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.frame = CGRectMake(Margin, 30, 24, 24);
    [backBtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    // 3. 标题
    UILabel *title = [[UILabel alloc] init];
    title.font = FontWithWeight(16, 16);
    title.text = _titleOfNav;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(2*Margin + 20, 20, SCREENW - 4*Margin - 40, 44);
    [navView addSubview:title];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREENW, SCREENH - 44) style:UITableViewStylePlain];
    [self.view insertSubview:_tableView belowSubview:navView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = HomeCellHeight;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    // 设置上拉和下拉刷新操作
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        // 请求第一页数据，并刷新
        [self requestDataWithPageNo:1];
        
        _pageNo = 2;
    }];
    
    // 设置Indicator样式
    [Tool setLoadingIndicatorStyle:header];
    
    _tableView.header = header;
    
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (_pageNo <= _maxPage) {
            
            // 请求下一页数据，并刷新
            [self requestDataWithPageNo:_pageNo];
            
            _pageNo++;
        } else {
            
            [_tableView.footer endRefreshing];
        }
    }];
    
    // 按照图片尺寸设置图片大小，保证不同型号屏幕显示正常
    _tableView.showsVerticalScrollIndicator = NO;
}

- (void)initData {
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [_tableView.header beginRefreshing];
    
    _pageNo = 2;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestDataWithPageNo:(NSInteger)pageNo {
    
    NSDictionary *params = @{@"item_id" : _item_id,
                             @"page_no" : [NSNumber numberWithInteger:pageNo]};
    
    [Network requestForData:http_of_similar params:params successBlock:^(id data) {
        
        _maxPage = [data[@"page_count"] integerValue];
        
        NSArray *rows = data[@"rows"];
        
        for (NSInteger i = 0; i < rows.count; i++) {
            
            HomeModel *model = [[HomeModel alloc] init];
            [model setValuesForKeysWithDictionary:rows[i]];
            
            [_dataArr addObject:model];
        }
        
        [_tableView.header endRefreshing];
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
        
    } failBlcok:^(NSError *error) {
        
        DEBUGLog(@"Error:%@", error.localizedDescription);
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];

}

#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArr.count == 0) {
        
        return 0;
    }
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [HomeCell cellWithTableView:_tableView];
    
    cell.homeModel = _dataArr[indexPath.row];
    
    return cell;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.homeModel = _dataArr[indexPath.row];

    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

@end
