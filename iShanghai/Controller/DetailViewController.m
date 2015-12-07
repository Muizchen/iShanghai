//
//  DetailViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeModel.h"
#import "DetailModel.h"
#import "LinkViewController.h"
#import "TabBarController.h"
#import "WishDoViewController.h"
#import "RecommendViewController.h"
#import "LoginViewController.h"
#import "MapViewController.h"

@interface DetailViewController () <UIScrollViewDelegate>
{
    // 自定义导航栏
    UIView *_navView;
    UIButton *_backBtn;
    
    // 滚动图片
    UIScrollView *_picScrView;
    UILabel *_picIndicator;
    UIButton *_wishBtn;
    UIButton *_doBtn;
    
    UIScrollView *_contentScrView;
    
    // 内容视图
    UIView *_contentView;
    
    // 标签
    UILabel *_tagLabel;
    
    // 标题
    UILabel *_titleLabel;
    
    // 地址
    UIButton *_addressBtn;
    UILabel *_venue;
    UILabel *_address;
    
    // 时间表
    UIImageView *_time;
    
    // 详细
    UIView *_detailView;
    
    DetailModel *_model;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    UIView *view = [((TabBarController *)self.tabBarController) tabBarView];
//    
//    view.frame = CGRectMake(0, SCREENH, SCREENW, 49);
//}

//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [super viewWillDisappear:animated];
//    
//    UIView *view = [((TabBarController *)self.tabBarController) tabBarView];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        
//        view.frame = CGRectOffset(view.frame, 0, -49);
//    }];
//}

#pragma mark - 创建视图
- (void)createUI {
    
    if (_picScrView == nil) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        // 1. 创建“详情”内容视图
        _contentScrView = [[UIScrollView alloc] init];
        _contentScrView.frame = CGRectMake(0, 0, SCREENW, SCREENH);
        _contentScrView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_contentScrView];

        // 2. 创建轮播图片
        _picScrView  = [[UIScrollView alloc] init];
        _picScrView.frame = CGRectMake(0, -20, SCREENW, HomeCellHeight);
        _picScrView.showsHorizontalScrollIndicator = NO;
        _picScrView.pagingEnabled = YES;
        _picScrView.bounces = NO;
        [_contentScrView addSubview:_picScrView];
        
