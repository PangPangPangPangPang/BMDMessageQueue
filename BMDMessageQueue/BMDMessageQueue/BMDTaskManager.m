//
//  BMDTaskContainer.m
//  BMDMessageQueue
//
//  Created by Wang,Yefeng on 13/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDTaskManager.h"
#import "BMDMessage.h"

@implementation BMDTaskManager

- (void)prepareForContainer:(NSMutableDictionary *)container {
    _taskContainer = container;
}
- (BMDTask *)fetchTaskWithMessage:(BMDMessage *)message {
    
    return [_taskContainer valueForKey:message.task];
}

@end
