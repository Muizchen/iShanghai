//
//  LoginViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/21.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "RegisterViewController.h"
#import "TabBarController.h"
#import "UserModel.h"

@interface RegisterViewController () <UITextFieldDelegate>
{
    UITextField *_nickName;
    
    UITextField *_phone;
    
    UITextField *_authCode;
    
    UITextField *_password;
    
    UITextField *_confiremPassword;
    
    // 自定义队列
    dispatch_queue_t _mainQueue;
    dispatch_queue_t _globleQueue;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

#pragma mark - 创建界面
- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    title.text = @"注册";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(2*Margin + 20, 20, SCREENW - 4*Margin - 40, 44);
    [navView addSubview:title];
    
    // 4.
    CGFloat phoneWidth = (SCREENW - 5*Margin) * 0.6;
    _nickName = [UITextField initWithFrame:CGRectMake(2*Margin, 64 + 2*Margin, phoneWidth, 30) placeholder:@"昵称" font:15 leftSpace:Margin rightSpace:Margin];
    _nickName.layer.borderColor = lightGray.CGColor;
    _nickName.layer.borderWidth = 1;
    _nickName.delegate = self;
    [self.view addSubview:_nickName];
    
    // 电话
    CGFloat nickMaxY = CGRectGetMaxY(_nickName.frame);
    _phone = [UITextField initWithFrame:CGRectMake(2*Margin, nickMaxY + Margin, phoneWidth, 30) placeholder:@"手机号" font:15 leftSpace:Margin rightSpace:Margin];
    _phone.layer.borderColor = lightGray.CGColor;
    _phone.layer.borderWidth = 1;
    _phone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _phone.delegate = self;
    [self.view addSubview:_phone];
    
    // 验证码
    CGFloat phoneMaxY = CGRectGetMaxY(_phone.frame);
    _authCode = [UITextField initWithFrame:CGRectMake(2*Margin, phoneMaxY + Margin, phoneWidth, 30) placeholder:@"验证码" font:15 leftSpace:Margin rightSpace:Margin];
    _authCode.layer.borderColor = lightGray.CGColor;
    _authCode.layer.borderWidth = 1;
    _authCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _authCode.delegate = self;
    [self.view addSubview:_authCode];
    
    CGFloat authMaxX = CGRectGetMaxX(_authCode.frame);
    UIButton *getAuthCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getAuthCodeBtn.frame = CGRectMake(authMaxX + Margin, phoneMaxY + Margin, phoneWidth*4/6.0, 30);
    [getAuthCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [getAuthCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getAuthCodeBtn setBackgroundColor:lightGray];
    getAuthCodeBtn.titleLabel.font = Font(13);
    [getAuthCodeBtn addTarget:self action:@selector(getAuthCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getAuthCodeBtn];
    
    // 密码
    CGFloat authMaxY = CGRectGetMaxY(_authCode.frame);
    _password = [UITextField initWithFrame:CGRectMake(2*Margin, authMaxY + Margin, SCREENW - 4*Margin, 30) placeholder:@"密码" font:15 leftSpace:Margin rightSpace:Margin];
    _password.layer.borderColor = lightGray.CGColor;
    _password.layer.borderWidth = 1;
    _password.secureTextEntry = YES;
    _password.delegate = self;
    [self.view addSubview:_password];
    
    // 再次确认密码
    CGFloat passwordMaxY = CGRectGetMaxY(_password.frame);
    _confiremPassword = [UITextField initWithFrame:CGRectMake(2*Margin, passwordMaxY + Margin, SCREENW - 4*Margin, 30) placeholder:@"再次确认密码" font:15 leftSpace:Margin rightSpace:Margin];
    _confiremPassword.layer.borderColor = lightGray.CGColor;
    _confiremPassword.layer.borderWidth = 1;
    _confiremPassword.secureTextEntry = YES;
    _confiremPassword.delegate = self;
    [self.view addSubview:_confiremPassword];
    
    CGFloat confirmMaxY = CGRectGetMaxY(_confiremPassword.frame);
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*Margin, confirmMaxY + Margin, SCREENW - 4*Margin, 30)];
    [registerBtn setBackgroundColor:lightBlue];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = Font(15);
    [registerBtn addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)initData {
    
    _mainQueue = dispatch_get_main_queue();
    
    _globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

#pragma mark - 登录
- (void)registerAccount {

    if ([_nickName.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"用户名不能为空"];
        return;
    } else if ([_phone.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"电话不能为空"];
        return;
    } else if ([_password.text isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    } else if (_password.text.length < 6) {
        
        [MBProgressHUD showError:@"密码不足6位"];
        return;
    } else if (![_password.text isEqualToString:_confiremPassword.text]) {
        
        [MBProgressHUD showError:@"两次密码不相同"];
        return;
    }
    
    NSDictionary *params = @{@"gender" : @"",
                             @"mobile" : _phone.text,
                             @"mobileCode" : _authCode.text,
                             @"name" : _nickName.text,
                             @"password" : _password.text};
    
    [Network requestForData:http_of_register params:params successBlock:^(id data) {
        
        if ([data[@"error"] integerValue] != 0) {
            
            [MBProgressHUD showError:data[@"message"]];
        } else {
            
            [MBProgressHUD showSuccess:@"注册成功"];
            
            UserModel *model = [[UserModel alloc] init];
            [model setValuesForKeysWithDictionary:data[@"profile"]];
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            app.userModel = model;
            
            [self back];
        }
        
    } failBlcok:^(NSError *error) {
        
        DEBUGLog(@"Login Error:%@", error.localizedDescription);
        [MBProgressHUD showError:@"网络故障o(`· ~ ·′)o"];
    }];
}

#pragma mark - 获取验证码
- (void)getAuthCode:(UIButton *)sender {
    
    if ([_phone.text isEqualToString:@""] || _phone.text.length!=11) {
        
        [MBProgressHUD showError:@"手机号码不正确"];
        return;
    }
    
    // 开始接收验证码
    sender.enabled = NO;
    
    NSDictionary *params = @{@"mobile" : _phone.text};
    
    [Network requestForData:http_of_auth_code params:params successBlock:^(id data) {
        
        if ([data[@"error"] integerValue] != 0) {
            
            [MBProgressHUD showError:data[@"message"]];
            sender.enabled = YES;
        } else {
            
            [self authCodeTicking:sender];
        }
    } failBlcok:^(NSError *error) {
       
        sender.enabled = YES;
        [MBProgressHUD showError:@"网络故障o(╯□╰)o"];
    }];
}

#pragma mark - 开始倒计时，接收短信验证码
- (void)authCodeTicking:(UIButton *)sender {
    
    // 开启子线程
    dispatch_async(_globleQueue, ^{
        
        for (NSInteger i = 60 ; i >= 0 ; i--) {
            
            // 刷新UI的操作只能在主线程
            dispatch_async(_mainQueue, ^{
                
                NSString *str = [NSString stringWithFormat:@"剩余%lu秒", (long)i];
                [sender setTitle:str forState:UIControlStateNormal];
                
                if (i == 0) {
                    
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.enabled = YES;
                }
            });
            
            [NSThread sleepForTimeInterval:1.0f];
        }
    });
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 监听方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
