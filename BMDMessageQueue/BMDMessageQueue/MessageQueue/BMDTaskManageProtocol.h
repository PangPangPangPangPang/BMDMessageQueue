//
//  BMDTaskManageProtocol.h
//  BMDMessageQueue
//
//  Created by Wang,Yefeng on 13/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMDTask;
@class BMDMessage;
@protocol BMDTaskManageProtocol <NSObject>

@optional
/**
 User can add queue for special use

 @param count ConcurrentCount of the queue
 @param type specified a queue,0 is for default work queue, 1 is for main queue,user should specified from 2.
 */
- (void)addQueueWithConcurrentCount:(NSInteger)count
                           taskType:(NSInteger)type;

- (NSDictionary<NSNumber *, NSOperationQueue *> *)generateQueueMap;


@required


@property (nonatomic, retain) id taskContainer;


/**
 add a container for manager to manage tasks

 @param container container must have a same type as taskContainer!      
                  Fuck objective-c!
                  Protocal can`t use generic!!!!
 */
- (void)prepareForContainer:(id)container;
- (BMDTask *)fetchTaskWithMessage:(BMDMessage *)message;

@end
