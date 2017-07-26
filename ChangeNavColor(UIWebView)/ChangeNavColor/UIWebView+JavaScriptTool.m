
//
//  UIWebView+JavaScriptTool.m
//  ChangeNavColor
//
//  Created by Mike on 16/8/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UIWebView+JavaScriptTool.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation UIWebView (JavaScriptTool)

- (void)injectJavaScriptMethodWithName:(NSString *)methodName implementBlock:(void (^)(void))implementBlock {
    if (!self) return;
    if (methodName.length && implementBlock) {
        JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[methodName] = implementBlock;
    }
}

- (void)injectJavaScriptObjectWithName:(NSString *)objectName object:(id)object {
    if (!self) return;
    if (objectName.length && object) {
        JSContext *context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[objectName] = object;
    }
}

- (NSString *)getCurrentPageTitle {
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSString *)getCurrentPageURL {
    return [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

@end
