//
//  ViewController.m
//  WKWebViewTest
//
//  Created by Mike on 16/8/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIColor+Create.h"
#import "WKScriptMessageHandlerImplement.h"
#import "YYWeakProxy.h"

@interface WKWebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, UIGestureRecognizerDelegate>

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
//    [userContentController addScriptMessageHandler:self name:@"changeNavigationBarColor"];
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.userContentController = userContentController;
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, 20) configuration:config];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[WKWebViewConfiguration new]];
    [self.view addSubview:webView];
    
    
    // oc call js 将准备好的js代码注入到webView中
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:@"document.body.style.background = \"#077\";" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:userScript];
    NSString *jsString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tools.js" ofType:nil] encoding:NSUTF8StringEncoding error:NULL];
    userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:userScript];
    // js call oc, 准备js可以直接调用的OC方法
//    __weak typeof (self) weakSelf = self; // 依然循环引用
    [webView.configuration.userContentController addScriptMessageHandler:(WKWebViewController *)[YYWeakProxy proxyWithTarget:self] name:@"changeNavigationBarColor"]; // 解除，方法一
//    [webView.configuration.userContentController addScriptMessageHandler:[WKScriptMessageHandlerImplement new] name:@"changeNavigationBarColor"]; // 解除 方法二
    
    /* 相比UIWebView的优势是：跳转页无须再次注入，只要是一个webView就会公用userContentController
     
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnWebView:)];
    tap.delegate = self;
    [webView addGestureRecognizer:tap];
    self.webView = webView;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
}

- (void)dealloc {
    
}

- (void)tapOnWebView:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    NSString *jsString = [NSString stringWithFormat:@"imageSourceStringFromPoint(%f, %f);", point.x, point.y];
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (!error && result != nil && ![result isEqual:[NSNull null]]) {
            NSLog(@"%@", result);
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"changeNavigationBarColor"]) {
        NSLog(@"%@", message.body);
        if ([message.body isKindOfClass:[NSString class]] && [message.body length] > 0) {
            [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:message.body]];
            NSLog(@"%@", message.frameInfo);
            NSLog(@"%@", message.webView);
//            message.
            // 如果这里进行的是一个取照片的操作，如何处理，取得的照片数据
            {
                NSString *result = @"changed success";
                [self.webView evaluateJavaScript:[NSString stringWithFormat:@"alert(\'%@\');", result] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                    if (error) NSLog(@"%@", error);
                }];
            }
        }
    }
}

#pragma mark - WKUIDelegate
/**
 创建一个新的web view
 If you do not implement this method, the web view will cancel the navigation.
 
 configuration 创建新的web view时使用的config
 navigationAction 促使创建新的web view的action的类型
 windowFeatures页面请求到的窗口特征
 返回一个新web view或者nil
 返回的web view必须是根据指定的config创建的。WebKit会在返回的web view中加载这个请求。
 
 如果你不想实现这个方法， web view会取消导航
 */
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}

/**
 通知你的app DOM window对象的close()方法成功地执行完毕。
 你的app应该在视图层次中移除，然后按需要更新UI，例如当关闭内部的browser tab或者window
 */
- (void)webViewDidClose:(WKWebView *)webView {

}


/**
 
展示一个js alert弹窗
 @param message 要展示的信息
 @param frame 关于这个调用js的frame的信息
 @param completionHandler 完成的处理，要在alert弹窗消失的之后调用。
 为了用户安全，你的app应该注意这个问题：一个指定的站点控制着弹窗的内容。一个简单的识别受控站点标识是frame.request.URL.host。这个弹窗应该有一个单一(统一的)OKbutton。
 
 如果不实现这个方法，web view表现为执行了点击OK button。
 
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tip" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alertView show];
    completionHandler();
}

/**
 展示一个js confirm弹窗
 @param message 要展示的信息
 @param frame 关于这个调用js的frame的信息
 @param completionHandler 完成的处理，在confirm弹窗消失的之后调用。传递YES如果用户选择了OK，如果用户选择了取消则传递NO.
 为了用户的安全性，你的app应该注意到这个问题：一个指定的站点控制着弹窗的内容。一个简单的识别受控站点标识是frame.request.URL.host。这个谭传应该有2个button，比如OK和Cancel。
 
 如果你不实现这个方法，web view会表现为执行了点击Cancel button。
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {

}

/**
 展示一个js text input面板
 @param message 要展示的信息
 @param defaultText 在文本域要展示的初始信息
 @param frame 关于这个调用js的frame的信息
 @param completionHandler 完成的处理，在text input弹窗消失的之后调用。如果用户选择OK则传递输入文本，否则传递nil。
 为了用户的安全性，你的app应该注意这个问题：一个指定的站点控制着弹窗的内容。一个简单的识别受控站点标识是frame.request.URL.host。这个弹窗应该有2个button，例如OK和Cancel，还有一个用来输入文字的文本域。
 
 如果你不实现这个方法，web view会表现为用户点击了Cancel button。
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
}

#pragma mark - WKNavigationDelegate

/**
 决定是否允许或者取消导航。
 @param navigationAction 关于触发导航请求的action的描述性信息。
 @param decisionHandler 处理方法，调用它用来允许或者取消导航。参数是WKNavigationActionPolicy这个枚举类型的值。
 
 如果你没有实现这个方法， web view会加载请求，或者，如果合适的话会导向另一个应用。
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}


/**
 决定是否在得到response之后允许或者取消一个导航。
 @param navigationResponse 导航的response的描述性信息
 @param decisionHandler 处理方法，调用它用来允许或者取消导航。参数是WKNavigationResponsePolicy这个枚举类型的值。
 
 如果你没有实现这个方法，web view 会允许这个response，如果web view能够显示它。
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 当main frame导航开始时调用
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

/**
 当main frame接收到服务器重定向时调用
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

/**
 正在开始为main frame加载数据时发生了错误时调用
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

/**
 当内容开始到达main frame 时调用
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {

}


/**
 当main frame导航完成时调用
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.navigationItem.title = webView.title;
    NSLog(@"%@", webView.URL.absoluteString);
}

/**
 当main frame正在进行的导航发生错误时调用
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

/**
 当web view 需要响应一个验证质询时调用
 @param challenge 验证质询。
 @param completionHandler 完成的处理，你必须调用它来响应这个质询。disposition参数是一个NSURLSessionAuthChallengeDisposition枚举值，credential参数是要使用的凭据,或者传递nil标识继续处理而不使用任何凭据。
 
 如果你没有实现这个方法，web view会使用NSURLSessionAuthChallengeRejectProtectionSpace这个disposition参数来响应验证质询。
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
}

/**
 当web view的web content处理完成时调用
 @param webView web view ,它内部的web content已经处理完成
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {

}

@end
