//
//  ViewController.m
//  定位demo
//
//  Created by 孙宁 on 15/4/20.
//  Copyright (c) 2015年 cnlive. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(readonly, nonatomic)CLLocation *mylocation;//我的位置


@end

@implementation ViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //关闭定位
    [self.locationManager stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(100, 100, 100, 30);
    [btn setTitle:@"开启定位" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

-(CLLocationManager*)locationManager
{
    if (_locationManager==nil) {
        //1.创建位置管理器（定位用户的位置
        self.locationManager=[[CLLocationManager alloc] init];
         //2.设置代理
        self.locationManager.delegate=self;
        //始终允许访问位置信息
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    
    return _locationManager;
}
- (void)btnClick
{
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        //监控区域_mylocation.coordinate.latitude, _mylocation.coordinate.longitude  116.315762,39.940682
       CLCircularRegion  *region=[[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(39.934200,116.309087) radius:10 identifier:@"coreLocation"];
        NSLog(@"%@",region);
        //开始定位用户的位置
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringForRegion:region];
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
            }else
                 {
                     //不能定位用户的位
                     //1.提醒用户检查当前的网络状况
                     //2.提醒用户打开定位开关
                     }
    
}

#pragma mark CLLocationManagerDelegate
//用户改变当前的授权权限的时候
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}
//当定位到用户的位置时，就会调用（调用的频率比较频繁）
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    _mylocation=[locations firstObject];
    NSLog(@"纬度=%f，经度=%f",_mylocation.coordinate.latitude, _mylocation.coordinate.longitude);
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
   
}
//区域监控
//当设备进入指定区域时
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"区域检测提示" message:@"您已经进入中国外文大厦!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"我进来了");
    
}
//设备离开指定区域时
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"区域检测提示" message:@"您已经离开中国外文大厦!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"我出去了");
}
// 定位失败时激发的方法
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"定位失败: %@",error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
