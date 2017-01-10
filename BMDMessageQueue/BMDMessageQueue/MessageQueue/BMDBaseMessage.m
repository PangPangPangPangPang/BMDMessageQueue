//
//  BMDBaseMessage.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDBaseMessage.h"


@implementation BMDBaseMessage

- (id)initWithHost:(NSString *)host
          relative:(NSString *)relative
           command:(NSString *)command
              args:(NSDictionary *)args {
    self = [super init];
    if (self) {
        _scheme = Scheme;
        _host = host;
        _relative = relative;
        _command = command;
        _args = args;
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        assert([url.scheme isEqualToString:Scheme]);
        _scheme = url.scheme;
        _host = url.host;
        _relative = url.relativePath;
        _command = url.fragment;
        
    }
    return self;
}

@end
