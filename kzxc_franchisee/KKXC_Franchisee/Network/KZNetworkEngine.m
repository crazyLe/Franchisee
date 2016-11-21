//
//  NetworkEngine.m
//  Coach
//
//  Created by LL on 16/8/2.
//  Copyright © 2016年 sskz. All rights reserved.
//

#define certificate @"kangzhuangxueche"

#import <AFNetworking.h>
#import "KZNetworkEngine.h"

@implementation KZNetworkEngine

/**发送GET异步请求
 1.relativeAdd  : 请求的地址
 2.paraDic      : 参数字典
 3.successBlock : 请求成功时回调
 4.failedBlock  : 请求失败时回调
 */
+ (void)getWithUrl:(NSString *)urlStr paraDic:(NSDictionary *)paraDic successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //默认响应JSON
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL){
        [manager setSecurityPolicy:[KZNetworkEngine customSecurityPolicy]];
    } else {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [KZNetworkEngine setupBaseInfoWithManager:manager];
    
    [manager GET:urlStr parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(jsonObj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failed!\nerror===>%@",error.localizedDescription);
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

/**发送POST异步请求
 1.relativeAdd  : 请求的地址
 2.paraDic      : 参数字典
 3.successBlock : 请求成功时回调
 4.failedBlock  : 请求失败时回调
 */
+ (void)postWithUrl:(NSString *)urlStr paraDic:(NSDictionary *)paraDic successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer]; //默认响应JSON
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL){
        [manager setSecurityPolicy:[KZNetworkEngine customSecurityPolicy]];
    } else {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [KZNetworkEngine setupBaseInfoWithManager:manager];
    
    [manager POST:urlStr parameters:paraDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(jsonObj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        NSLog(@"failed!\nerror===>%@",error.localizedDescription);
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

/**上传单张图片
 1.urlStr      : 请求的地址
 2.dic         : 参数字典    eg. @{@"paraName1":@"paraValue1"}
 3.imgParaName : 图片参数名称 eg. @"pic1"
 4.data        : 图片的二进制数据(NSData)
 5.successBlock: 上传成功的回调
 6.failedBlock : 上传失败时的回调
 */
+(void)uploadSingleImageWithUrl:(NSString *)urlStr param:(NSDictionary *)dic imgParaName:(NSString *)imgParaName imgData:(NSData *)data successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock
{
    [KZNetworkEngine uploadFileWithUrl:urlStr param:dic serviceName:imgParaName fileName:@"0.png" mimeType:@"image/jpeg" fileData:data successBlock:successBlock failedBlock:failedBlock];
}

/**上传多张图片
 1.urlStr         : 请求的地址
 2.dic            : 参数字典       eg. @{@"paraName1":@"paraValue1"}
 3.imgParaNameArr : 图片参数名的数组 eg. @[@"pic1",@"pic2",@"pic3"]
 4.dataArr        : 图片二进制数据(NSData) 数组
 5.successBlock   : 上传成功回调
 6.failedBlock    : 上传失败回调
 */
+(void)uploadMultipleImageWithUrl:(NSString *)urlStr param:(NSDictionary *)dic imgParaNameArr:(NSArray *)imgParaNameArr imgDataArr:(NSArray *)dataArr successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock
{
    NSMutableArray *fileNameArr = [NSMutableArray array];
    for (int i = 0; i < imgParaNameArr.count; i++) {
        [fileNameArr addObject:@"0.png"];
    }
    [KZNetworkEngine uploadFileWithUrl:urlStr param:dic serviceNameArr:imgParaNameArr fileNameArr:fileNameArr mimeType:@"image/jpeg" fileDataArr:dataArr successBlock:successBlock failedBlock:failedBlock];
}

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
+ (void)uploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock
{
    if (isEmptyStr(urlStr)) {
        failedBlock(nil);
        return ;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效
    //修改返回格式为二进制
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"image/.jpg",@"image/jpeg",nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL){
        [manager setSecurityPolicy:[KZNetworkEngine customSecurityPolicy]];
    } else {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [KZNetworkEngine setupBaseInfoWithManager:manager];
    
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            successBlock(jsonObj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
    
}

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
+(void)uploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict serviceNameArr:(NSArray *)nameArr fileNameArr:(NSArray *)fileNameArr mimeType:(NSString *)mimeType fileDataArr:(NSArray *)dataArr successBlock:(requestSuccessBlock)successBlock failedBlock:(requestFailedBlock)failedBlock
{
    if (fileNameArr.count != dataArr.count || nameArr.count != fileNameArr.count) {
        NSLog(@"fileNameArr,dataArr,nameArr数组个数不匹配，请检查传入参数!");
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];  // 此处设置content-Type生效
    //修改返回格式为二进制
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",@"image/.jpg",@"image/jpeg",nil];
    
    // 加上这行代码，https ssl 验证。
    if(openHttpsSSL){
        [manager setSecurityPolicy:[KZNetworkEngine customSecurityPolicy]];
    } else {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [KZNetworkEngine setupBaseInfoWithManager:manager];
    
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0 ; i < fileNameArr.count ; i++) {
            NSString *fileName = fileNameArr[i];
            NSData *data = dataArr[i];
            NSString *name = nameArr[i];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            successBlock(jsonObj);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

+ (void)setupBaseInfoWithManager:(AFHTTPSessionManager *)manager
{
    [manager.requestSerializer setValue:sessionID forHTTPHeaderField:@"KZ-SessionId"];
    [manager.requestSerializer setValue:pushID forHTTPHeaderField:@"KZ-DeviceId"];
    [manager.requestSerializer setValue:deviceInfo forHTTPHeaderField:@"KZ-DeviceType"];
    if (kToken != nil) {
        [manager.requestSerializer setValue:kToken forHTTPHeaderField:@"KZ-Token"];
        NSLog(@">>>>%@>>>>%@>>>>%@>>>>%@",sessionID,pushID,deviceInfo,kToken);
    }
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    NSLog(@"===>%@",certData);
    
    if (certData) {
        securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    }
    
    return securityPolicy;
}

@end
