//
//  ValidateHelper.h
//  KZXC_Instructor
//
//  Created by 翁昌青 on 16/6/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateHelper : NSObject

/**
 *  验证手机号 以13、15、17、18开头
 *
 *  @param mobileNum 手机号
 *
 *  @return Yes手机号格式正确
 */
+(BOOL)validateMobile:(NSString *)mobileNum;
/**
 *  验证邮箱
 *
 *  @param emailStr 邮箱字符串
 *
 *  @return Yes邮箱格式正确
 */
+(BOOL)validateEmail:(NSString *)emailStr;
/**
 *  验证身份证
 *
 *  @param identityCard 身份证字符串
 *
 *  @return Yes身份证符合规则
 */
+(BOOL)validateIdentityCard:(NSString *)identityCard;
/**
 *  验证密码6-20
 *
 *  @param passWord 密码字符串
 *
 *  @return Yes密码格式正确
 */
+(BOOL) validatePassword:(NSString *)passWord;

/**
 *  校验银行卡号
 *
 *  @param cardNo 卡号
 *
 *  @return YES 格式正确
 */
+ (BOOL) validateCardNo:(NSString*) cardNo;

@end
