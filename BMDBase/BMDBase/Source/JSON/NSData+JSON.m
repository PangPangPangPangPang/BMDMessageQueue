//
//  NSData+JSON.m
//  FusionBase
//
//  Created by ZhangRyou on 3/10/15.
//  Copyright (c) 2015 Ryou Zhang. All rights reserved.
//

#import "NSData+JSON.h"
#import "NSDictionary+RemoveNSNull.h"
#import "NSArray+RemoveNSNull.h"

@implementation NSData(JSON)
- (id)jsonMObject {
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self
                                                options:NSJSONReadingMutableContainers
                                                  error:&error];
    if (error || [NSJSONSerialization isValidJSONObject:result] == NO)
        return nil;
    
    return [result RemoveNSNull];
}
@end
