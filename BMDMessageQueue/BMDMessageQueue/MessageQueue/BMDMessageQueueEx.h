//
//  MessageQueue.h
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDMessage.h"
#import "BMDActor.h"

@interface BMDMessageQueue : NSObject

@property (nonatomic, strong, readonly)NSOperationQueue *workQueue;
@property (nonatomic, strong, readonly)NSOperationQueue *coreQueue;

@property (nonatomic, strong)NSMutableDictionary<NSString *, NSString *> *actorMap;

+ (instancetype)getInstance;

- (void)asyncSendMessage:(BMDMessage *)message;

@end
