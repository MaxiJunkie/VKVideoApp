//
//  MSVideo.h
//  VKVideo
//
//  Created by Максим Стегниенко on 25.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSVideo : NSObject

@property (strong , nonatomic) NSString *labelOfVideo;
@property (strong , nonatomic) NSString *videoURL;
@property (strong , nonatomic) NSURL *photoOfVideo;
@property (strong , nonatomic) NSString *duration;
@property (strong, nonatomic) NSURL *playerURL;

- (id) initWithServerResponse:(NSDictionary*) responseObject;


@end
