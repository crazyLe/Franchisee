//
//  JPushManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/31.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZPercentageApplyController.h"
#import "KZMaterialListController.h"
#import "KZMessageManager.h"
#import <JPUSHService.h>
#import "JPushManager.h"

@implementation JPushManager

/**
 启动JPush
 */
- (void)startJPush{
    //注册标签和别名
    if (!isEmptyStr(kUid)) {
        [JPUSHService setTags:nil alias:kUid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            
        }];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [defaultCenter addObserver:self selector:@selector(handleRemoteNotifyWithUserInfo:) name:kReceiveRemotoNotification object:nil];
}

/**
 停止JPush
 */
- (void)stopJPush{
    //清空别名
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
    }];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    [KZMessageManager pullNewMessageWithCompletionBlock:^(BOOL isSuccess) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [NOTIFICATION_CENTER postNotificationName:kUpdateWorkBadgeNotification object:nil];
        });
    }];
}

//处理远程通知
- (void)handleRemoteNotifyWithUserInfo:(NSNotification *)notify
{
    UIApplication *application = [UIApplication sharedApplication];
    
    BOOL isBackground =  application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground;
    
    UINavigationController *navigation = [JPushManager getCurrentVC].navigationController;
    
    NSDictionary *userInfo = notify.object;
    
    NSString *msg_id = userInfo[@"msg_id"];
    
    if (isBackground) {
        switch ([msg_id intValue]) {
            case 53:case 54:
                //物料审批列表
            {
                KZMaterialListController *materialListVC = [[KZMaterialListController alloc] init];
                [navigation pushViewController:materialListVC animated:YES];
            }
                break;
            case 55:case 56:
                //提成申请列表
            {
                KZPercentageApplyController *percentageApplyVC = [[KZPercentageApplyController alloc] init];
                [navigation pushViewController:percentageApplyVC animated:YES];
            }
                break;
            case 57:
                //意向学员
            {
                navigation.tabBarController.selectedIndex = 0;
                [navigation popToRootViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        //前台
    }
}

/**
 获取当前的控制器
 */
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
