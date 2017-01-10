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
    }
    return self;

}

- (NSString *)actor {
    return self.relative;
}

- (void)setState:(NSInteger)state {
    switch (state) {
        case BMDMessageFinish:
            if (_originThread) {
                [self performSelector:@selector(processMessageCallBack:)
                             onThread:_originThread
                           withObject:self
                        waitUntilDone:NO];
            }
            break;
        case BMDMessageFailed:
            if (_originThread) {
                [self performSelector:@selector(processMessageCallBack:)
                             onThread:_originThread
                           withObject:self
                        waitUntilDone:NO];
            }
            break;
            
        default:
            break;
    }
}

- (void)processMessageCallBack:(BMDBaseMessage *)message {
    [[NSNotificationCenter defaultCenter] postNotificationName:BMDNotification
                                                        object:message];
}
@end
