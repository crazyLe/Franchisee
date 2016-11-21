//
//  KZNavitationController.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZNavitationController.h"

@interface KZNavitationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation KZNavitationController

/** 第一次调用类的时候会调用该方法 */
+ (void)initialize {
    // 设置UINavigationBar的主题
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
}

/** 设置UINavigationBar的主题 */
+ (void)setupNavigationBarTheme {
    // 通过设置 appearance对象，能够修改整个项目中所有UINavigationBar的样式
    UINavigationBar *appearance = [UINavigationBar appearance];

    // 设置UIBarButtonItem的tintColor
    appearance.tintColor = [UIColor colorWithHexString:@"#333333"];

    // 设置UINavigationBar的背景色 及titleView文字属性
    [appearance setBarTintColor:[UIColor whiteColor]];

//    NSShadow *shadow   = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor colorWithWhite:0.0 alpha:1];
//    NSDictionary *attributes  = [NSDictionary
//                          dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor colorWithHexString:@"#33333"], [UIFont systemFontOfSize:17.0f], shadow, nil]
//                          forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, NSFontAttributeName, NSShadowAttributeName, nil]];
//    [appearance setTitleTextAttributes:attributes];

}

/** 设置UIBarButtonItem的主题 */
+ (void)setupBarButtonItemTheme {
    //通过设置 appearance对象，能够修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];

    // 设置文字的属性
    // 1.设置普通状态下文字的属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    // 设置字体
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];

    // 设置颜色为
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#333333"];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];

    // 2.设置高亮状态下文字的属性
    NSMutableDictionary *hightextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    // 设置颜色
    hightextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#666666"];
    [appearance setTitleTextAttributes:hightextAttrs forState:UIControlStateHighlighted];

    // 3.设置不可用状态下文字的属性
    NSMutableDictionary *disabletextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disabletextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disabletextAttrs forState:UIControlStateDisabled];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
}


#pragma mark - Override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    // 如果现在push的不是栈顶控制器，则隐藏tabbar工具条
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.backgroundColor = [UIColor clearColor];
        leftButton.frame = CGRectMake(0, 0, 55, 50);
        [leftButton setImage:[UIImage imageNamed:@"icon_nav_backArrow"] forState:UIControlStateNormal];
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0,-5,0,0);
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        leftButton.autoresizesSubviews = YES;
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        leftButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
        [leftButton addTarget:self action:@selector(backHandle) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }

    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigaionControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([navigationController.viewControllers count] == 1) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            navigationController.interactivePopGestureRecognizer.enabled = YES;
            animated = NO;//如果未使用删除
        }
    }
}

#pragma mark - backHandle
- (void)backHandle {
    [self popViewControllerAnimated:YES];
}

@end
