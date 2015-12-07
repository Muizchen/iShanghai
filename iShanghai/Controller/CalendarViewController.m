//
//  CalendarViewController.m
//  iShanghai
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 Muiz. All rights reserved.
//

#import "CalendarViewController.h"
#import "HomeCell.h"
#import "HeaderView.h"
#import "HomeModel.h"
#import "TopicModel.h"
#import "DetailViewController.h"
#import "CalendarModel.h"
#import "WeatherView.h"

@interface CalendarViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_calendarTV;
    
    NSMutableArray *_calendarArr;
    
    // 天气视图
    WeatherView *_weatherView;
    
    // 日期上圆形指示器
    UILabel *_roundIndicator;
    UILabel *_currentDay;
    
    UIScrollView *_weekBgScrV;
    
    UIView *_weekView;
}
@end

@implementation CalendarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    [self initData];
}

#pragma mark - 创建UI
- (void)createUI {
    
    if (_calendarTV == nil) {
        
        //如果加入此代码导致其他控件无法点击，可设置为其他值。tableView下移好像也可以用此方法
#ifdef __IPHONE_7_0
        self.edgesForExtendedLayout = UIRectEdgeNone;
#endif

        _calendarTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH - 49) style:UITableViewStylePlain];
        _calendarTV.scrollEnabled = NO;
        
        _calendarTV.delegate = self;
        _calendarTV.dataSource = self;
        _calendarTV.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_calendarTV];
        
        // 天气视图添加文字
        _weatherView = [[WeatherView alloc] init];
        _weatherView.cover.backgroundColor = lightBlack;
        _weatherView.frame = CGRectMake(0, 0, SCREENW, SCREENW*(156/320.0));
        
        _calendarTV.tableHeaderView = _weatherView;
        
        _weekBgScrV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    
        _weekBgScrV.contentSize = CGSizeMake(7*SCREENW, SCREENH);
        _weekBgScrV.pagingEnabled = YES;
        _weekBgScrV.delegate = self;
        
        for (int i = 0; i < 7 ; i++) {
            
            UITableView *calendarTV = [[UITableView alloc] initWithFrame:CGRectMake(i * SCREENW, 0, SCREENW, SCREENH - 49 - SCREENW/6.0) style:UITableViewStyleGrouped];
            ;
            calendarTV.separatorStyle = UITableViewCellSeparatorStyleNone;
            calendarTV.sectionFooterHeight = 0;
            calendarTV.showsVerticalScrollIndicator = NO;
            calendarTV.tag = 100 + i;
            
            calendarTV.dataSource = self;
            calendarTV.delegate = self;
            [_weekBgScrV addSubview:calendarTV];
            
            MJRefreshGifHeader *calendarHeader = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                
                // 请求第一页数据，并刷新
                [self requestDataForTableView:calendarTV];
            }];
            
            // 设置Indicator样式
            [Tool setLoadingIndicatorStyle:calendarHeader];
            
            calendarTV.header = calendarHeader;
        }
    }
}

