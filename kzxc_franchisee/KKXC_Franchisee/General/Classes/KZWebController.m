//
//  KZWebController.m
//  KKXC_Franchisee
//
//  Created by sky on 2016/10/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "KZWebController.h"

@interface KZWebController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *aWebView;
@end

@implementation KZWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupWebView];

    [self loadWebRequest];
}

- (void)setupWebView {
    self.aWebView = [[UIWebView alloc] init];
    [self.view addSubview:self.aWebView];
    [self.aWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.aWebView.delegate = self;
}

- (void)loadWebRequest {
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
    if (self.dynamicTitle) {
        NSString *urlString = webView.request.URL.absoluteString;
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = str.length > 0 ? str : urlString;
    }
}

@end
