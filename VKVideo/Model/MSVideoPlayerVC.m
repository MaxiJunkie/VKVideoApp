//
//  MSVideoPlayerVC.m
//  VKVideo
//
//  Created by Максим Стегниенко on 25.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import "MSVideoPlayerVC.h"

@interface MSVideoPlayerVC () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation MSVideoPlayerVC




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
    
    self.navigationItem.title = @"VideoPlayer";

    
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UIWebView *videoPlayerWebView = [[UIWebView alloc] initWithFrame:frame];
    videoPlayerWebView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:videoPlayerWebView];
    
    self.webView = videoPlayerWebView;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:self.playerURL];
    
    videoPlayerWebView.delegate = self;
    
    [videoPlayerWebView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) actionCancel:(UIBarButtonItem*) item {
    
    
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
