//
//  HomeViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "RecommendViewController.h"
#import "HomeCell.h"
#import "HomeModel.h"
#import "TopicModel.h"
#import "HeaderView.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    // 导航栏视图
    UIView *_headerView;
    UIView *_lineView;
    UILabel *_rightLabel;
    UILabel *_leftLabel;
    
    // 滚动视图
    UIScrollView *_scrollView;
    UITableView *_recommendTV;
    UITableView *_topicTV;
    
    // 数据源
    NSMutableArray *_recommendArr;
    NSMutableArray *_topicArr;
    
    // 网络错误图片
    UIView *_errorView;
    UILabel *_errorLabel;
    UIImageView *_errorIV;
    
    NSInteger recommendPageNo;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    UIView *view = [((TabBarController *)self.tabBarController) tabBarView];
//    
//    view.frame = CGRectMake(0, SCREENH - 49, SCREENW, 49);
//}

#pragma mark - 创建主页视图
- (void)createUI {
    
    // 创建头部视图
    if (_headerView == nil) {
        
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREENW, 64);
        _headerView.backgroundColor = lightBlack;
        [self.view addSubview:_headerView];
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.frame = CGRectMake(SCREENW/6.0, 20, SCREENW/3.0, 44);
        _leftLabel.text = @"推荐";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = Font(17);
        _leftLabel.textColor = lightBlue;
        [_headerView addSubview:_leftLabel];
        
        // 创建右侧label
        CGFloat mainMaxX = CGRectGetMaxX(_leftLabel.frame);
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.frame = CGRectMake(mainMaxX, 20, SCREENW/3.0, 44);
        _rightLabel.text = @"专题";
        _rightLabel.font = Font(17);
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:_rightLabel];
        
        // 创建手势
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftTap)];
        _leftLabel.userInteractionEnabled = YES;
        [_leftLabel addGestureRecognizer:leftTap];
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightTap)];
        _rightLabel.userInteractionEnabled = YES;
        [_rightLabel addGestureRecognizer:rightTap];
        
        // 头部视图的横线
        CGFloat leftX = SCREENW/6.0 + SCREENW/6.0 - 18;
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = lightBlue;
        _lineView.frame = CGRectMake(leftX, 62, 36, 2);
        [_headerView addSubview:_lineView];
        
        // 创建两个tableView，并放置在一个scrollView上
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64, SCREENW, SCREENH - 113);
        _scrollView.contentSize = CGSizeMake(SCREENW * 2, SCREENH - 113);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        
        // 设置代理，监听滚动事件
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        
        // 设置推荐视图tableView
        _recommendTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - 113) style:UITableViewStylePlain];
        _recommendTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _recommendTV.dataSource = self;
        _recommendTV.delegate = self;
        
        // 设置“推荐”的上拉和下拉刷新操作
        MJRefreshGifHeader *recommendHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
           
            // 请求第一页数据，并刷新
            [self requestDataForTableView:_recommendTV withPageNo:1];
            
            recommendPageNo = 2;
        }];
        
        // 设置Indicator样式
        [Tool setLoadingIndicatorStyle:recommendHeader];
        
        _recommendTV.header = recommendHeader;
        
        _recommendTV.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            // 请求下一页数据，并刷新
            [self requestDataForTableView:_recommendTV withPageNo:recommendPageNo];
            
            recommendPageNo++;
        }];
        
        // 按照图片尺寸设置图片大小，保证不同型号屏幕显示正常
        _recommendTV.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:_recommendTV];
        
        _topicTV = [[UITableView alloc] initWithFrame:CGRectMake(SCREENW, 0, SCREENW, SCREENH - 113 + 20) style:UITableViewStyleGrouped];
        _topicTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topicTV.sectionFooterHeight = 0;
        _topicTV.backgroundColor = [UIColor whiteColor];
        
        _topicTV.dataSource = self;
        _topicTV.delegate = self;
        
        // 设置“推荐”的上拉刷新操作
        MJRefreshGifHeader *topicHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            
            // 请求第一页数据，并刷新
            [self requestDataForTableView:_topicTV withPageNo:0];
        }];

        // 设置Indicator样式
        [Tool setLoadingIndicatorStyle:topicHeader];
        
        _topicTV.header = topicHeader;
        
        // 按照图片尺寸设置图片大小，保证不同型号屏幕显示正常
        _topicTV.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:_topicTV];
        
        // 网络错误视图
        _errorView = [[UIImageView alloc] init];
        _errorView.frame = CGRectMake(SCREENW * 0.2, (SCREENH - 64 - 49) / 2 - SCREENW*0.32, SCREENW * 0.6, SCREENW * 0.8);
        
        _errorIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW * 0.6, SCREENW * 0.6)];
        [_errorView addSubview:_errorIV];
        
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENW * 0.6, SCREENW * 0.6, SCREENW * 0.2) ];
        _errorLabel.font = Font(16);
        _errorLabel.textColor = lightGray;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        [_errorView addSubview:_errorLabel];
    }
}

#pragma mark - 初始化主页数据
- (void)initData {
    
    if (_recommendArr == nil) {
        
        // 初始化数据源数组
        _recommendArr = [NSMutableArray arrayWithCapacity:0];
        _topicArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    // 开启自动刷新
    [_recommendTV.header beginRefreshing];
}

#pragma mark - UITapGestureRecognizer方法
- (void)handleLeftTap {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // 设置滑块的坐标
        CGPoint center = _lineView.center;
        center.x = SCREENW/3.0;
        _lineView.center = center;
        
        // 改变字体颜色
        _rightLabel.textColor = [UIColor whiteColor];
        _leftLabel.textColor = lightBlue;
        
        // 改变ScrollView偏移值
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }];

}

