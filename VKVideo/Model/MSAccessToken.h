//
//  MSAccessToken.h
//  VKVideo
//
//  Created by Максим Стегниенко on 21.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) NSString *userID;
@end
