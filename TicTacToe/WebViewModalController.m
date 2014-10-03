//
//  WebViewModalController.m
//  TicTacToe
//
//  Created by Richmond on 10/2/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "WebViewModalController.h"

@interface WebViewModalController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewModalController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://en.wikipedia.org/wiki/Tic-tac-toe"]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [self.webView loadRequest:urlRequest];

    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
