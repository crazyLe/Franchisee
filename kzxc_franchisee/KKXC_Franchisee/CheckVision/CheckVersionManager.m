//
//  CheckVersionManager.m
//  KKXC_Franchisee
//
//  Created by LL on 16/10/24.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#define kVersionChannel @"1" //iOS 值为1 ；Android值为0
#define kAppVersion     @"201"

#import "CheckVersionManager.h"
#import "KZAddressManager.h"
#import "KZSchoolManager.h"

@implementation CheckVersionManager

//检查版本
+ (void)checkVersion
{
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *paraDic = @{@"version_code":kAppVersion,@"version_name":version,@"version_channel":kVersionChannel};
    [KZNetworkEngine postWithUrl:kCheckVersionInterface paraDic:paraDic successBlock:^(id jsonObj) {
        if (isEqualValue(jsonObj[@"code"], 1)) {
            NSString *updateCode = jsonObj[@"info"][@"updateCode"];
            NSString *updateUrl = jsonObj[@"info"][@"updateUrl"];
            
            NSString *serverTimeStr = jsonObj[@"info"][@"serverTime"];
            
            NSString *area_ver = jsonObj[@"info"][@"area_ver"];
            
            area_ver = [NSString stringWithFormat:@"%@",area_ver];
            
            NSString *old_area_ver = [kUserDefault objectForKey:@"CoachAreaVersion"];
            
            BOOL isCacheProvinceData = [[kUserDefault objectForKey:cacheProvinceDataKey] boolValue];
            BOOL isCacheCityData = [[kUserDefault objectForKey:cacheCityDataKey] boolValue];
            BOOL isCacheCountyData = [[kUserDefault objectForKey:cacheCountyDataKey] boolValue];
            
            if ((!isStartUpdaeDB)&&(!old_area_ver || !isCacheProvinceData || !isCacheCityData || !isCacheCountyData || ![area_ver isEqualToString:old_area_ver])) {
                //更新地址数据
                [kUserDefault setBool:YES forKey:@"AreaStartUpdateFlag"];//标记地址开始更新
                [KZAddressManager loadAddressInfo]; //加载地址信息
                [KZSchoolManager loadSchoolInfo];
            }
            [kUserDefault synchronize];
            
            
            //存储地区版本号
            [kUserDefault setObject:area_ver forKey:@"CoachAreaVersion"];
            
            if ([updateCode isEqualToString:@"1"]) {//建议升级
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"有新版本"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         nil;
                                                                     }];
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 通过获取到的url打开应用在appstore，并跳转到应用下载页面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }];
                [alertCtl addAction:cancelAction];
                [alertCtl addAction:upgradeAction];

                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtl animated:YES completion:nil];;

            } else if ([updateCode isEqualToString:@"2"]) {//强制升级
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"有新版本"
                                                                                  message:nil
                                                                           preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 通过获取到的url打开应用在appstore，并跳转到应用下载页面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }];

                [alertCtl addAction:upgradeAction];

                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtl animated:YES completion:nil];
            }
            
            long long i = [serverTimeStr longLongValue];
            long long j = [[NSDate date] timeIntervalSince1970];
            long long k = i-j;
            
            //            NSTimeInterval current = k + j;
            //            NSInteger currentTime = current;
            
            //            NSLog(@"%f",[[NSDate date] timeIntervalSince1970]);
            NSString * str = [NSString stringWithFormat:@"%lld",k];
            [kUserDefault setObject:str forKey:@"CoachTimeDifference"];
            
            [kUserDefault synchronize];
        }
    } failedBlock:^(NSError *error) {
        
    }];
}

@end
