//
//  LinkViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/20.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "LinkViewController.h"

@interface LinkViewController () <UIWebViewDelegate>
{
    UIActivityIndicatorView *_activityIndicatorView;
    
    UIWebView *_webView;
}
@end

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

- (void)creatUI {
    
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

    // UIWebView
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, SCREENW, SCREENH - 44)];
    [self.view addSubview:_webView];
    
    [self httpRequest];
    
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [_activityIndicatorView setCenter:self.view.center];
    [_activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:_activityIndicatorView];
    
    [self.view addSubview:navView];
}

- (void)httpRequest {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_link] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    [_webView loadRequest:request];
}

#pragma mark - UIWebView代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    //[_activityIndicatorView startAnimating] ;
    [MBProgressHUD showMessage:@"正在加载..." toView:nil pic:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [MBProgressHUD hideHUDForView:nil animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    DEBUGLog(@"Error:%@", error.localizedDescription);
    [MBProgressHUD showError:@"获取内容失败..."];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
