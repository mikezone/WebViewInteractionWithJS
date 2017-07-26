//
//  UIColor+ConvenientInitializer.h
//
//  Created by Mike on 15/4/10.
//  Copyright (c) 2015年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ConvenientInitializer)

+ (UIColor *)colorWithHex:(NSString *)hexColor;
+ (UIColor *)colorWithRandom6;
+ (UIColor *)colorWithRandom;

@end
