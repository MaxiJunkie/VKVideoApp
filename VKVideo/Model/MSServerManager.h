//
//  MSServerManager.h
//  VKVideo
//
//  Created by Максим Стегниенко on 17.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSUser ;


@interface MSServerManager : NSObject

+ (MSServerManager*) sharedManager;


- (void) getVideosWithSearch:(NSString*) filterString
                  withOffset:(NSInteger) offset
                   onSuccess:(void(^)(NSArray* videosArray)) success
                  onFailture:(void(^)(NSError* error)) failure;

- (void) authorizeUser:(void(^)(MSUser* user)) completion;

@end
