//
//  UIWebView+JavaScriptTool.h
//  ChangeNavColor
//
//  Created by Mike on 16/8/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptTool)

- (void)injectJavaScriptMethodWithName:(NSString *)methodName implementBlock:(void (^)(void))implementBlock;

- (void)injectJavaScriptObjectWithName:(NSString *)objectName object:(id)object;

- (NSString *)getCurrentPageTitle;

- (NSString *)getCurrentPageURL;

@end
