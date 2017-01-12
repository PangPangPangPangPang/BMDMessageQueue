//
//  Message.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDMessage.h"

@implementation BMDMessage

- (id)initWithActor:(NSString *)actor
               args:(NSDictionary *)args {
    self = [super initWithHost:Scheme
                      relative:actor
                       command:nil
                          args:args];
    if (self) {
        _dataTable = [NSMutableDictionary new];
        _children = [NSMutableArray new];
    }
    return self;

}

- (NSString *)actor {
    return self.relative;
}
- (void)addChildMessage:(BMDMessage *)message {
    [self.children addObject:message];
    message.parent = self;
}

- (void)removeChildMessage:(BMDMessage *)message {
    if ([self.children containsObject:message]) {
        [self.children removeObject:message];
        message.parent = nil;
    }
}
- (void)cleanChildMessage {
    for (BMDMessage *message in self.children) {
        message.parent = nil;
    }
    [self.children removeAllObjects];
}

- (void)setState:(NSInteger)state {
    if (self.state == state) return;
    if (self.state == BMDMessageFinish
        || self.state == BMDMessageFailed) {
        for (BMDMessage *child in self.children) {
            [[BMDMessageQueue getInstance] internalAsyncCancelMessage:child];
        }
        [self cleanChildMessage];
    }
    switch (state) {
        case BMDMessageFinish:
            if (_originThread) {
                [self performSelector:@selector(processMessageCallBackOnOriginThread:)
                             onThread:_originThread
                           withObject:self
                        waitUntilDone:NO];
            }else {
                [[BMDMessageQueue getInstance] internalAsyncCallbackMessage:self];
            }
            break;
        case BMDMessageFailed:
            if (_originThread) {
                [self performSelector:@selector(processMessageCallBackOnOriginThread:)
                             onThread:_originThread
                           withObject:self
                        waitUntilDone:NO];
            }else {
                [[BMDMessageQueue getInstance] internalAsyncCallbackMessage:self];
            }
            break;
            
        default:
            break;
    }
}

- (void)processMessageCallBackOnOriginThread:(BMDBaseMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:BMDNotification
                                                        object:message];
}

- (void)dealloc {
    NSLog(@"%@----dealloc",self);
}
@end
