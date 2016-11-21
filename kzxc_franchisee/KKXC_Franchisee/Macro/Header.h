//
//  Header.h
//  KKXC_Franchisee
//
//  Created by 翁昌青 on 16/8/2.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#ifndef Header_h
#define Header_h

/**
 *  是否开启https SSL 验证
 *
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL NO

#define pushID [[UIDevice currentDevice] identifierForVendor].UUIDString

#define deviceInfo [NSString stringWithFormat:@"%@,%@",[UIDevice currentDevice].model,[UIDevice currentDevice].systemVersion]

#define curDefaults [NSUserDefaults standardUserDefaults]
#define kUserDefault curDefaults

#define sessionID [NSString get32BitMD5_lowercaseString:pushID]



//通知中心
#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#define WeakObj(o) __weak typeof(o) o##Weak = o;

//单例声明
#define singletonInterface(className) + (instancetype)shared##className;
//单例实现
#define singletonImplementation(className)\
static className *_instance;\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
+ (instancetype)shared##className\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}

//屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//是否是iphone6以上设备
#define isUpIPhone6 ([UIScreen mainScreen].bounds.size.width > 320)

#define isIPhone6 ([UIScreen mainScreen].bounds.size.height == 667)

#define isIPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define isIPhpne4 ([UIScreen mainScreen].bounds.size.height == 480)

//适配高度
#define HHeader               (kScreenHeight/667.0)
#define WHeader               (kScreenWidth/375.0)


#define Font11 [UIFont systemFontOfSize:11.0]
#define Font12 [UIFont systemFontOfSize:12.0]
#define Font13 [UIFont systemFontOfSize:13.0]
#define Font14 [UIFont systemFontOfSize:14.0]
#define Font15 [UIFont systemFontOfSize:15.0]
#define Font16 [UIFont systemFontOfSize:16.0]
#define Font17 [UIFont systemFontOfSize:17.0]
#define Font18 [UIFont systemFontOfSize:18.0]
#define Font19 [UIFont systemFontOfSize:19.0]
#define Font20 [UIFont systemFontOfSize:20.0]
#define Font22 [UIFont systemFontOfSize:22.0]

//IPHONE 6
#define kWidthScale kScreenWidth/375.0f
#define kHeightScale kScreenHeight/667.0f

#define kFont10 [UIFont systemFontOfSize:10*kWidthScale]
#define kFont11 [UIFont systemFontOfSize:11*kWidthScale]
#define kFont12 [UIFont systemFontOfSize:12*kWidthScale]
#define kFont13 [UIFont systemFontOfSize:13*kWidthScale]
#define kFont14 [UIFont systemFontOfSize:14*kWidthScale]
#define kFont15 [UIFont systemFontOfSize:15*kWidthScale]
#define kFont16 [UIFont systemFontOfSize:16*kWidthScale]
#define kFont17 [UIFont systemFontOfSize:17*kWidthScale]
#define kFont18 [UIFont systemFontOfSize:18*kWidthScale]
#define kFont19 [UIFont systemFontOfSize:19*kWidthScale]
#define kFont20 [UIFont systemFontOfSize:20*kWidthScale]


#define kGrayHex33          [UIColor colorWithHexString:@"333333"]
#define kGrayHex88          [UIColor colorWithHexString:@"888888"]
#define kGrayHex66          [UIColor colorWithHexString:@"666666"]
#define kGrayHex99          [UIColor colorWithHexString:@"999999"]
#define kGrayHex64          [UIColor colorWithHexString:@"646464"]

#define kBlackThemeColor    [UIColor colorWithHexString:@"444b54"]
#define kBlueThemeColor     [UIColor colorWithHexString:@"1d8fe1"]
#define kSepLineColor       [UIColor colorWithHexString:@"eeeeee"]


//空判断相关
#define isEmptyStr(str) (!str||[str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) //判断是否空字符串
#define isEmptyArr(arr) (!arr||((NSArray *)arr).count==0) //判断是否空数组
#define isNull(str)     (!str||[str isKindOfClass:[NSNull class]])
#define isEqualValue(String_Number,Integer) ([String_Number integerValue]==Integer) //判断参数1与参数2是否相等 适用于NSNumber,NSString类型与整型判断

#define kHandleEmptyStr(str) (isEmptyStr(str)?@"":str)  //解决空字符串问题
#define kEmptyStrToZero(str) (isEmptyStr(str)?@"0":str)  //解决空字符串问题

//文件管理相关
#define kFileManager [NSFileManager defaultManager]

#define kDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory\
, NSUserDomainMask, YES)[0]

/*******************城市相关*************************/



