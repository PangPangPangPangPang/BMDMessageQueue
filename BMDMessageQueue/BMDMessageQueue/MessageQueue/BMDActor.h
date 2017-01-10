//
//  BMDActor.h
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDMessage.h"

@interface BMDActor : NSObject
-(void)processFusionNativeMessage:(BMDMessage *)message;

@end
