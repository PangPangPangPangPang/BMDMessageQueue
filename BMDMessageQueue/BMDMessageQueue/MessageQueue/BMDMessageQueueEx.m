//
//  MessageQueue.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDMessageQueueEx.h"

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
        [_actorMap setValue:@"BMDSleepActor" forKey:@"sleep"];
        _workQueue = [NSOperationQueue new];
        [_workQueue setMaxConcurrentOperationCount:Max_Worker_Thread];
        
    }
    return self;
}

- (void)asyncSendMessage:(BMDMessage *)message {
    message.originThread = [NSThread currentThread];
    [_workQueue addOperationWithBlock:^{
        BMDActor *actor = [NSClassFromString([_actorMap valueForKey:message.actor]) new];
        [actor processFusionNativeMessage:message];
    }];
}

@end
