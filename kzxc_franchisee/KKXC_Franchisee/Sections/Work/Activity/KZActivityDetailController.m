//
//  KZActivityDetailController.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/11/3.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZActivityDetailController.h"
#import "WebViewJavascriptBridge.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>

@interface KZActivityDetailController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *aWebView;
@property(strong,nonatomic) WebViewJavascriptBridge *webBridge;
@end

@implementation KZActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self configNavigationItem];
    [self setupJSBridge];
    [self loadWebRequest];
}

- (void)configNavigationItem {
    self.navigationItem.title = @"活动详情";
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)setupJSBridge {
    //开启调试信息
    [WebViewJavascriptBridge enableLogging];
    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.webBridge = [WebViewJavascriptBridge bridgeForWebView:self.aWebView];
    // 设置代理，如果不需要实现，可以不设置
    [self.webBridge setWebViewDelegate:self];
    
    WeakObj(self)
    [self.webBridge registerHandler:@"shareHander" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *shareDic = data;
        [selfWeak shareWebpageDic:shareDic];
    }];
}

- (void)loadWebRequest {
    [self.hudManager showNormalStateSVHUDWithTitle:@"活动详情加载中..."];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.webURL]];
    [self.aWebView loadRequest:request];
}

- (void)backHandle {
    if (self.aWebView.canGoBack) {
        [self.aWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hudManager dismissSVHud];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!self.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(nativeShareHandler)];
    }
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.hudManager dismissSVHud];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"weberror" ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.aWebView loadHTMLString:htmlCont baseURL:baseURL];
}

- (void)nativeShareHandler {
    if (self.activity) {
        NSMutableDictionary *shareDic = [NSMutableDictionary dictionaryWithCapacity:4];
        NSString *detailURL = [WAP_HOST_ADD stringByAppendingFormat:@"/activity/show/%@?franchisee_id=%@",self.activity.activityId,kUid];
        [shareDic setValue:self.activity.shareTitle forKey:@"title"];
        [shareDic setValue:self.activity.shareContent forKey:@"content"];
        [shareDic setValue:self.activity.shareIcon forKey:@"icon"];
        [shareDic setValue:detailURL forKey:@"shareUrl"];
        
        [self shareWebpageDic:shareDic];
    }
}

- (void)shareWebpageDic:(NSDictionary *)shareDic {
    //显示分享面板
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView, UMSocialPlatformType platformType) {
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString *title = shareDic[@"title"];
        NSString *content = shareDic[@"content"];
        NSString *shareUrl = shareDic[@"shareUrl"];
        NSString *iconUrl = shareDic[@"icon"];
        
        if (title.length == 0) {
            title = @"康庄学车加盟商端";
        }
        if (content.length == 0) {
            content = @"康庄学车加盟商端";
        }
        
        id shareIcon = [UIImage imageNamed:@"share"];
        if (iconUrl.length > 0) {
            shareIcon = iconUrl;
        }
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:shareIcon];
        //设置网页地址
        shareObject.webpageUrl = shareUrl;
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        [weakSelf shareToPlatform:platformType messageObject:messageObject];
    }];
}

- (void)shareToPlatform:(UMSocialPlatformType)platformType messageObject:(UMSocialMessageObject *)messageObject {
    //调用分享接口
    WeakObj(self)
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (!error) {
            [selfWeak.hudManager showSuccessSVHudWithTitle:@"分享成功" hideAfterDelay:1.0 animaton:YES];
        } else {
            [selfWeak.hudManager showErrorSVHudWithTitle:@"分享失败" hideAfterDelay:1.0];
        }
    }];
}


@end
