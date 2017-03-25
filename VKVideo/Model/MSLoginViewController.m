//
//  MSLoginViewController.m
//  VKVideo
//
//  Created by Максим Стегниенко on 17.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import "MSLoginViewController.h"
#import "ViewController.h"

@interface MSLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) MSLoginBlock block;
@property (weak, nonatomic) UIWebView* webView;

@end



@implementation MSLoginViewController


- (id) initWithCompletionBlock:(MSLoginBlock) block
{
    self = [super init];
    if (self) {
        
        self.block = block;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UIWebView *loginWebView = [[UIWebView alloc] initWithFrame:frame];
    loginWebView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:loginWebView];
    
    self.webView = loginWebView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=5930937&"
    "display=mobile&"
    "scope=16&"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "v=5.62&"
    "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    loginWebView.delegate = self;
    
    [loginWebView loadRequest:request];

}



- (void) dealloc {
    self.webView.delegate = nil;
}


- (void) actionCancel:(UIBarButtonItem*) item {
    
    if (self.block) {
        self.block(nil);
    }

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
      

    if ([[[request URL] host] isEqualToString:@"oauth.vk.com"]) {
        
        MSAccessToken* token = [[MSAccessToken alloc] init];
        
        NSString* query = [[request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
     
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                    
                   
                
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                    
                    
                }
                
                
            }
        }
        
        if ((token.token) && (token.expirationDate) && (token.userID)) {
          
            self.webView.delegate = nil;
            
            if (self.block) {
                self.block(token);
            }
            
            
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
            
            return NO;
        }
    }

    return YES;
}



@end
