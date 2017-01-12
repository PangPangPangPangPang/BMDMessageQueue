//
//  BMDSleepActor.m
//  App
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDSleepActor.h"
#import "BMDDeeperActor.h"

@implementation BMDSleepActor

- (void)processMessage:(BMDMessage *)message {
    [message.dataTable setDictionary:@{@"success": @"xixi"}];
    BMDMessage *child = [[BMDMessage alloc] initWithTask:@"deeper" args:nil];
    [message addChildMessage:child];
    [[BMDMessageQueue getInstance] internalAsyncSendMessage:child];
}

- (void)processCallbackMessage:(BMDMessage *)message
                 parentMessage:(BMDMessage *)parentMessage {
    [parentMessage removeChildMessage:message];
}


@end