- (void)initData {
    
    if (_calendarArr == nil) {
        
        _calendarArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    // 自动头部刷新
    for (UIView *view in _weekBgScrV.subviews) {
        
        if ([view isKindOfClass:[UITableView class]]) {
            
            [((UITableView *)view).header beginRefreshing];
            break;
        }
    }
}

#pragma mark - 重新设置天气，时间等参数
/**
 *  重新设置天气，时间等参数
 *
 *  @param numOfTableView range:0~6
 */
- (void)resetData:(NSInteger)numOfTableView {
    
    // 保证数据存在时执行
    if (_calendarArr.count == 0) {
        return;
    }
    
    // 根据不同的tableView
    CalendarModel *model = _calendarArr[numOfTableView];
    NSString *weatherStr = model.weather_pic_num;
    
    // 修改新的天气数据
    _weatherView.date.text = model.date_cn;
    _weatherView.weekDay.text = model.week_cn;
    _weatherView.weatherPic.image = Image(weatherStr);
    _weatherView.celsius.text = model.temp;
    
    // 根据不同的tableView，使weekLabel上的小点点，随之移动
    NSInteger tag = 200 + numOfTableView;
    UILabel *label;
    for (UIView *view in _weekView.subviews) {
        
        if (view.tag == tag && [view isKindOfClass:[UILabel class]]) {
            label = (UILabel *)view;
            break;
        }
    }
    
    CGPoint point = _roundIndicator.center;
    point.x = (numOfTableView + 1)*SCREENW/9.0 + SCREENW/18.0;
    
    [UIView animateWithDuration:0.5f animations:^{
        
        _roundIndicator.center = point;
        
        if (numOfTableView == 0) {
            _roundIndicator.backgroundColor = lightRed;
        } else {
            _roundIndicator.backgroundColor = lightBlue;
        }
    
    } completion:^(BOOL finished) {
        
        _currentDay.textColor = [UIColor blackColor];
        _currentDay = label;
        _currentDay.textColor = [UIColor whiteColor];
    }];
    
/*
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        // 动画效果
        // 修改新的天气数据
        _weatherView.date.text = nil;
        _weatherView.weekDay.text = nil;
        _weatherView.weatherPic.image = nil;
        _weatherView.celsius.text = nil;
        
    } completion:^(BOOL finished) {
        
        // 修改新的天气数据
        _weatherView.date.text = model.date_cn;
        _weatherView.weekDay.text = model.week_cn;
        _weatherView.weatherPic.image = Image(weatherStr);
        _weatherView.celsius.text = model.temp;
        
        // 根据不同的tableView，使weekLabel上的小点点，随之移动
        
    }];
*/
}

#pragma mark - 请求日历数据
- (void)requestDataForTableView:(UITableView *)tableView {
    
    // 开始请求数据
    [Network requestForData:http_of_calendar params:nil successBlock:^(id data) {
        
        // 解析“专题”数据
        // 当头部刷新时，清空数据源
        [_calendarArr removeAllObjects];
        
        NSArray *weekArr = data[@"week"];
        
        for (NSDictionary *calendarDict in weekArr) {
            
            // 解析日期数据
            CalendarModel *calendarModel = [[CalendarModel alloc] init];
            [calendarModel setValuesForKeysWithDictionary:calendarDict];
            
            // 解析天气数据
            NSDictionary *weatherDict = calendarDict[@"weather"];
            [calendarModel setValuesForKeysWithDictionary:weatherDict];
            
            // topicModel数据
            NSArray *topics = calendarDict[@"rows"];
            
            for (NSDictionary *topicDict in topics) {
                
                TopicModel *topicModel = [[TopicModel alloc] init];
                [topicModel setValuesForKeysWithDictionary:topicDict];
                
                NSArray *dataArr = topicDict[@"item_rows"];
                
                for (NSDictionary *homeDict in dataArr) {
                    
                    // 利用字典给model赋值
                    HomeModel *model = [[HomeModel alloc] init];
                    [model setValuesForKeysWithDictionary:homeDict];
                    
                    [topicModel.homeModels addObject:model];
                }
                
                [calendarModel.topicModels addObject:topicModel];
            }
            
            [_calendarArr addObject:calendarModel];
        }
        
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
        
        for (UIView *view in _weekBgScrV.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                [((UITableView *)view) reloadData];
            }
        }
        
        // 根据tag值确定tableView
        NSInteger numOfTableView = tableView.tag - 100;
        [self resetData:numOfTableView];
        
    } failBlcok:^(NSError *error) {
        
        [MBProgressHUD showError:@"网络错误"];
        
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
    }];
}

#pragma mark - UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _calendarTV) {
        
        return 1;
    } else if (_calendarArr.count == 0) {
        
        return 0;
    }
    
    // 根据偏移值确定tableView
    NSInteger numOfTabelView = tableView.tag - 100;
    
    return ((CalendarModel *)_calendarArr[numOfTabelView]).topicModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _calendarTV) {
        
        return 1;
    }
    
    // 根据偏移值确定tableView
    NSInteger numOfTabelView = tableView.tag - 100;
    
    TopicModel *topicModel = ((CalendarModel *)_calendarArr[numOfTabelView]).topicModels[section];
    
    return topicModel.homeModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _calendarTV) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:_weekBgScrV];
        
        return cell;
    }
    
    // 根据偏移值确定tableView
    NSInteger numOfTabelView = tableView.tag - 100;
    
    HomeCell *homeCell = [HomeCell cellWithTableView:tableView];
    
    CalendarModel *calendarM = _calendarArr[numOfTabelView];

    homeCell.homeModel = ((TopicModel *)calendarM.topicModels[indexPath.section]).homeModels[indexPath.row];

    return homeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _calendarTV) {
    
        return SCREENH - 49 - SCREENW/6.0;
    }
    
    return HomeCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _calendarTV) {
        
        return SCREENW / 6.0;
    }
    
    return SCREENW / 4.0;
}

