//
//  MSVideo.m
//  VKVideo
//
//  Created by Максим Стегниенко on 25.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import "MSVideo.h"

@implementation MSVideo

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.labelOfVideo = [responseObject objectForKey:@"title"];
        self.photoOfVideo = [NSURL URLWithString:[responseObject objectForKey:@"image_medium"]];
        NSString *duration = [responseObject objectForKey:@"duration"];
        NSString *playerURL = [responseObject objectForKey:@"player"];
        self.duration = [self durationOfVideoFromString:duration];
        
        self.playerURL = [NSURL URLWithString:playerURL];
        
        
        
    }
    return self;
}

- (NSString*) durationOfVideoFromString:(NSString*) string  {
    
    int number = [string integerValue];
    
    NSString *duration ;
    
    if (number < 60) {
        
        duration = [NSString stringWithFormat:@"%ds",number];
        
        
    }
    else if ((number >= 60) && (number < 3600)) {
        
        int minute = number / 60;
        
        int sec = number % 60;
        
        duration = [NSString stringWithFormat:@"%dm %ds",minute,sec];
    }
    else {
         int sec = number % 60;
        int minute = number % 60;
        int hour = number / 60;
        duration = [NSString stringWithFormat:@"%dh %dm %ds",hour,minute,sec];
        
    }
    
    return duration;
    
    
}



@end
