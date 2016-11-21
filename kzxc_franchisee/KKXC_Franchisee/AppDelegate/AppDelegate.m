//
//  AppDelegate.m
//  KKXC_Franchisee
//
//  Created by 翁昌青 on 16/8/2.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"
#import "CheckVersionManager.h"
#import "KZTabBarController.h"
#import "KZLoginGuideController.h"
#import "KZSelectIdentityController.h"
#import <Bugtags/Bugtags.h>
#import <JSPatchPlatform/JSPatch.h>
#import <UMSocialCore/UMSocialCore.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface AppDelegate() <JPUSHRegisterDelegate> {
    
    BMKMapManager* _mapManager;

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _launchOptions = launchOptions;
    
    //崩溃日志收集
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;
    options.trackingNetwork = YES;
    [Bugtags startWithAppKey:@"512291372a8772cb93f73dfb5761e535" invocationEvent:BTGInvocationEventNone options:options];
    
    [JSPatch startWithAppKey:@"3b315e46c4fd026b"];
    [JSPatch sync];

    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];

    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57b169ffe0f55a46dd000e71"];

    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx3f043adfc29cb382" appSecret:@"67bdd871813e15cc6208d2705348328d" redirectURL:@"http://mobile.umeng.com/social"];

    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105631322"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    // 如果不想显示平台下的某些类型，可用以下接口设置
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatFavorite)]];


    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    if (isLogin) {
        if (kHasBuildFranchiseeInfo) {
            KZTabBarController *tabBarCtl = [[KZTabBarController alloc] init];
            self.window.rootViewController = tabBarCtl;
        } else {            
            KZSelectIdentityController *selectIdentity = [[KZSelectIdentityController alloc] init];;
            UINavigationController *rootCtl = [[UINavigationController alloc] initWithRootViewController:selectIdentity];
            rootCtl.navigationBar.translucent = NO;
            rootCtl.navigationBar.barTintColor = [UIColor colorWithHexString:@"323842"];
            [rootCtl.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
            rootCtl.navigationBar.shadowImage = [[UIImage alloc] init];
            self.window.rootViewController = rootCtl;
        }
    } else {
        KZLoginGuideController *loginGuideCtl = [[KZLoginGuideController alloc] init];
        UINavigationController *rootCtl = [[UINavigationController alloc] initWithRootViewController:loginGuideCtl];
        rootCtl.navigationBar.translucent = NO;
        rootCtl.navigationBar.barTintColor = [UIColor colorWithHexString:@"323842"];
        [rootCtl.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        rootCtl.navigationBar.shadowImage = [[UIImage alloc] init];
        self.window.rootViewController = rootCtl;
    }

    [self.window makeKeyAndVisible];
    
    NSLog(@"documentPath==>%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
    
    [self initBadiDuMapData];
    
    [self initJPush];
    
    //暂用合肥CityId
    [kUserDefault setObject:@"340100" forKey:@"cityInfo"];
    
    return YES;
}
//初始化百度地图模块数据
- (void)initBadiDuMapData
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"Ba3XALNXUUUBBgS0buaE2dNLxFgN0QBO"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             
             [curDefaults setObject:city forKey:@"locationCity"];
             
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
            // [_area setTitle:city forState:UIControlStateNormal];
             
             
             //             cityName = city;
             //             NSLog(@定位完成:%@,cityName);
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             //             NSLog(@No results were returned.);
         }else if (error != nil)
         {
             //             NSLog(@An error occurred = %@, error);
         }
     }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {

    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {

    }
    return result;
}

/**
 初始化极光推送
 */
- (void)initJPush{
    //Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:_launchOptions appKey:kJPUSH_APP_KEY
                          channel:@"Publish channel"
                 apsForProduction:YES];
}

#pragma mark - JPush 

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    [NOTIFICATION_CENTER postNotificationName:kReceiveRemotoNotification object:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [NOTIFICATION_CENTER postNotificationName:kReceiveRemotoNotification object:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [CheckVersionManager checkVersion];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
