//
//  Message.h
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDMessageQueueEx.h"
#import "BMDBaseMessage.h"

#define BMDMessageOrigin 0
#define BMDMessageFinish 1
#define BMDMessageFailed 2

#define BMDNotification @"BMDNotification"

@interface BMDMessage : BMDBaseMessage

@property (nonatomic, strong)NSThread *originThread;

@property (nonatomic, strong)NSMutableDictionary *dataTable;

@property (nonatomic, strong)BMDMessage *parent;
@property (nonatomic, strong)NSMutableArray *children;

@property (nonatomic, assign)NSInteger state;

@property (nonatomic, strong)NSString *actor;

- (id)initWithActor:(NSString *)actor
               args:(NSDictionary *)args;

- (void)addChildMessage:(BMDMessage *)message;
- (void)removeChildMessage:(BMDMessage *)message;
- (void)cleanChildMessage;
@end
