//
//  MSServerManager.m
//  VKVideo
//
//  Created by Максим Стегниенко on 17.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import "MSServerManager.h"
#import "MSLoginViewController.h"
#import "MSAccessToken.h"
#import "MSVideo.h"

@interface MSServerManager()

@property (strong,nonatomic) NSURLSession* session;
@property (strong , nonatomic) MSAccessToken *accessToken;

@end

@implementation MSServerManager

+ (MSServerManager*) sharedManager {
    
    
    static MSServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MSServerManager alloc] init];
    });
    
    return manager;
    
}


- (void) authorizeUser:(void(^)(MSUser* user)) completion {
    
    MSLoginViewController* vc =
    [[MSLoginViewController alloc] initWithCompletionBlock:^(MSAccessToken *token) {
     
        
        if (token) {
            
          self.accessToken = token;
            
        } else if (completion) {
            completion(nil);
        }
        
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
 
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}



-(NSString*) baseURL {
    return @"https://api.vk.com/method/";
}


- (void) getVideosWithSearch:(NSString*) filterString
                  withOffset:(NSInteger) offset
               onSuccess:(void(^)(NSArray* videosArray)) success
              onFailture:(void(^)(NSError* error)) failure {
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *stringWithMethod = [[self baseURL] stringByAppendingString:@"video.search"];
    NSString *URLString = [NSString stringWithFormat:@"%@?q=%@&sort=2&adult=0&filters=mp4&offset=%d&count=40&access_token=%@",stringWithMethod,filterString,offset,self.accessToken.token];

    
    
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        if (data) {
            
            NSDictionary *dictionaryOfVideos = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *arrOfDictionary = [dictionaryOfVideos objectForKey:@"response"];
           
            
            NSMutableArray *videoArr = [NSMutableArray array];
         
            
            for (NSDictionary *dict in arrOfDictionary) {
                
                MSVideo* video = [[MSVideo alloc] initWithServerResponse:dict];
                
                [videoArr addObject:video];
            }
            
            
        
            NSArray *videoArray = [NSArray arrayWithArray:videoArr];
            
            if(success) {
                success(videoArray);
            }
            
        }
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
        }
        
        
        
    }];
    [task resume];
    
}




@end
