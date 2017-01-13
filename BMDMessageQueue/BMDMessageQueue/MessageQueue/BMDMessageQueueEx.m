//
//  MessageQueue.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDMessageQueueEx.h"
#import "BMDMessage.h"

#define Max_Worker_Thread   sysconf(_SC_NPROCESSORS_CONF) * 2

@implementation BMDMessageQueue

static BMDMessageQueue  *_instance = nil;
+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [BMDMessageQueue new];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _coreQueue = [NSOperationQueue new];
        [_coreQueue setMaxConcurrentOperationCount:1];
        
        _workQueue = [NSOperationQueue new];
        [_workQueue setMaxConcurrentOperationCount:Max_Worker_Thread];
        _queueMap = [NSMutableDictionary dictionaryWithDictionary:@{
                      @0 : _workQueue,
                      @1: [NSOperationQueue mainQueue]
                      }];
        
    }
    return self;
}

- (void)prepareWithTaskManager:(id<BMDTaskManageProtocol>)manager {
    _taskManager = manager;
    if ([manager respondsToSelector:@selector(generateQueueMap)]) {
        [_queueMap addEntriesFromDictionary:[manager generateQueueMap]];
    }
}

- (void)asyncSendMessage:(BMDMessage *)message {
    [_coreQueue addOperationWithBlock:^{
    //external call need to mark origin thread
        message.originThread = [NSThread currentThread];
        [self dispatchNormalMessage:message];
    }];
}

- (void)asyncSendMessages:(NSArray<BMDMessage *> *)messages {
    for (BMDBaseMessage *message in messages) {
        [self asyncSendMessage:messages];
    }
}
- (void)asyncCancelMessage:(BMDMessage *)message {
    [_coreQueue addOperationWithBlock:^{
        [self dispatchCancelMessage:message];
    }];
}
- (void)asyncCancelMessages:(NSArray<BMDMessage *> *)messages {
    for (BMDMessage *message in messages) {
        [self asyncCancelMessage:message];
    }
}

- (void)internalAsyncSendMessage:(BMDMessage *)message {
    [_coreQueue addOperationWithBlock:^{
        [self dispatchNormalMessage:message];
    }];
}

- (void)internalAsyncSendMessages:(NSArray<BMDMessage *> *)messages {
    for (BMDMessage *message in messages) {
        [self internalAsyncSendMessage:message];
    }
}

- (void)internalAsyncCallbackMessage:(BMDMessage *)message {
    [_coreQueue addOperationWithBlock:^{
        [self dispatchCallbackMessage:message];
    }];
}
- (void)internalAsyncCancelMessage:(BMDMessage *)message {
    [_coreQueue addOperationWithBlock:^{
        [self dispatchCancelMessage:message];
    }];
}

- (void)internalAsyncCancelMessages:(NSArray<BMDMessage *> *)messages {
    for (BMDMessage *message in messages) {
        [self internalAsyncCancelMessage:message];
    }
}

#pragma mark - dispatch message
- (void)dispatchNormalMessage:(BMDMessage *)message {
    BMDTask *task = [_taskManager fetchTaskWithMessage:message];
    [[self fetchQueueWithTask:task] addOperationWithBlock:^{
        [task processMessage:message];
    }];
}

- (void)dispatchCancelMessage:(BMDMessage *)message {
    BMDTask *task = [_taskManager fetchTaskWithMessage:message];
    [[self fetchQueueWithTask:task] addOperationWithBlock:^{
        [task processCancelMessage:message];
    }];
    
}

- (void)dispatchCallbackMessage:(BMDMessage *)message {
    BMDTask *task = [_taskManager fetchTaskWithMessage:message];
    [[self fetchQueueWithTask:task] addOperationWithBlock:^{
        [task processCallbackMessage:message
                       parentMessage:message.parent];
    }];
}

- (NSOperationQueue *)fetchQueueWithTask:(BMDTask *)task {
    return [_queueMap objectForKey:task.queueType];
}

@end
