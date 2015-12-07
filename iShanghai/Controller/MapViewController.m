//
//  MapViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "MapViewController.h"

#import "DetailModel.h"

// 高德地图框架包
#import <AMapNaviKit/AMapNaviKit.h>

#define APIKey @"9cb6fc6e26875363a799012304e8340a"

@interface MapViewController () <MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 自定义导航栏
    [self createNav];
    
    // 创建地图
    [self createMapView];
    
    // 详细地址
    [self createAddressView];
}

#pragma mark 自定义导航栏
- (void)createNav
{
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
    backBtn.frame = CGRectMake(Margin, 27, 20, 20);
    [backBtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    // 3. 标题
    UILabel *title = [[UILabel alloc] init];
    title.font = FontWithWeight(16, 16);
    title.text = @"地图";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(2*Margin + 20, 20, SCREENW - 4*Margin - 40, 44);
    [navView addSubview:title];

}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 创建地图
- (void)createMapView
{
    // 设置高德地图的apiKey
    [MAMapServices sharedServices].apiKey = APIKey;
    
    // 创建地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH - 64)];
    [self.view addSubview:_mapView];
    
    // 坐标
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.map_lattitude doubleValue], [_model.map_longitude doubleValue]);
    
    // 比例
    MACoordinateSpan span = MACoordinateSpanMake(0.007, 0.007);
    
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
    
    // 设置显示区域
    [_mapView setRegion:region animated:YES];
    
    // 设置地图的类型
    _mapView.mapType = MAMapTypeStandard;
    
    // 设置罗盘
    _mapView.showsCompass = YES;
    
    // 隐藏比例尺
    _mapView.showsScale = NO;
    
    _mapView.delegate = self;
    
    MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
    anno.coordinate = coordinate;
    anno.title = _model.venue;
    anno.subtitle = _model.address;
    
    [_mapView addAnnotation:anno];
}

#pragma mark 自定义大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    MAPinAnnotationView *customView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"anno"];
    
    if (!customView) {
        
        customView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"anno"];
    }
    
    // 设置大头针图片
    customView.image = [UIImage imageNamed:@"icon_annotation"];
    customView.canShowCallout = YES;
    customView.animatesDrop = YES;

    return customView;
}

#pragma mark 详细地址
- (void)createAddressView
{
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENW, SCREENH * 0.12)];
    addressView.backgroundColor = [UIColor blackColor];
    addressView.alpha = 0.6;
    [self.view addSubview:addressView];
    
    // 地点名 venue
    UILabel *venueLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, Margin, SCREENW - 2*Margin, addressView.frame.size.height * 0.2)];
    venueLabel.text = _model.venue;
    venueLabel.textColor = [UIColor whiteColor];
    venueLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [addressView addSubview:venueLabel];
    
    // 地址 address
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(Margin, CGRectGetMaxY(venueLabel.frame) + Margin, SCREENW - 2*Margin, venueLabel.frame.size.height)];
    addressLabel.text = _model.address;
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont systemFontOfSize:16.0f];
    [addressView addSubview:addressLabel];
}



@end
