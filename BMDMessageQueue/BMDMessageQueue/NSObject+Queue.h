//
//  NSObject+Queue.h
//  BMDMessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMDMessage;

@interface NSObject (Queue)
- (void)sendMessage:(BMDMessage *)message;
- (void)sendMessage:(BMDMessage *)message callBack:(SEL)selector;
- (void)processMessageSuccess:(BMDMessage *)message;
- (void)processMessageFailed:(BMDMessage *)message;

- (void)processCallbackMessage:(BMDMessage *)message
                 parentMessage:(BMDMessage *)parentMessage;
@end
