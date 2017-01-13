//
//  BMDBaseMessage.h
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Scheme @"BMDoctor"
@interface BMDBaseMessage : NSObject
@property(readonly, atomic)NSString *scheme;
@property(readonly, atomic)NSString *host;
@property(readonly, atomic)NSString *relative;
@property(readonly, atomic)NSString *command;
@property(readonly, atomic)NSDictionary *args;

- (id)initWithHost:(NSString *)host
          relative:(NSString *)relative
           command:(NSString *)command
              args:(NSDictionary *)args;

- (id)initWithURL:(NSURL*)url;

- (NSURL *)generateURL;
@end
