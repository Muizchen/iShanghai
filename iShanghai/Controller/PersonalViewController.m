//
//  PersonalViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "DetailViewController.h"
#import "UserModel.h"
#import "HomeModel.h"
#import "HomeCell.h"
#import "PersonalSectionHeader.h"

@interface PersonalViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    UIView *_settingView;
    
    UIWindow *_window;
    
    UIImageView *_bgIV;
    
    // 导航栏标题
    UILabel *_title;
    
    // 关注
    NSMutableArray *_userArr;
    NSMutableArray *_dataArr;
    
    UIImageView *_avatar;
    
    // sectionHeader
    PersonalSectionHeader *_sectionHeader;
    
    // 判断是“人物信息”还是“活动信息”
    BOOL _isUser;
    
    // 用户个人信息
    UserModel *_userModel;
}

@property (nonatomic, strong) UITableView *userProfile;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBarHidden = NO;
    
    // 设置用户账户信息
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    _userModel = app.userModel;

    if (_userModel == nil) {
        
        _bgIV.hidden = NO;
        _userProfile.hidden = YES;
        _title.text = @"个人中心";
        
    } else {
        
        // 创建tableView
        if (_userProfile == nil) {
            
            // 为什么要加40，不懂
            _userProfile = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - 64) style:UITableViewStyleGrouped];
            _userProfile.showsVerticalScrollIndicator = NO;
            
            _userProfile.delegate = self;
            _userProfile.dataSource = self;
            [self.view addSubview:_userProfile];
            
            // 创建header
            _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
            _avatar.layer.cornerRadius = 40;
            _avatar.clipsToBounds = YES;
            
            UIImageView *tableHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENW * (152 / 320.0))];
            _avatar.center = tableHeader.center;
            tableHeader.image = Image(@"personalPage_backView");
            [tableHeader addSubview:_avatar];
            
            _userProfile.tableHeaderView = tableHeader;
        }
        
        _bgIV.hidden = YES;
        _userProfile.hidden = NO;
        _title.text = _userModel.name;
        
        // 设置用户数据
        [_avatar setImageWithURL:[NSURL URLWithString:_userModel.avatar]];
        
        [self resetSectionHeader];
        
        // 加载关注数据
        [self requestUserData:http_of_my_following];
        _isUser = YES;
    }
}

- (void)createUI {    
    
    // 设置登陆背景图片
    _bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    NSString *imgName = [NSString stringWithFormat:@"photograph%i", arc4random()%2];
    _bgIV.image = Image(imgName);
    _bgIV.userInteractionEnabled = YES;
    [self.view addSubview:_bgIV];
    
    // 登陆按钮
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.frame = CGRectMake(SCREENW*0.35, (SCREENH - 64 - 49 - SCREENW*0.3) / 2.0, SCREENW*0.3, SCREENW*0.3);
    [loginBtn setBackgroundImage:Image(@"personpage_loginbutton") forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [_bgIV addSubview:loginBtn];
    
    // 侧边栏
    _window = [[UIApplication sharedApplication].windows lastObject];
    
    _settingView = [[UIView alloc] init];
    _settingView.frame = CGRectMake(0 - SCREENW, 0, SCREENW, SCREENH);
    [_window addSubview:_settingView];
    
    UIView *layer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW*0.8, SCREENH)];
    layer.backgroundColor = lightBlack;
    [_settingView addSubview:layer];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENW - 40, 27, 20, 20)];
    [btn setBackgroundImage:Image(@"personalpage_settingbtn") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideSideBar) forControlEvents:UIControlEventTouchUpInside];
    [_settingView addSubview:btn];
    
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
    
    // 2. 注销按钮
    UIButton *logoutBtn = [[UIButton alloc] init];
    logoutBtn.frame = CGRectMake(Margin, 32, 20, 20);
    [logoutBtn setBackgroundImage:Image(@"logout") forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:logoutBtn];
    
    // 3. 标题
    _title = [[UILabel alloc] init];
    _title.font = FontWithWeight(16, 16);
    _title.text = @"登录";
    _title.textColor = [UIColor whiteColor];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.frame = CGRectMake(2*Margin + 20, 20, SCREENW - 4*Margin - 40, 44);
    [navView addSubview:_title];
}

