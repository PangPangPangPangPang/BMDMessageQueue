//
//  MessageQueue.h
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDTask.h"

@class BMDMessage;
@interface BMDMessageQueue : NSObject

@property (nonatomic, strong, readonly)NSOperationQueue *workQueue;
@property (nonatomic, strong, readonly)NSOperationQueue *coreQueue;

@property (nonatomic, strong)NSMutableDictionary<NSString *, NSString *> *actorMap;

+ (instancetype)getInstance;

- (void)prepareServices:(NSDictionary *)services;

- (void)asyncSendMessage:(BMDMessage *)message;
- (void)asyncCancelMessage:(BMDMessage *)message;

- (void)internalAsyncSendMessage:(BMDMessage *)message;
- (void)internalAsyncCallbackMessage:(BMDMessage *)message;
- (void)internalAsyncCancelMessage:(BMDMessage *)message;

@end
