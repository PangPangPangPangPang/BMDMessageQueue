//
//  BMDDeeperActor.m
//  App
//
//  Created by Wang,Yefeng on 11/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDDeeperActor.h"

@implementation BMDDeeperActor

- (void)processMessage:(BMDMessage *)message {
    [message.dataTable addEntriesFromDictionary:@{@"deeper": @"xixi"}];
    [message setState:BMDMessageFinish];
}

- (void)processCallbackMessage:(BMDMessage *)message
                 parentMessage:(BMDMessage *)parentMessage {
    [super processCallbackMessage:message
                    parentMessage:parentMessage];
    
    NSLog(@"%@",message.dataTable);
    [parentMessage setState:BMDMessageFinish];
}

@end