//城市相关
#define kCityName      [kUserDefault objectForKey:@"AreaName"]      //城市名 全称
#define kCityID        [kUserDefault objectForKey:@"AreaID"]        //城市ID
#define kCityShortName [kUserDefault objectForKey:@"AreaShortName"] //城市名 简称

#define kAreaVersion   [kUserDefault objectForKey:@"AreaVersion"]   //地区版本号
#define cacheProvinceDataKey @"cacheProvinceDataKey"
#define cacheCityDataKey @"cacheCityDataKey"
#define cacheCountyDataKey @"cacheCountyDataKey"

//市字典
#define kCityTableName @"OpenCityTable"
#define kCityTableColumnArr @[@"id",@"areaName",@"areaShortName",@"areaPhonetic",@"isHot",@"levelId",@"parentId",@"latitude",@"longitude"]
#define kCityDicArr [[KZDataBaseManager shareInstance] getAllObjectsFromTable:kCityTableName KeyArr:kCityTableColumnArr]

//省字典
#define kProvinceTableName @"kProviceTableName"
#define kProvinceTableCollumnArr kCityTableColumnArr
#define kProvinceDicArr [[KZDataBaseManager shareInstance] getAllObjectsFromTable:kProvinceTableName KeyArr:kProvinceTableCollumnArr]

//县字典
#define kCountyTableName @"kCountyTableName"
#define kCountyTableCollumnArr kCityTableColumnArr
#define kCountryDicArr [[KZDataBaseManager shareInstance] getAllObjectsFromTable:kCountyTableName KeyArr:kCountyTableCollumnArr]

#define kProvinceData [kUserDefault objectForKey:@"addressArray"]

#define isStartUpdaeDB ([[kUserDefault objectForKey:@"AreaStartUpdateFlag"] boolValue])

/************************学校相关**********************************/
#define cacheSchoolDataKey @"cacheSchoolDataKey"

#define kSchoolTableName @"kSchoolTableName"
#define kSchoolTableCollumnArr @[@"id",@"areaId",@"schoolName"]
#define kSchoolDicArr [[KZDataBaseManager shareInstance] getAllObjectsFromTable:kSchoolTableName KeyArr:kSchoolTableCollumnArr]

/*******************请求常用宏，以及用户信息宏*************************/

//时间戳
#define kTimeStamp  [NSString stringWithFormat:@"%lld",[[kUserDefault objectForKey:@"TimeDifference"] intValue]+(long long)[[NSDate date] timeIntervalSince1970]]

//UUID设备唯一标示
#define kUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//设备信息
#define kDeviceInfo [NSString stringWithFormat:@"%@,%@",[UIDevice currentDevice].model,[[UIDevice currentDevice] systemVersion]]
//用户ID
#define kUid [kUserDefault objectForKey:@"kUid"]
//令牌
#define kToken [kUserDefault objectForKey:@"kToken"]

//签名
#define kSignWithIdentify(identifier) [[NSString stringWithFormat:@"%@%@%@%@%@",kUUID,identifier,kUid,kToken,kTimeStamp] md5String]

#define kSignIdentifyWithStr(identifier,string) [[NSString stringWithFormat:@"%@%@%@%@%@%@",kUUID,identifier,kUid,kToken,kTimeStamp,string] md5String]

//是否登录
#define isLogin [[kUserDefault objectForKey:@"isLogin"] isEqualToNumber:@(YES)]

#define kHasBuildFranchiseeInfo [[kUserDefault objectForKey:@"kHasBuildFranchiseeInfo"] isEqualToNumber:@(YES)]

//是否首次启动APP
#define isFirstLaunch ![[kUserDefault objectForKey:@"isFirstLaunch"] isEqualToNumber:@(YES)]

#define kClasses @[@{@"short_name":@"大一",@"id":@"1"},@{@"short_name":@"大二",@"id":@"2"},@{@"short_name":@"大三",@"id":@"3"},@{@"short_name":@"大四",@"id":@"4"},@{@"short_name":@"大五",@"id":@"5"},@{@"short_name":@"研一",@"id":@"6"},@{@"short_name":@"研二",@"id":@"7"},@{@"short_name":@"研三",@"id":@"8"}]

#define kPlaceHolder_1_1 @"placeholder"
#define kHudDismissTime 1

#define kBindBankCard [kUserDefault objectForKey:@"kBindState"]
#define kCityInfo [kUserDefault objectForKey:@"cityInfo"]

#define kJPUSH_APP_KEY @"87bc47970356960a1d1d3297"

#define kReceiveRemotoNotification          @"kReceiveRemotoNotification"
#define kUpdateWorkBadgeNotification        @"kUpdateWorkBadgeNotification"

#endif /* Header_h */