        // 3. 设置导航栏，放置在最后，以保证ScrollView在底下不会遮挡掉
        UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 64)];
        [self.view addSubview:navView];
        
        // 展示颜色
        _navView = [[UIView alloc] init];
        _navView.frame = CGRectMake(0, 0, SCREENW, 64);
        _navView.alpha = 0;
        _navView.backgroundColor = lightBlack;
        [navView addSubview:_navView];
        
        // 3.1 返回按钮
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(Margin, 30, 24, 24);
        [_backBtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:_backBtn];
        
        // 3.2 去过
        _doBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENW - 2*Margin - 24, 30, 24, 24)];
        [_doBtn setTitle:@"没去过" forState:UIControlStateNormal];
        [_doBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [navView addSubview:_doBtn];
        
        // 3.3 想去
        CGFloat doMinX = CGRectGetMinX(_doBtn.frame);
        _wishBtn = [[UIButton alloc] initWithFrame:CGRectMake(doMinX - Margin - 24, 30, 24, 24)];
        [_wishBtn setTitle:@"不想去" forState:UIControlStateNormal];
        [_wishBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [navView addSubview:_wishBtn];
        
        // 轮播图片的第一张图片
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, HomeCellHeight)];
        
        // 设置轮播图片来源
        [imgV setImageWithURL:[NSURL URLWithString:_homeModel.image]];

        // 增加遮罩
        UIImageView *layerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, HomeCellHeight)];
        layerView.image = Image(@"detailPage_layerView");
        [imgV addSubview:layerView];
        [_picScrView addSubview:imgV];
        
        // 4. 创建内容UIView，以便图片放大时重设UIview的frame
        _contentView = [[UIView alloc] init];
        
        CGFloat picMaxY = CGRectGetMaxY(_picScrView.frame);
        _contentView.frame = CGRectMake(0, picMaxY, SCREENW, SCREENH - 49 + HomeCellHeight);
        [_contentScrView addSubview:_contentView];
        
        // 4.1 创建标签
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.frame = CGRectMake(2*Margin, 2*Margin, 80, SmallText);
        _tagLabel.font = FontWithWeight(SmallText, SmallText);
        _tagLabel.textColor = lightBlue;
        _tagLabel.text = _homeModel.help_tags;
        [_contentView addSubview:_tagLabel];
        
        // 4.2 创建标题
        CGFloat tagMaxY = CGRectGetMaxY(_tagLabel.frame);
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = _homeModel.title;
        _titleLabel.font = FontWithWeight(24, 20);
        _titleLabel.textColor = fontBlack;
        _titleLabel.numberOfLines = 0;
        
        // 计算“标题”高度
        CGFloat titleHeight = [_titleLabel boundingRectWithSize:CGSizeMake(SCREENW - 4*Margin, MAXFLOAT)].height;
        _titleLabel.frame = CGRectMake(2*Margin, tagMaxY + Margin, SCREENW - 4*Margin, titleHeight);
        [_contentView addSubview:_titleLabel];

        // venue和address
        CGFloat titleMaxY = CGRectGetMaxY(_titleLabel.frame);
        
        _addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, titleMaxY + 2*Margin, SCREENW, 59)];
        [_addressBtn addTarget:self action:@selector(openMap) forControlEvents:UIControlEventTouchUpInside];
        _addressBtn.hidden = YES;
        [_contentView addSubview:_addressBtn];
        
        UIImageView *redPin = [[UIImageView alloc] init];
        redPin.image = Image(@"addresspage_mapimage");
        redPin.frame = CGRectMake(2*Margin, 0, 18, 18);
        [_addressBtn addSubview:redPin];
        
        UIImageView *arrowIndicator = [[UIImageView alloc] init];
        arrowIndicator.frame = CGRectMake(SCREENW - 2*Margin - 20, 22, 20, 20);
        arrowIndicator.image = Image(@"go");
        [_addressBtn addSubview:arrowIndicator];
        
        // 地址文字
        _venue = [[UILabel alloc] initWithFrame:CGRectMake(20 + 2*Margin, 0, SCREENW - 4*Margin - 43, 18)];
        _venue.textColor = fontBlack;
        _venue.font = Font(18);
        [_addressBtn addSubview:_venue];
        
        _address = [[UILabel alloc] initWithFrame:CGRectMake(20 + 2*Margin, 18, SCREENW - 4*Margin - 63, SmallText*2 + 10)];
        _address.font = Font(14);
        _address.textColor = fontBlack;
        _address.numberOfLines = 0;
        [_addressBtn addSubview:_address];
    }
}

#pragma mark - 打开地图
- (void)openMap {
    
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.model = _model;
    
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 设置Scroll监听
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 将代理写在此处，为了页面显示前不会额外监听两次Scroll事件
    _contentScrView.delegate = self;
}

#pragma mark - 返回上一级
- (void)back {
    
    _contentScrView.delegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化数据
- (void)initData {

    NSDictionary *params = @{@"item_id" : _homeModel.item_id};
    
    [Network requestForData:http_of_detail params:params successBlock:^(id data) {
        
        // 解析“详情”页数据
        _model = [[DetailModel alloc] init];
        [_model setValuesForKeysWithDictionary:data];
        
        [_model setValuesForKeysWithDictionary:data[@"row"]];
        
        [self setModel:_model];
        
    } failBlcok:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络已失联"];
    }];
}

