//
//  BMDBaseMessage.m
//  MessageQueue
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "BMDBaseMessage.h"
#import <BMDBase/BMDBase.h>


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
        _scheme = Scheme;
        _host = [url host];
        _relative = [[url relativePath] substringFromIndex:1];
        
        if ([url query] && [[url query] length] > 0) {
            NSDictionary *queryDic = [NSURL parserQueryText:[url query]];
            _args = [queryDic valueForKey:@"args"];
        } else {
            _args = nil;
        }
        
        if ([url fragment]) {
            _command = [url fragment];
        } else {
            _command = nil;
        }
    }
    return self;
}

- (NSURL *)generateURL {
    NSString *path =  nil;
    if (_args) {
        path = [NSString stringWithFormat:@"%@?args=%@#%@",_relative,[NSURL urlEncodedString:[_args jsonString]], _command];
    } else {
        path = [NSString stringWithFormat:@"%@#%@", _relative, _command];
    }
    NSURL *url = [[NSURL alloc] initWithScheme:_scheme host:_host path:path];
    return url;
}
@end
