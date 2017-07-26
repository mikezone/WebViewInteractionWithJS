//
//  WebViewController.m
//  ChangeNavColor
//
//  Created by Mike on 16/8/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIColor+Create.h"
#import "UIWebView+JavaScriptTool.h"
#import "JSExportCameraImplement.h"

@interface WebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    webView.delegate = self;
    
//    NSString *fileName = [NSString stringWithFormat:@"%zd.html", _tag];
//    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.170.48/jsOC.html"]]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.130.62:8080/changzhiList/app/"]]];
    
}

- (void)dealloc {
    
}

#pragma mark - OC methed mapping

//- (void)test {
//    NSLog(@"%@", [NSThread currentThread]);
//    NSLog(@"object method testing");
//}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = [webView getCurrentPageTitle];
    NSLog(@"%@", [webView getCurrentPageURL]);
    
//    __weak typeof (self) weakSelf = self;
//    [webView injectJavaScriptMethodWithName:@"changeNavigationBarColor" implementBlock:^{
//        NSArray *args = [JSContext currentArguments];
//        if (args.count && args.firstObject) {
//            JSValue *jsColor = args.firstObject;
//            [weakSelf.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:[jsColor toString]]];
//        }
//    }];
//    [webView injectJavaScriptObjectWithName:@"hello" object:weakSelf]; // 并不能解除循环引用
//    [webView injectJavaScriptObjectWithName:@"hello" object:[JSExportCameraImplement new]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

@end