#pragma mark - 根据数据动态创建内容视图
- (void)setModel:(DetailModel *)detailModel {
    
    // 1. 插入轮播图片
    for (int i = 1; i < detailModel.images.count; i++) {
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREENW, 0, SCREENW, HomeCellHeight)];
        
        // 设置轮播图片来源
        [imgV setImageWithURL:[NSURL URLWithString:detailModel.images[i]]];
        
        // 增加遮罩
        UIImageView *layerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, HomeCellHeight)];
        layerView.image = Image(@"detailPage_layerView");
        
        [imgV addSubview:layerView];
        
        [_picScrView addSubview:imgV];
    }
    
    _picIndicator = [[UILabel alloc] init];
    _picIndicator.frame = CGRectMake(SCREENW - 100, 0 - 35, 80, 25);
    _picIndicator.font = Font(13);
    _picIndicator.textColor = [UIColor whiteColor];
    _picIndicator.textAlignment = NSTextAlignmentRight;
    _picIndicator.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)detailModel.images.count];
    [_contentView addSubview:_picIndicator];
    
    // 等数据全加载完成，再设置代理
    _picScrView.delegate = self;
    
    // 动态设置轮播内容大小
    _picScrView.contentSize = CGSizeMake(detailModel.images.count * SCREENW, HomeCellHeight);
    
    // 1.1 想去&去过
    if ([detailModel.isDo integerValue] == 1) {
        [_doBtn setBackgroundImage:Image(@"rootpage_togobutton_down") forState:UIControlStateNormal];
    } else {
        [_doBtn setBackgroundImage:Image(@"rootpage_togobutton_up") forState:UIControlStateNormal];
    }
    
    if ([detailModel.isWish integerValue] == 1) {
        [_wishBtn setBackgroundImage:Image(@"rootpage_wanttogobutton_down") forState:UIControlStateNormal];
    } else {
        [_wishBtn setBackgroundImage:Image(@"rootpage_wanttogobutton_up") forState:UIControlStateNormal];
    }
    
    [_doBtn addTarget:self action:@selector(setDo:) forControlEvents:UIControlEventTouchUpInside];
    [_wishBtn addTarget:self action:@selector(setWish:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2. venue和address
    _addressBtn.hidden = NO;
    _venue.text = detailModel.venue;
    _address.text = detailModel.address;

    // 3. 优惠信息（按钮，可以点击跳转至链接）
    CGFloat addressMaxY = CGRectGetMaxY(_addressBtn.frame);
    CGFloat dealMaxY = addressMaxY;
    for (NSInteger i = 0; i < detailModel.deal_rows.count; i++) {
        
        UIButton *dealBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, addressMaxY + Margin + i*57, SCREENW, 57)];
        dealBtn.tag = 300 + i;
        [dealBtn setBackgroundColor:btnGray];
        [_contentView addSubview:dealBtn];
        
        [dealBtn addTarget:self action:@selector(gotoLink:) forControlEvents:UIControlEventTouchUpInside];
        
        // 来自标签
        UILabel *from = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin, 12, SCREENW - 4*Margin - 30, 13)];
        from.font = Font(13);
        from.textColor = fontYellow;
        from.text = [NSString stringWithFormat:@"来自%@", detailModel.deal_rows[i][@"from"]];
        [dealBtn addSubview:from];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin, 25, SCREENW - 4*Margin - 30, 32)];
        title.font = Font(SmallText);
        title.textColor = fontBlack;
        title.text = detailModel.deal_rows[i][@"title"];
        [dealBtn addSubview:title];
        
        UIImageView *arrowIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW - 2*Margin - 20, 20, 20, 20)];
        arrowIndicator.image = Image(@"go");
        [dealBtn addSubview:arrowIndicator];
        
        // 根据创建的btn更改maxY值
        dealMaxY = CGRectGetMaxY(dealBtn.frame);
    }
    
    // 4. 详情
    if (detailModel.review_rows.count > 0) {
        
        // into:
        UIImageView *into = [[UIImageView alloc] initWithFrame:CGRectMake(2*Margin, dealMaxY + 2*Margin, 54, 22.5)];
        into.image = Image(@"intoLabelView");
        [_contentView addSubview:into];
        
        UILabel *review = [[UILabel alloc] init];
        
        review.text = detailModel.review_rows[0][@"content"];
        review.textColor = fontBlack;
        review.font = Font(15);
        review.numberOfLines = 0;
        
        review.frame = CGRectMake(2*Margin, dealMaxY + 2*Margin + 30, SCREENW - 4*Margin, 70);
        [_contentView addSubview:review];
        
        // 如果创建了Reviewlabel
        dealMaxY = CGRectGetMaxY(review.frame);
        
        UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*Margin, dealMaxY + Margin, 60, 30)];
        [detailBtn setTitle:@"详细" forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [detailBtn setBackgroundColor:lightBlue];
        detailBtn.titleLabel.font = Font(15);
        [detailBtn addTarget:self action:@selector(detailOfReview) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:detailBtn];
        
        dealMaxY = dealMaxY + Margin + 40;
    }

    // 5. 时间表
    UIImageView *time = [[UIImageView alloc] init];
    time.frame = CGRectMake(0, dealMaxY + Margin, SCREENW - 4 *Margin, 0);
    
    CGFloat timeTop = 0.0;
    
    // 5.1 日期
    if (![detailModel.time_string isEqualToString:@""]) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(Margin, timeTop + 15, 15, 15)];
        iv.image = Image(@"detailpage_dateview");
        [time addSubview:iv];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin + 15, timeTop + 15, SCREENW -  7*Margin, 15)];
        label.font = Font(15);
        label.textColor = fontBlack;
        label.text = detailModel.time_string;
        [time addSubview:label];
        
        timeTop = CGRectGetMaxY(iv.frame);
    }

    // 5.2 时间
    if (![detailModel.time2_string isEqualToString:@""]) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(Margin, timeTop + 15, 15, 15)];
        iv.image = Image(@"detailpage_clockview");
        [time addSubview:iv];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin + 15, timeTop + 15, SCREENW -  7*Margin, 15)];
        label.font = Font(15);
        label.textColor = fontBlack;
        label.text = detailModel.time2_string;
        [time addSubview:label];
        
        timeTop = CGRectGetMaxY(iv.frame);
    }
    
    // 5.3 价格
    if (![detailModel.price_list isEqualToString:@""]) {
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(Margin, timeTop + 15, 15, 15)];
        iv.image = Image(@"detailpage_priceview");
        [time addSubview:iv];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin + 15, timeTop + 15, SCREENW -  7*Margin, 15)];
        label.font = Font(15);
        label.textColor = fontBlack;
        label.text = detailModel.price_list;
        [time addSubview:label];
        
        timeTop = CGRectGetMaxY(iv.frame);
    }
    
    // 5.4 如果以上三者有内容
    if (timeTop != 0) {
        
        time.frame = CGRectMake(2*Margin, dealMaxY + Margin, SCREENW - 4*Margin, timeTop + 15);
        time.layer.borderColor = lightGray.CGColor;
        time.layer.borderWidth = 0.5;
        [_contentView addSubview:time];
        
        timeTop = CGRectGetMaxY(time.frame);
    } else {
        
        timeTop = dealMaxY;
    }
    
    // 6. 用户wish
    CGFloat wishTop = timeTop + Margin;
    
    // Avatar的宽度
    CGFloat avatarWidth = (SCREENW - 4*Margin - 30) / 5.0 - 10;
    
    if (detailModel.wish_count != 0) {
        
        UIButton *wishBtn = [[UIButton alloc] init];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin, 0, SCREENW - 4*Margin, 3*SmallText)];
        label.text = [NSString stringWithFormat:@"%ld位into友想去这里", (long)detailModel.wish_count];
        label.font = Font(15);
        label.textColor = fontBlack;
        [wishBtn addSubview:label];
        
        UIImageView *arrowIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW - 2*Margin - 20, 38 + avatarWidth/2.0, 20, 20)];
        arrowIndicator.image = Image(@"go");
        [wishBtn setBackgroundColor:btnGray];
        [wishBtn addSubview:arrowIndicator];
        
        
        for (NSInteger i = 0; i < ((detailModel.wish_count>5)?5:detailModel.wish_count) ; i++) {
            
            UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(2*Margin + i*(avatarWidth + 10), 3*SmallText, avatarWidth, avatarWidth)];
            [avatar setImageWithURL:detailModel.wish_rows[i][@"avatar"]];
            avatar.layer.cornerRadius = avatarWidth / 2.0;
            avatar.clipsToBounds = YES;
            [wishBtn addSubview:avatar];
        }
        
        wishBtn.frame = CGRectMake(0, wishTop, SCREENW, 60 + avatarWidth);
        [wishBtn addTarget:self action:@selector(wishUsers) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:wishBtn];
        
        wishTop = (60 + avatarWidth) + wishTop;
    }
    
    // 7. 用户do
    if (detailModel.do_count != 0) {
        
        UIButton *doBtn = [[UIButton alloc] init];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin, 0, SCREENW - 4*Margin, 3*SmallText)];
        label.text = [NSString stringWithFormat:@"%ld位into友去过这里", (long)detailModel.do_count];
        label.font = Font(15);
        label.textColor = fontBlack;
        [doBtn addSubview:label];
        
        UIImageView *arrowIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENW - 2*Margin - 20, 20 + avatarWidth/2.0, 20, 20)];
        arrowIndicator.image = Image(@"go");
        [doBtn setBackgroundColor:btnGray];
        [doBtn addSubview:arrowIndicator];
        
        for (NSInteger i = 0; i < ((detailModel.do_count>5)?5:detailModel.do_count) ; i++) {
            
            UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(2*Margin + i*(avatarWidth + 10), 3*SmallText, avatarWidth, avatarWidth)];
            [avatar setImageWithURL:detailModel.do_rows[i][@"avatar"]];
            avatar.layer.cornerRadius = avatarWidth / 2.0;
            avatar.clipsToBounds = YES;
            [doBtn addSubview:avatar];
        }
        
        doBtn.frame = CGRectMake(0, wishTop, SCREENW, 60 + avatarWidth);
        [doBtn addTarget:self action:@selector(doUsers) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:doBtn];
        
        wishTop = (60 + avatarWidth) + wishTop;
    }

    // 8. 附近 & 类似
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, wishTop + Margin, SCREENW, 3*Margin + 65)];
    moreView.backgroundColor = btnGray;
    [_contentView addSubview:moreView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin, 2*Margin, SCREENW - 4*Margin, 25)];
    label.text = @"更多推荐";
    label.textColor = fontBlack;
    label.font = Font(15);
    [moreView addSubview:label];
    
    UIButton *similarBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*Margin, 2*Margin + 30, SCREENW - 4*Margin, 30)];
    similarBtn.titleLabel.font = Font(15);
    [similarBtn setBackgroundColor:lightBlue];
    [similarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [similarBtn setTitle:@"类似推荐" forState:UIControlStateNormal];
    [similarBtn addTarget:self action:@selector(similarClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:similarBtn];
    
    CGFloat contentHeight = CGRectGetMaxY(moreView.frame);
    
    CGRect frame = _contentView.frame;
    frame.size.height = contentHeight + 2*Margin;
    _contentView.frame = frame;
    _contentScrView.contentSize = CGSizeMake(SCREENW, contentHeight + HomeCellHeight);
}

#pragma mark - 显示Review详情
- (void)detailOfReview {
    
    if (_detailView == nil) {
    
        // 底层
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        [CURRENT_WINDOW addSubview:_detailView];
        
        CGFloat viewHeight = SCREENH - 64 - 49;
        UIView *layer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW*0.8, viewHeight*0.7)];
        layer.backgroundColor = [UIColor blackColor];
        layer.alpha = 0.9;
        layer.layer.cornerRadius = 10.0f;
        layer.center = self.view.center;
        [_detailView addSubview:layer];
        
        // 滚动的详情
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW*0.8, viewHeight*0.7 - 4*Margin)];
        scrollView.center = self.view.center;
        [_detailView addSubview:scrollView];

        // 上层label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*Margin, 0, SCREENW*0.8 - 4*Margin, 0)];
        label.font = Font(15);
        label.text = _model.review_rows[0][@"content"];
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        
        // 计算文本高度
        CGFloat height = [label boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT)].height;
        
        label.frame = CGRectMake(2*Margin, 0, SCREENW*0.8 - 4*Margin, height);
        [scrollView addSubview:label];
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(label.frame) + 2*Margin);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTap)];
        [_detailView addGestureRecognizer:tap];
    } else {
        
        _detailView.hidden = NO;
    }
}

