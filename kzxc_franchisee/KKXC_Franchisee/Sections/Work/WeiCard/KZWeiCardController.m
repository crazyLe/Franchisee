//
//  TabBarOneController.m
//  KKXC_Franchisee
//
//  Created by 翁昌青 on 16/8/3.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWeiCardController.h"
#import "WebViewJavascriptBridge.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import <YYCategories.h>

@interface KZWeiCardController ()<UIWebViewDelegate>

{
    BOOL ismain;
    
    NSString *urlStr;
}
@property(strong,nonatomic) UIWebView *aWebView;
@property(strong,nonatomic) WebViewJavascriptBridge *webBridge;
@end

@implementation KZWeiCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self configNavigationItem];
    ismain = YES;
    
    [self setupWebView];
    [self setupJSBridge];

    [self loadWebRequest];
}

- (void)configNavigationItem {
    self.navigationItem.title = @"招生微名片";
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

- (void)setupWebView {
    self.aWebView = [[UIWebView alloc] init];
    [self.view addSubview:self.aWebView];
    [self.aWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.aWebView.delegate = self;
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
    [self.hudManager showNormalStateSVHudWithTitle:@"微官网加载中..." hideAfterDelay:100];
    if (ismain) {
        urlStr = [NSString stringWithFormat:weiguanwangWebMainUrl,kUid,kUid,[kCityInfo intValue]];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",pushID,kUid,self.getcurrentTime,@"card/show"];
        NSString *sign = [str md5String];
        urlStr = [NSString stringWithFormat:weiguanwangWebEditUrl,kUid,kUid,self.getcurrentTime,sign];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.aWebView loadRequest:request];
}

- (void)backHandle {
    if (self.aWebView.canGoBack) {
        [self.aWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightAction {
    ismain = !ismain;
//    NSString *name = ismain?@"编辑":@"保存";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:name style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    [self loadWebRequest];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([request.URL.absoluteString isEqualToString:urlStr] && ismain) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hudManager dismissSVHud];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"weberror" ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.aWebView loadHTMLString:htmlCont baseURL:baseURL];
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
