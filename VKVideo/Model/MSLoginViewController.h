//
//  MSLoginViewController.h
//  VKVideo
//
//  Created by Максим Стегниенко on 17.03.17.
//  Copyright © 2017 Максим Стегниенко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSAccessToken.h"

typedef void(^MSLoginBlock)(MSAccessToken* token);

@interface MSLoginViewController : UIViewController

- (id) initWithCompletionBlock:(MSLoginBlock) block;


@end