#pragma mark - 隐藏详情弹窗
- (void)detailTap {

    _detailView.hidden = YES;
}

#pragma mark - 类似推荐按钮
- (void)similarClick:(UIButton *)sender {
    
    RecommendViewController *recVC = [[RecommendViewController alloc] init];
    recVC.item_id = _model.item_id;
        
    recVC.titleOfNav = @"类似推荐";
    [self.navigationController pushViewController:recVC animated:YES];

}

#pragma mark - 链接
- (void)gotoLink:(UIButton *)sender {
    
    LinkViewController *linkVC = [[LinkViewController alloc] init];
    linkVC.link = _model.deal_rows[sender.tag - 300][@"link"];
    linkVC.titleOfNav = _model.deal_rows[sender.tag - 300][@"title"];
    
    [self.navigationController pushViewController:linkVC animated:YES];
}

#pragma mark - 设置想去
- (void)setWish:(UIButton *)sender {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    // 用户未登录
    if (app.userModel == nil) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        
        return;
    }
    
    if ([sender.titleLabel.text isEqualToString:@"想去"]) {
        
        // 设置成不想去
        [sender setTitle:@"不想去" forState:UIControlStateNormal];
        [sender setBackgroundImage:Image(@"rootpage_wanttogobutton_up") forState:UIControlStateNormal];
        [self setWishAndDo:http_of_set_wish setLike:NO];
        
    } else {
        
        // 设置成想去
        [sender setTitle:@"想去" forState:UIControlStateNormal];
        [sender setBackgroundImage:Image(@"rootpage_wanttogobutton_down") forState:UIControlStateNormal];
        [self setWishAndDo:http_of_set_wish setLike:NO];
    }
}