- (void)initData {
    
    _userArr = [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - 请求用户信息
- (void)requestUserData:(NSString *)url {
    
    [MBProgressHUD showSuccess:@"加载中"];
    
    // 请求“关注&粉丝”数据
    NSDictionary *params = @{@"page_no" : @"1",
                             @"member_id=" : @""};

    [Network requestForData:url params:params successBlock:^(id data) {
        
        // 清空数据
        [_userArr removeAllObjects];
        
        NSArray *rows = data[@"rows"];

        for (NSDictionary *dict in rows) {
            UserModel *model = [[UserModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_userArr addObject:model];
        }
        [_userProfile reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        // 重新设置sectionHeader的内容
        [self resetSectionHeader];
        
    } failBlcok:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

#pragma mark - 请求活动信息
- (void)requestActivityData:(NSString *)url {
    
    [MBProgressHUD showSuccess:@"加载中"];
    
    // 请求“想去&去过”数据
    NSDictionary *params = @{@"page_no" : @"1",
                             @"member_id=" : @""};
    
    [Network requestForData:url params:params successBlock:^(id data) {
        
        // 清空数据
        [_dataArr removeAllObjects];
        
        NSArray *rows = data[@"rows"];
        
        for (NSDictionary *dict in rows) {
            HomeModel *model = [[HomeModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_dataArr addObject:model];
        }
        
        [_userProfile reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        // 重新设置sectionHeader的内容
        [self resetSectionHeader];
        
    } failBlcok:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络错误!"];
    }];
}

#pragma mark - TabelView刷新后头部视图也会被刷新
- (void)resetSectionHeader {
    
    // 请求个人主页数据
    [Network requestForData:http_of_profile params:nil successBlock:^(id data) {
        
        [_userModel setValuesForKeysWithDictionary:data[@"profile"]];
        
        _sectionHeader.following_num.text = _userModel.following_num;
        _sectionHeader.fans_num.text = _userModel.fans_num;
        _sectionHeader.wish_num.text = _userModel.wish_num;
        _sectionHeader.do_num.text = _userModel.do_num;
        
    } failBlcok:^(NSError *error) {
        
        // 啥也不干
    }];
}

#pragma mark - 登陆
- (void)login {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - 系统设置按钮
- (void)logout {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
  
    if (app.userModel == nil) {
        
        [MBProgressHUD showError:@"至少先登录吧，喂！"];
    } else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确认注销？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }
}

- (void)hideSideBar {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _window.frame = CGRectOffset(_window.frame, 0 - SCREENW*0.8, 0);
    }];
}

#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isUser) {
        
        return _userArr.count;
    }
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isUser) {
        
        static NSString *ID = @"following";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        // 设置样式
        cell.textLabel.text = ((UserModel *)_userArr[indexPath.row]).name;
        cell.textLabel.font = Font(15);
        cell.textLabel.textColor = lightBlack;
        
        [cell.imageView setImageWithURL:[NSURL URLWithString:((UserModel *)_userArr[indexPath.row]).avatar]];
        
        // 修改图片大小
        CGSize itemSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        cell.imageView.layer.cornerRadius = 15;
        cell.imageView.clipsToBounds = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    } else {
        
        HomeCell *cell = [HomeCell cellWithTableView:tableView];
        cell.homeModel = _dataArr[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isUser) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.homeModel = _dataArr[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isUser) {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 44;
    } else {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return HomeCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREENW / 6.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _sectionHeader = [[PersonalSectionHeader alloc] init];
    
    // 给View中的按钮绑定事件
    [_sectionHeader.followingBtn addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeader.fansBtn addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeader.wishBtn addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeader.doBtn addTarget:self action:@selector(changeTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self resetSectionHeader];
    
    return _sectionHeader;
}

#pragma mark - 改变用户TableView显示的内容
- (void)changeTableView:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        
        [self requestUserData:http_of_my_following];
        _isUser = YES;
    } else if ([sender.titleLabel.text isEqualToString:@"粉丝"]) {
        
        [self requestUserData:http_of_my_fans];
        _isUser = YES;
    } else if ([sender.titleLabel.text isEqualToString:@"想去"]) {
        
        [self requestActivityData:http_of_my_wish];
        _isUser = NO;
    } else {
        
        [self requestActivityData:http_of_my_do];
        _isUser = NO;
    }
}

#pragma mark - UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        // 确认注销
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.userModel = nil;
        
        [UIView animateWithDuration:0.5 animations:^{
            _bgIV.hidden = NO;
            _userProfile.hidden = YES;
        }];
    }
}

@end
