//
//  NSString+Hash.m
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import "NSString+Hash.h"
#import<CommonCrypto/CommonDigest.h>
@implementation NSString (Hash)

+(NSString *)get16BitMD5_lowercaseString:(NSString *)srcString
{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self get32BitMD5_lowercaseString:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    return result;

}
+(NSString *)get16BitMD5_uppercaseString:(NSString *)srcString
{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self get32BitMD5_uppercaseString:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    return result;
    
}
+(NSString *)get32BitMD5_lowercaseString:(NSString *)srcString
{

    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
+(NSString *)get32BitMD5_uppercaseString:(NSString *)srcString
{
    
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i =0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02X", digest[i]];
    
    return result;
}
@end
