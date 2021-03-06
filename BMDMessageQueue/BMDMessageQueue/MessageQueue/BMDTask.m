//
//  BMDTask.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDTask.h"

@implementation BMDTask

- (instancetype)init {
    self = [super init];
    if (self) {
        self.queueType = @(0);
        self.str = @"sdff";
    }
    return self;
}

- (void)processMessage:(BMDMessage *)message {
}

- (void)processCallbackMessage:(BMDMessage *)message
                 parentMessage:(BMDMessage *)parentMessage {
    [parentMessage removeChildMessage:message];
    
}
- (void)processCancelMessage:(BMDMessage *)message {
    for (BMDMessage *child in message) {
        [[BMDMessageQueue getInstance] internalAsyncCancelMessage:child];
    }
    [message cleanChildMessage];
}
@end
