//
//  WishDoViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "WishDoViewController.h"
#import "UserModel.h"
#import "UserCell.h"

@interface WishDoViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataArr;
}
@end

@implementation WishDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1. 设置导航栏
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, SCREENW, 64);
    
    // 展示颜色
    UIView *navBg = [[UIView alloc] init];
    navBg.frame = CGRectMake(0, 0, SCREENW, 64);
    navBg.alpha = 0.99;
    navBg.backgroundColor = lightBlack;
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
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.view addSubview:navView];
}

- (void)initData {
    
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *params = @{@"item_id" : _item_id};
    
    [MBProgressHUD showMessage:@"Loading" toView:nil pic:nil];
    
    [Network requestForData:_url params:params successBlock:^(id data) {
        
        [MBProgressHUD hideHUDForView:nil animated:YES];
        
        NSArray *rows = data[@"rows"];
        
        for (NSDictionary *dict in rows) {
            
            UserModel *model = [[UserModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            
            [_dataArr addObject:model];
        }
        
        [_tableView reloadData];
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
    } failBlcok:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:nil animated:YES];
        
        [MBProgressHUD showError:@"网络错误！"];
    }];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_dataArr.count == 0) {
        
        return 0;
    }
    
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil] lastObject];
    }
    
    cell.userModel = _dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 69.0;
}

@end