- (void)handleRightTap {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // 设置滑块的坐标
        CGPoint center = _lineView.center;
        center.x = SCREENW*2/3.0;
        _lineView.center = center;
        
        // 改变字体颜色
        _leftLabel.textColor = [UIColor whiteColor];
        _rightLabel.textColor = lightBlue;
        
        // 改变ScrollView偏移值
        [_scrollView setContentOffset:CGPointMake(SCREENW, 0)];
    }];

}

#pragma mark - 请求网络数据
- (void)requestDataForTableView:(UITableView *)tableView withPageNo:(NSInteger)pageNo {
    
    // 设置请求参数
    NSDictionary *params = @{@"page_no" : [NSNumber numberWithInteger:pageNo]};
    
    NSString *urlStr;
    
    if (tableView == _recommendTV) {
        
        urlStr = http_of_recommend;
        
        // 网络错误信息
        _errorIV.image = [UIImage imageNamed:@"global_default_network_error"];
        _errorLabel.text = @"网络已失联";
    } else {
        
        urlStr = http_of_topic;
        
        // 专题栏没有参数
        params = nil;
        
        // 网络错误信息
        _errorIV.image = [UIImage imageNamed:@"global_default_only_wifi"];
        _errorLabel.text = @"网络出差到月球";
    }
    
    // 开始请求数据
    [Network requestForData:urlStr params:params successBlock:^(id data) {
        
        // 解析数据
        if (tableView == _recommendTV) {
            
            // 解析“推荐”数据
            // 当头部刷新时，清空数据源
            if (pageNo == 1) {
                [_recommendArr removeAllObjects];
            }
            
            NSArray *dataArr = data[@"rows"];
            
            for (NSDictionary *dict in dataArr) {
                
                // 利用字典给model赋值
                HomeModel *model = [[HomeModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                
                [_recommendArr addObject:model];
            }
        } else {
            
            // 解析“专题”数据
            // 当头部刷新时，清空数据源
            [_topicArr removeAllObjects];
            
            NSArray *allArr = data[@"topic_rows"];
            
            for (NSDictionary *allDict in allArr) {
                
                TopicModel *topicModel = [[TopicModel alloc] init];
                [topicModel setValuesForKeysWithDictionary:allDict];
                
                NSArray *dataArr = allDict[@"item_rows"];
                
                for (NSDictionary *dict in dataArr) {
                    
                    // 利用字典给model赋值
                    HomeModel *model = [[HomeModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    
                    [topicModel.homeModels addObject:model];
                }
                
                [_topicArr addObject:topicModel];
            }
        }
        
        _errorView.hidden = YES;
        
        [tableView.header endRefreshing];
        [tableView reloadData];
        [tableView.footer endRefreshing];
        
    } failBlcok:^(NSError *error) {

        [MBProgressHUD showError:@"网络错误"];
        
        // 添加网络错误视图
        [tableView addSubview:_errorView];
        
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
    }];
}

#pragma mark - UIScrollView的滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView != _scrollView) {
        return ;
    }
    
    // scrollView与滑块偏移值的比例为：SCREENW : SCREENW/3.0
    CGFloat xOffset = scrollView.contentOffset.x/3.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        // 设置滑块的坐标
        CGRect frame = _lineView.frame;
        frame.origin.x = SCREENW/6.0 + SCREENW/6.0 - 18 + xOffset;
        _lineView.frame = frame;
        
        //_lineView.frame = CGRectOffset(_lineView.frame, 1, 0);
        
        // 改变字体颜色
        if (scrollView.contentOffset.x >= SCREENW/2.0) {
            _leftLabel.textColor = [UIColor whiteColor];
            _rightLabel.textColor = lightBlue;
        } else {
            _rightLabel.textColor = [UIColor whiteColor];
            _leftLabel.textColor = lightBlue;
        }
    }];
    
    if (!_topicArr.count && _scrollView.contentOffset.x==SCREENW) {
        
        // 第一次进入主题页
        [_topicTV.header beginRefreshing];
    }
}

#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _recommendTV) {
        return 1;
    } else {
        return _topicArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 根据不同的tableView，返回不同的数组内容
    if (tableView == _recommendTV) {
        return _recommendArr.count;
    }
    
    // 每个section
    return ((TopicModel *)_topicArr[section]).homeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *homeCell = [HomeCell cellWithTableView:tableView];
    
    if (tableView == _recommendTV) {
        
        // 推荐tableView
        homeCell.homeModel = _recommendArr[indexPath.row];
    } else {
        
        homeCell.homeModel = ((TopicModel *)_topicArr[indexPath.section]).homeModels[indexPath.row];
    }
    
    return homeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return HomeCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _topicTV) {
        
        return SCREENW / 4.0;
    }
    
    return 0;
}

#pragma mark - 创建“专题”HeaderView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _topicTV) {
        
        HeaderView *headerView = [HeaderView headerViewWith:tableView];
        headerView.topicModel = _topicArr[section];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForSectionHeader)];
        [headerView addGestureRecognizer:tap];
        
        return headerView;
    }

    return nil;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    if (tableView == _recommendTV) {
        detailVC.homeModel = _recommendArr[indexPath.row];
    } else {
        detailVC.homeModel = ((TopicModel *)_topicArr[indexPath.section]).homeModels[indexPath.row];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tapForSectionHeader {
    
    RecommendViewController *recVC = [[RecommendViewController alloc] init];
    recVC.titleOfNav = @"";
}

@end
