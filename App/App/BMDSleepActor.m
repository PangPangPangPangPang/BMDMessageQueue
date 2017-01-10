//
//  BMDSleepActor.m
//  App
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDSleepActor.h"

@implementation BMDSleepActor

- (void)processFusionNativeMessage:(BMDMessage *)message {
    [message.dataTable setDictionary:@{@"success": @"xixi"}];
    sleep(2);
    [message setState:BMDMessageFinish];
}

@end
