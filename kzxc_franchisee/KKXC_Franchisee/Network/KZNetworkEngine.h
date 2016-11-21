//
//  NetworkEngine.h
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

typedef void(^requestSuccessBlock)(id jsonObj);
typedef void(^requestFailedBlock)(NSError *error);

#import <Foundation/Foundation.h>

@interface KZNetworkEngine : NSObject

/**发送GET异步请求
 1.relativeAdd  : 请求的地址
 2.paraDic      : 参数字典
 3.successBlock : 请求成功时回调
 4.failedBlock  : 请求失败时回调
 */
+ (void)getWithUrl:(NSString *)urlStr paraDic:(NSDictionary *)paraDic successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock;

/**发送POST异步请求
 1.relativeAdd  : 请求的地址
 2.paraDic      : 参数字典
 3.successBlock : 请求成功时回调
 4.failedBlock  : 请求失败时回调
 */
+ (void)postWithUrl:(NSString *)urlStr paraDic:(NSDictionary *)paraDic successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock;

/**上传单张图片
 1.urlStr      : 请求的地址
 2.dic         : 参数字典    eg. @{@"paraName1":@"paraValue1"}
 3.imgParaName : 图片参数名称 eg. @"pic1"
 4.data        : 图片的二进制数据(NSData)
 5.successBlock: 上传成功的回调
 6.failedBlock : 上传失败时的回调
 */
+(void)uploadSingleImageWithUrl:(NSString *)urlStr param:(NSDictionary *)dic imgParaName:(NSString *)imgParaName imgData:(NSData *)data successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock;

/**上传多张图片
 1.urlStr         : 请求的地址
 2.dic            : 参数字典       eg. @{@"paraName1":@"paraValue1"}
 3.imgParaNameArr : 图片参数名的数组 eg. @[@"pic1",@"pic2",@"pic3"]
 4.dataArr        : 图片二进制数据(NSData) 数组
 5.successBlock   : 上传成功回调
 6.failedBlock    : 上传失败回调
 */
+(void)uploadMultipleImageWithUrl:(NSString *)urlStr param:(NSDictionary *)dic imgParaNameArr:(NSArray *)imgParaNameArr imgDataArr:(NSArray *)dataArr successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock;

/**上传单个文件
 1.urlStr      : 请求的地址
 2.dict        : 参数字典
 3.name        : 对应后台网站上[upload.php中]处理文件的[字段"head"]
 4.fileName    : 要保存在服务器上的[文件名]
 5.mimeType    : 上传文件的[mimeType]
 6.data        : 上传文件的Data[二进制数据]
 7.successBlock: 上传成功的回调
 8.failedBlock : 上传失败时的回调
 */
+ (void)uploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock;

/**上传多个文件
 1.urlStr      : 请求的地址
 2.dict        : 参数字典
 3.nameArr     : 对应后台网站上[upload.php中]处理文件的[字段"head"] 数组
 4.fileNameArr : 要保存在服务器上的[文件名] 数组
 5.mimeType    : 上传文件的[mimeType]
 6.dataArr     : 上传文件的Data[二进制数据] 数组
 7.successBlock: 上传成功的回调
 8.failedBlock : 上传失败时的回调
 */
+(void)uploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceNameArr:(NSArray *)nameArr fileNameArr:(NSArray *)fileNameArr mimeType:(NSString *)mimeType fileDataArr:(NSArray *)dataArr successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock;

@end
