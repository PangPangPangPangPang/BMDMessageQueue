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
        _actorMap = [NSMutableDictionary new];
        [_actorMap setValue:[NSClassFromString(@"BMDSleepActor") new] forKey:@"sleep"];
        [_actorMap setValue:[NSClassFromString(@"BMDDeeperActor") new] forKey:@"deeper"];
        _workQueue = [NSOperationQueue new];
        [_workQueue setMaxConcurrentOperationCount:Max_Worker_Thread];
        
    }
    return self;
}

- (void)asyncSendMessage:(BMDMessage *)message {
    message.originThread = [NSThread currentThread];
    [_workQueue addOperationWithBlock:^{
        BMDTask *actor = [_actorMap valueForKey:message.actor];
        [actor processMessage:message];
    }];
}

- (void)internalAsyncSendMessage:(BMDMessage *)message {

    [_workQueue addOperationWithBlock:^{
        BMDTask *actor = [_actorMap valueForKey:message.actor];
        [actor processMessage:message];
    }];
}

- (void)internalAsyncCallbackMessage:(BMDMessage *)message {
    [_workQueue addOperationWithBlock:^{
        BMDTask *actor = [_actorMap valueForKey:message.actor];
        [actor processCallbackMessage:message
                        parentMessage:message.parent];
    }];
}
- (void)internalAsyncCancelMessage:(BMDMessage *)message {
    [_workQueue addOperationWithBlock:^{
        BMDTask *actor = [_actorMap valueForKey:message.actor];
        
    }];
}

@end
