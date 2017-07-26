//
//  WKScriptMessageHandlerImplement.m
//  WKWebViewTest
//
//  Created by Mike on 16/8/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "WKScriptMessageHandlerImplement.h"

@implementation WKScriptMessageHandlerImplement

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"changeNavigationBarColor"]) {
        NSLog(@"%@", message.body);
//        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:message.body]];
    }
}

@end
