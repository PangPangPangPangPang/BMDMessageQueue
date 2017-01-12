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
        _taskMap = [NSMutableDictionary new];
        [_taskMap setValue:[NSClassFromString(@"BMDSleepActor") new] forKey:@"sleep"];
        [_taskMap setValue:[NSClassFromString(@"BMDDeeperActor") new] forKey:@"deeper"];
        
        _coreQueue = [NSOperationQueue new];
        [_coreQueue setMaxConcurrentOperationCount:1];
        
        _workQueue = [NSOperationQueue new];
        [_workQueue setMaxConcurrentOperationCount:Max_Worker_Thread];
        
    }
    return self;
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
    [_workQueue addOperationWithBlock:^{
        BMDTask *task = [_taskMap valueForKey:message.task];
        [task processCallbackMessage:message
                        parentMessage:message.parent];
    }];
}
- (void)internalAsyncCancelMessage:(BMDMessage *)message {
    [_workQueue addOperationWithBlock:^{
        BMDTask *task = [_taskMap valueForKey:message.task];
        [task processCancelMessage:message];
    }];
}

- (void)internalAsyncCancelMessages:(NSArray<BMDMessage *> *)messages {
    for (BMDMessage *message in messages) {
        [self internalAsyncCancelMessage:message];
    }
}

#pragma mark - dispatch message
- (void)dispatchNormalMessage:(BMDMessage *)message {
    [_workQueue addOperationWithBlock:^{
        BMDTask *task = [_taskMap valueForKey:message.task];
        [task processMessage:message];
    }];
}

- (void)dispatchCancelMessage:(BMDMessage *)message {
    [_workQueue addOperationWithBlock:^{
        BMDTask *task = [_taskMap valueForKey:message.task];
        [task processCancelMessage:message];
    }];
    
}

- (void)dispatchCallbackMessage:(BMDMessage *)message {
    [_workQueue addOperationWithBlock:^{
        BMDTask *task = [_taskMap valueForKey:message.task];
        [task processCallbackMessage:message
                       parentMessage:message.parent];
    }];
}

@end
