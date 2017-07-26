//
//  ViewController.m
//  ChangeNavColor
//
//  Created by Mike on 16/8/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *redButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 40, 20)];
    redButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:redButton];
    redButton.tag = 1;
    [redButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *greenButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 40, 20)];
    greenButton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenButton];
    greenButton.tag = 2;
    [greenButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"%@", [NSBundle bundleForClass:[NSArray class]]);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)buttonDidClicked:(UIButton *)sender {
    WKWebViewController *webViewController = [WKWebViewController new];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
