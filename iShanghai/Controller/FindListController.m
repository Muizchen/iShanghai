//
//  FindListController.m
//  IntoSH
//
//  Created by qianfeng on 15/10/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "FindListController.h"
#import "DetailViewController.h"
#import "HomeCell.h"
#import "HomeModel.h"


@interface FindListController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSInteger _pageNum;
    UIButton *_selectedBtn;
}

@end

@implementation FindListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化数据
    [self initData];
    
    // 自定义导航栏
    [self createNav];
    
    [self loadDataWithPageNum:@"1" isRemoveAll:NO];
    
    // 创建页面
    [self createUI];
}

#pragma mark 初始化数据
- (void)initData
{
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _pageNum = 1;
    
    [_tableView.header beginRefreshing];
}

// 自定义导航栏
- (void)createNav
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 64)];
    navView.backgroundColor = lightBlack;
    [self.view addSubview:navView];
    
    // 返回按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Margin, 32, 24, 24)];
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btn];
    
    // 标题
    // 计算venue的宽度
    CGFloat labelWidth = [_listTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0f]} context:nil].size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, 25)];
    titleLabel.center = CGPointMake(SCREENW / 2, 20 + 22);
    titleLabel.text = _listTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [navView addSubview:titleLabel];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 网络请求数据
- (void)loadDataWithPageNum:(NSString *)page isRemoveAll:(BOOL)isRemoveAll
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:page, @"page_no", nil];
    [params addEntriesFromDictionary:_params];
    
    [Network requestForData:http_of_find_list params:params successBlock:^(id data) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        
        if (isRemoveAll) {
            [_dataArr removeAllObjects];
        }
        
        NSNumber *pageCount = data[@"page_count"];
        NSNumber *currentPage = data[@"current_page_no"];
        
        if (pageCount == currentPage) {
            
            _tableView.footer = nil;
        }
        
        NSArray *array = data[@"rows"];
        
        for (NSDictionary *dict in array) {
            
            HomeModel *model = [[HomeModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArr addObject:model];
        }
        [_tableView reloadData];

    } failBlcok:^(NSError *error) {
        
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
    }];
}

#pragma mark 创建页面
- (void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = HomeCellHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        
        _pageNum = 1;
        [self loadDataWithPageNum:@"1" isRemoveAll:YES];
        
    }];
    
    [Tool setLoadingIndicatorStyle:header];
    _tableView.header = header;
    
    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _pageNum ++;
        [self loadDataWithPageNum:[NSString stringWithFormat:@"%ld", (long)_pageNum] isRemoveAll:NO];
    }];
    
    NSArray *subPlates = _params[@"subPlates"];
    if (subPlates) {
        if (subPlates.count) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, 35)];
            view.backgroundColor = [UIColor colorWithRed:19 / 255.0f green:19 / 255.0f blue:19 / 255.0f alpha:1.0f];
            [self.view addSubview:view];
            
            // 修改tableView的frame
            _tableView.frame = CGRectMake(0, 64 + 35, SCREENW, SCREENH - 64 - 35);
            
            CGFloat btnW = SCREENW / 3.0f;
            
            for (int i = 0; i < subPlates.count; i ++) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnW * (i + 1), 0, btnW, 35)];
                [btn setTitleColor:[UIColor colorWithRed:96 / 255.0f green:96 / 255.0f blue:96 / 255.0f alpha:1.0f] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitle:subPlates[i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                if (i == 0) {
                    [self btnClick:btn];
                }
                else if (i == subPlates.count - 1) {
                    btn.frame = CGRectMake(0, 0, btnW, 35);
                }
                else if (i == subPlates.count - 2) {
                    btn.frame = CGRectMake(-btnW, 0, btnW, 35);
                }
            }
        }
    }
}

#pragma mark 按钮点击
- (void)btnClick:(UIButton *)btn
{
    // 按钮选中
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    
    // 动画效果实现按钮移动
    
    
}


#pragma mark - UITableView 代理和数据源
#pragma mark 项数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [HomeCell cellWithTableView:tableView];
    cell.homeModel = _dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    detailVC.homeModel = _dataArr[indexPath.row];

    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
