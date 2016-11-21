//
//  NSObject+HJGeneral.h
//  小筛子
//
//  Created by zwz on 15/6/27.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProgressHUD.h"

typedef enum
{
    DeviceType_Unknow = 0,
    DeviceType_Simulator = 1,
    DeviceType4_Series = 2, //
    DeviceType5_Series = 3, //
    DeviceType6_Series = 4, //
    DeviceType6P_Series = 5 //
    
}DeviceType;

typedef NS_ENUM(NSInteger,MyNetworkStatus)
{
    NetworkStatusNotReachable = 0,//无网
    
    NetworkStatusReachableViaWiFi =1,//Wifi
    
    NetworkStatusReachableViaWWAN = 2,//流量
 
    NetworkStatusUnknown = 3,//未知网络

};

@interface NSObject (HJGeneral)
/**
 *  当前用户个人信息
 */
//@property(nonatomic,strong,readonly) HJDetailInfo *currentUserInfo;
/**
 *  接口文档
 */
//@property(nonatomic,strong,readonly) HJInterfaceManager *interfaceManager;
/**
 *  判断设备类型
 */
//@property(nonatomic,assign,readonly) DeviceType currentDeviceType;
/**
 *  HUD显示器
 */
@property(nonatomic,assign,readonly) ProgressHUD *hudManager;

/**
 *  是否有网
 */
@property (nonatomic, assign)BOOL hasNetwork;
/**
 *  网络状态
 */
@property (nonatomic, assign)MyNetworkStatus networkStatus;



@end
