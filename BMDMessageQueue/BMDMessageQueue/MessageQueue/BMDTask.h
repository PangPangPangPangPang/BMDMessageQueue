//
//  BMDTask.h
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDMessage.h"
#import "NSObject+Queue.h"

#define BMDTaskWorkQueue 0
#define BMDTaskMainQueue 1

@interface BMDTask : NSObject 

@property (nonatomic, strong)NSNumber * queueType;
@property (nonatomic, strong)NSString *str;

-(void)processMessage:(BMDMessage *)message;

- (void)processCallbackMessage:(BMDMessage *)message
                 parentMessage:(BMDMessage *)parentMessage;

- (void)processCancelMessage:(BMDMessage *)message;

@end
