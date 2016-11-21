//
//  ProgressHUD.h
//  好心人
//
//  Created by zwz on 15/9/19.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject

+ (id) sharedInstance;

/**
 * 正常模式的显示SVProgressView
 */
-(void)showNormalStateSVHUDWithTitle:(NSString *)title;

/**
 * 正常模式的显示和隐藏SVProgressView
 */
-(void)showNormalStateSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * 成功模式的显示和隐藏SVProgressView
 */
-(void)showSuccessSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay animaton:(BOOL)animation;

/**
 * 失败模式的显示和隐藏SVProgressView
 */
-(void)showErrorSVHudWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay;

/**
 * 直接隐藏SVProgressView
 */
-(void)dismissSVHud;
@end
