//
//  BMDActor.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDActor.h"

@implementation BMDActor

- (void)processFusionNativeMessage:(BMDMessage *)message {
    if ([message.dataTable valueForKey:@"success"]) {
        message.state == BMDMessageFinish;
    }
}

@end
