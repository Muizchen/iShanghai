//
//  LoginViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "TabBarController.h"
#import "UserModel.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    UITextField *_phone;
    
    UITextField *_password;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI {
    
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
    title.text = @"登录";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(2*Margin + 80, 20, SCREENW - 4*Margin - 160, 44);
    [navView addSubview:title];
    
    // 4. 注册按钮
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.frame = CGRectMake(SCREENW - Margin - 44, 20, 44, 44);
    registerBtn.titleLabel.textColor = [UIColor whiteColor];
    registerBtn.titleLabel.font = Font(15);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:registerBtn];
    
    // 4.
    _phone = [UITextField initWithFrame:CGRectMake(2*Margin, 64 + 2*Margin, SCREENW - 4*Margin, 35) placeholder:@"手机号" font:15 leftSpace:Margin rightSpace:Margin];
    _phone.layer.borderColor = lightGray.CGColor;
    _phone.layer.borderWidth = 1;
    _phone.text = @"13611965604";
    _phone.delegate = self;
    _phone.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phone];
    
    CGFloat phoneMaxY = CGRectGetMaxY(_phone.frame);
    _password = [UITextField initWithFrame:CGRectMake(2*Margin, phoneMaxY + 2*Margin, SCREENW - 4*Margin, 35) placeholder:@"密码" font:15 leftSpace:Margin rightSpace:Margin];
    _password.layer.borderColor = lightGray.CGColor;
    _password.layer.borderWidth = 1;
    _password.text = @"4681050";
    _password.secureTextEntry=YES;
    _password.delegate = self;
    [self.view addSubview:_password];
    
    CGFloat passWordMaxY = CGRectGetMaxY(_password.frame);
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*Margin, passWordMaxY + 2*Margin, SCREENW - 4*Margin, 35)];
    [loginBtn setBackgroundColor:lightBlue];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font(15);
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

#pragma mark - 登录
- (void)login {
    
    if ([_phone.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"电话不能为空"];
        return;
    } else if ([_password.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }

    NSDictionary *params = @{@"code" : @"",
                             @"mobile" : _phone.text,
                             @"password" : _password.text};
    
    //[MBProgressHUD showSuccess:@"登录中"];
    
    [Network requestForData:http_of_login params:params successBlock:^(id data) {
        
        // 登录失败
        if ([data[@"error"] integerValue] != 0) {
            
            [MBProgressHUD showError:data[@"message"]];
        } else {
            
            //[MBProgressHUD showSuccess:@"登录成功"];
            
            UserModel *model = [[UserModel alloc] init];
            [model setValuesForKeysWithDictionary:data[@"profile"]];
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            app.userModel = model;
            
            [self back];
        }
        
    } failBlcok:^(NSError *error) {
        
        DEBUGLog(@"Login Error:%@", error.localizedDescription);
        [MBProgressHUD showError:@"网络错误！"];
    }];
}

#pragma mark - 注册
- (void)registerAccount {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