#pragma mark - 创建“专题”HeaderView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == _calendarTV) {
        
        NSArray *weekArr = @[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
        NSArray *weekArr_cn = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
        
        // 周日期视图
        _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENW/6.0)];
        _weekView.backgroundColor = [UIColor whiteColor];
        _weekView.layer.borderColor = lightGray.CGColor;
        _weekView.layer.borderWidth = 0.5;
        
        // 圆形指示器
        _roundIndicator = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _roundIndicator.center = CGPointMake(SCREENW/6.0, SCREENW*(5/48.0) + SmallLabelHeight/4.0 );
        _roundIndicator.backgroundColor = lightRed;
        _roundIndicator.layer.cornerRadius = 11.0f;
        _roundIndicator.clipsToBounds = YES;
        
        [_weekView addSubview:_roundIndicator];
        
        // 循环创建7天
        for (NSInteger i = 0; i < 7 ; i++) {
            
            // 获取阳历
            NSDate *nowDate = [[NSDate alloc] initWithTimeInterval:i*3600*24 sinceDate:[[NSDate alloc] init]];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSInteger day;
            NSInteger year;
            NSInteger month;
            NSInteger weekDay;
            [calendar getEra:nil year:&year month:&month day:&day fromDate:nowDate];
            [calendar getEra:nil yearForWeekOfYear:nil weekOfYear:nil weekday:&weekDay fromDate:nowDate];
            
            // 创建日期label
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/9.0*(i + 1), 0, SCREENW/9.0, SCREENW/12.0)];
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW/9.0*(i + 1), SmallLabelHeight/2.0 + SCREENW/24.0, SCREENW/9.0, SCREENW/8.0 - SmallLabelHeight/2.0)];
            dayLabel.tag = 200 + i;
            
            // 当前选中日期：今天
            if (i == 0) {
                dayLabel.textColor = [UIColor whiteColor];
                
                _currentDay = dayLabel;
                
                // 设置天气视图中，当天的日期数据
                _weatherView.date.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)year, (long)month, (long)day];
                _weatherView.weekDay.text = [NSString stringWithFormat:@"%@", weekArr_cn[weekDay - 1]];
            }
            
            weekLabel.font = Font(SmallLabelHeight);
            weekLabel.text = weekArr[weekDay - 1];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            
            dayLabel.font = Font(15);
            dayLabel.text = [NSString stringWithFormat:@"%ld", (long)day];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            
            [_weekView addSubview:weekLabel];
            [_weekView addSubview:dayLabel];
        }
        
        return _weekView;
    }
    
    // 根据偏移值确定tableView
    NSInteger numOfTabelView = tableView.tag - 100;
    
    HeaderView *headerView = [HeaderView headerViewWith:tableView];
    headerView.topicModel = ((CalendarModel *)_calendarArr[numOfTabelView]).topicModels[section];
        
    return headerView;
}

#pragma mark - 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _calendarTV) {
    
    }
    
    // 根据偏移值确定tableView
    NSInteger numOfTabelView = tableView.tag - 100;
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    
    CalendarModel *calendarModel = _calendarArr[numOfTabelView];
    
    TopicModel *topicModel = calendarModel.topicModels[indexPath.section];
    
    detailVC.homeModel = topicModel.homeModels[indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 监听最内层tableView的滚动事件（最外层tableView已经被禁止滚动）
    CGFloat offSet = SCREENW*(156/320.0) - 20;
    
    offSet = roundf(offSet);
    
    if (_calendarTV.contentOffset.y < offSet) {
        
        UITableView *tableView = (UITableView *)scrollView;
        
        if (tableView.contentOffset.y > 0) {
            
            CGFloat offsetY = tableView.contentOffset.y > offSet ? offSet : tableView.contentOffset.y;
            
            [_calendarTV setContentOffset:CGPointMake(0, offsetY)];
            
            // 设置渐变
            _weatherView.cover.alpha = offsetY/(offSet);
        }
    } else if (_calendarTV.contentOffset.y == offSet) {
        
        UITableView *tableView = (UITableView *)scrollView;
        
        if (tableView.contentOffset.y < 0) {
            
            CGFloat offsetY;
            
            offsetY = tableView.contentOffset.y > 0 ? tableView.contentOffset.y : 0;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                [_calendarTV setContentOffset:CGPointMake(0, offsetY)];
                
                [tableView setContentOffset:CGPointMake(0, 0)];
                
                _weatherView.cover.alpha = 0;
            } completion:^(BOOL finished) {
                
                // 将其他几个tableView重置offsetY为0
                for (UIView *view in _weekBgScrV.subviews) {
                    
                    if ([view isKindOfClass:[UITableView class]]) {
                
                        [((UITableView *)view) setContentOffset:CGPointMake(0, 0)];
                    }
                }
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 监听横向scrollView的滚动事件
    if (scrollView == _weekBgScrV) {
        
        CGFloat offsetX = _weekBgScrV.contentOffset.x / SCREENW;
        
        if ([Tool isInt:offsetX]) {
            
            [self resetData:offsetX];
        }
    }
}

@end
