//
//  CPByTicketViewController.m
//  CarPlay
//
//  Created by chewan on 10/27/15.
//  Copyright © 2015 chewan. All rights reserved.
//

#import "CPByTicketViewController.h"

@interface CPByTicketViewController ()<UIWebViewDelegate>

@end

@implementation CPByTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购票";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
}

@end
