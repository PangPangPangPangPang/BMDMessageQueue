//
//  NSObject+Queue.h
//  BMDMessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BMDMessage.h"

@interface NSObject (Queue)
- (void)sendMessage:(BMDMessage *)message callBack:(SEL)selector;
@end
