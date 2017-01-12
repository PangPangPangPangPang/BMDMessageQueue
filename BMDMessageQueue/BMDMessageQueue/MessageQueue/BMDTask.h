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

@interface BMDTask : NSObject
-(void)processMessage:(BMDMessage *)message;

- (void)processCallbackMessage:(BMDMessage *)message
                 parentMessage:(BMDMessage *)parentMessage;

- (void)processCancelMessage:(BMDMessage *)message;

@end
