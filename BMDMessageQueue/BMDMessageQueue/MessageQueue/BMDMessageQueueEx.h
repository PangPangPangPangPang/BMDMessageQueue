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

@property (nonatomic, strong)NSMutableDictionary<NSString *, NSString *> *taskMap;

+ (instancetype)getInstance;

- (void)prepareServices:(NSDictionary *)services;

- (void)asyncSendMessage:(BMDMessage *)message;
- (void)asyncSendMessages:(NSArray<BMDMessage *> *)messages;
- (void)asyncCancelMessage:(BMDMessage *)message;
- (void)asyncCancelMessages:(NSArray<BMDMessage *> *)messages;

- (void)internalAsyncSendMessage:(BMDMessage *)message;
- (void)internalAsyncSendMessages:(NSArray<BMDMessage *> *)messages;

- (void)internalAsyncCallbackMessage:(BMDMessage *)message;
- (void)internalAsyncCancelMessage:(BMDMessage *)message;
- (void)internalAsyncCancelMessages:(NSArray<BMDMessage *> *)messages;

@end