#pragma mark - 设置去过
- (void)setDo:(UIButton *)sender {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    // 用户未登录
    if (app.userModel == nil) {
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        
        return;
    }
    
    if ([sender.titleLabel.text isEqualToString:@"去过"]) {
        
        // 设置成没去过
        [sender setTitle:@"没去过" forState:UIControlStateNormal];
        [sender setBackgroundImage:Image(@"rootpage_togobutton_up") forState:UIControlStateNormal];
        [self setWishAndDo:http_of_set_do setLike:YES];
        
    } else {
        
        // 设置成想去
        [sender setTitle:@"去过" forState:UIControlStateNormal];
        [sender setBackgroundImage:Image(@"rootpage_togobutton_down") forState:UIControlStateNormal];
        [self setWishAndDo:http_of_set_do setLike:YES];
    }
}

#pragma mark - 提交个人喜好设置
- (void)setWishAndDo:(NSString *)url setLike:(BOOL)isLike{
    
    NSDictionary *params = @{@"item_id" : _model.item_id};
    
    [Network requestForData:url params:params successBlock:^(id data) {
        
        if ([data[@"error"] integerValue] != 0) {
            
            [MBProgressHUD showError:@"设置失败"];
        }
        
    } failBlcok:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络故障"];
        DEBUGLog(@"%@", error.localizedDescription);
    }];
    
    // 设置成喜欢
    if (isLike) {
        
        params = @{@"item_id" : _model.item_id,
                   @"is_like" : @1};
        
        [Network requestForData:http_of_set_like params:params successBlock:^(id data) {
            
        } failBlcok:^(NSError *error) {
            
            [MBProgressHUD showError:@"设置喜欢失败"];
            DEBUGLog(@"%@", error.localizedDescription);
        }];
    }
}

