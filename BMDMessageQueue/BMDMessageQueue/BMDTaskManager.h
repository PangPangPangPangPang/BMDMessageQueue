//
//  BMDTaskContainer.h
//  BMDMessageQueue
//
//  Created by Wang,Yefeng on 13/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDTaskManageProtocol.h"

@interface BMDTaskManager : NSObject<BMDTaskManageProtocol> 
@property (nonatomic, retain) NSMutableDictionary *taskContainer;

- (void)prepareForContainer:(NSMutableDictionary *)container;
- (BMDTask *)fetchTaskWithMessage:(BMDMessage *)message;
@end
