//
//  CPByTicketViewController.m
//  CarPlay
//
//  Created by chewan on 10/27/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPByTicketViewController.h"

@interface CPByTicketViewController ()

@end

@implementation CPByTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购票";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