#pragma mark - 想去的用户
- (void)wishUsers {
    
    WishDoViewController *vc = [[WishDoViewController alloc] init];
    vc.titleOfNav = @"想去的人";
    vc.url = http_of_wish;
    vc.item_id = _homeModel.item_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 去过的用户
- (void)doUsers {
    
    WishDoViewController *vc = [[WishDoViewController alloc] init];
    vc.titleOfNav = @"去过的人";
    vc.url = http_of_do;
    vc.item_id = _homeModel.item_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 监听滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // DEBUGLog(@"Scrolling... to:%f", scrollView.contentOffset.y);
    
    // 放大轮播图片
    _picScrView.transform = CGAffineTransformIdentity;
    
    CGFloat scale = scrollView.contentOffset.y + 20;
    
    if (scale <= 0) {

        scale = ABS(scale);
        CGFloat height = HomeCellHeight;
        
        scale = (2*scale + height) / height;

        _picScrView.transform = CGAffineTransformScale(_picScrView.transform, scale, scale);
        
        // 同时修改底下内容的frame，使之一同移动
        CGRect frame = _contentView.frame;
        frame.origin.y = CGRectGetMaxY(_picScrView.frame);
        _contentView.frame = frame;
    }
    
    if (scrollView == _contentScrView) {
        
        // 样式一：高度超过一定将导航栏设置为黑色
        [UIView animateWithDuration:0.5f animations:^{
            
            _navView.alpha = (scrollView.contentOffset.y >= (HomeCellHeight - 84)) ? 0.99 :0;
        }];
    }
    
    // 轮播图片时，更改指示器
    if (scrollView == _picScrView) {
    
        CGFloat index = scrollView.contentOffset.x / SCREENW;
        
        if ([Tool isInt:index]) {
            
            _picIndicator.text = [NSString stringWithFormat:@"%.f/%.f", index + 1, scrollView.contentSize.width / SCREENW];
        }
    }
}

@end
