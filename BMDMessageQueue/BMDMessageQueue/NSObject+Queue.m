//
//  NSObject+Queue.m
//  BMDMessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "NSObject+Queue.h"
#import "BMDMessageQueueEx.h"
#import "objc/runtime.h"

@implementation NSObject (Queue)

- (void)setMessageArray:(NSMutableArray *)messageArray {
    objc_setAssociatedObject(self, "messageArray", messageArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)messageArray {
    id value = objc_getAssociatedObject(self, "messageArray");
    if (value == nil) {
        NSMutableArray *array = [NSMutableArray new];
        objc_setAssociatedObject(self, "messageArray", array, OBJC_ASSOCIATION_RETAIN);
        return array;
    }
    return value;
}

- (void)setMessageCallbackDic:(NSMutableDictionary *)messageCallbackDic {
    objc_setAssociatedObject(self, "messageCallbackDic", messageCallbackDic, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)messageCallbackDic {
    id value = objc_getAssociatedObject(self, "messageCallbackDic");
    if (value == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, "messageCallbackDic", dic, OBJC_ASSOCIATION_RETAIN);
        return dic;
    }
    return value;
}

- (void)sendMessage:(BMDMessage *)message callBack:(SEL)selector {
    [[self messageCallbackDic] setObject:@{@"callback":NSStringFromSelector(selector)}
                                  forKey:[NSValue valueWithPointer:(void*)message]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageCallBack:)
                                                 name:BMDNotification
                                               object:message];
    [self.messageArray addObject:message];
    [[BMDMessageQueue getInstance] asyncSendMessage:message];
}

- (void)messageCallBack:(NSNotification *)noti {
    BMDMessage *message = (BMDMessage *)noti.object;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:BMDNotification
                                                  object:message];
    NSDictionary *args = [[self messageCallbackDic] objectForKey:[NSValue valueWithPointer:(void *)message]];
    if ([args valueForKey:@"callback"]) {
        [self performSelector:NSSelectorFromString([args valueForKey:@"callback"]) withObject:message];
    }else {
        if (message.state == BMDMessageFailed) {
            [self performSelector:@selector(processMessageSuccess:) withObject:message];
        }else if (message.state == BMDMessageFinish) {
            [self performSelector:@selector(processMessageFailed:) withObject:message];
        }
    }
}

- (void)processMessageSuccess:(BMDMessage *)message { 
}
- (void)processMessageFailed:(BMDMessage *)message {
}

@end
