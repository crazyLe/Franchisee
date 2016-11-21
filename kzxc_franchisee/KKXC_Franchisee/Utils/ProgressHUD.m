//
//  ProgressHUD.m
//  好心人
//
//  Created by zwz on 15/9/19.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import "ProgressHUD.h"
#import <SVProgressHUD.h>
static ProgressHUD *progressView = nil;
@interface ProgressHUD ()


@end

@implementation ProgressHUD

+(instancetype)sharedInstance {
    @synchronized(self) {
        if (progressView == nil) {
            
            progressView = [[ProgressHUD alloc]init];

            //SVProgressView配置
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//无蒙版，无交互
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//黑色风格
        }
    }
    return progressView;
}

-(void)showNormalStateSVHUDWithTitle:(NSString *)title {
    if (title == nil) {
        [SVProgressHUD show];
    } else {
        [SVProgressHUD showWithStatus:title];
    }
}

-(void)showNormalStateSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay {
    if (title == nil) {
        [SVProgressHUD show];
    } else {
        [SVProgressHUD showWithStatus:title];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void)showSuccessSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation {
    [SVProgressHUD showSuccessWithStatus:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void)showErrorSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay {
    [SVProgressHUD showErrorWithStatus:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void)dismissSVHud {
    [SVProgressHUD dismiss];
}


@end
