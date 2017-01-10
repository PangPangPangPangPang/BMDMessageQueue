//
//  NSURL+Utility.m
//  BMDBase
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import "NSURL+Utility.h"
#import "NSArray+JSON.h"
#improt "NSDIctionary+JSON.h"

@implementation NSURL (Utility)
+ (NSString *)urlEncodedString:(NSString *)sourceText {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)sourceText,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)urlDecodingString:(NSString *)sourceText {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (CFStringRef) sourceText,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

+ (NSString *)parserQueryKey:(NSString *)queryText startIndex:(NSInteger*)startIndex {
    NSInteger length = 0;
    for(NSInteger index = *startIndex; index < [queryText length]; index++) {
        unichar ch = [queryText characterAtIndex:index];
        if (ch == '=') {
            break;
        } else {
            length++;
        }
    }
    NSString *key = [queryText substringWithRange:NSMakeRange(*startIndex, length)];
    *startIndex = *startIndex + length + 1;
    return key;
}

+ (NSString *)parserQueryValue:(NSString *)queryText startIndex:(NSInteger*)startIndex {
    NSInteger length = 0;
    for(NSInteger index = *startIndex; index < [queryText length]; index++) {
        unichar ch = [queryText characterAtIndex:index];
        if (ch == '&') {
            break;
        } else {
            length++;
        }
    }
    NSString *value = [queryText substringWithRange:NSMakeRange(*startIndex, length)];
    *startIndex = *startIndex + length + 1;
    return value;
}

+ (NSMutableDictionary *)parserQueryText:(NSString *)queryText {
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    if (queryText == nil) {
        return paramDic;
    }
    NSInteger index = 0;
    while (true) {
        NSString *key = [NSURL parserQueryKey:queryText startIndex:&index];
        NSString *value = [NSURL parserQueryValue:queryText startIndex:&index];
        if (key && value) {
            [paramDic setValue:[NSURL urlDecodingString:value]
                        forKey:key];
        }
        if (index >= [queryText length]) {
            break;
        }
    }
    return paramDic;
}

+ (NSString *)generateQueryText:(NSDictionary *)params {
    __block NSMutableString *queryText = [NSMutableString new];
    NSArray *keys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = [params valueForKey:obj];
        if ([value isKindOfClass:[NSArray class]])
            value = [(NSArray*)value jsonString];
        else if ([value isKindOfClass:[NSDictionary class]])
            value = [(NSDictionary*)value jsonString];
        
        if ([queryText length] == 0) {
            [queryText appendFormat:@"%@=%@",
             [NSURL urlEncodedString:obj],
             [NSURL urlEncodedString:[NSString stringWithFormat:@"%@",value]]];
        } else {
            [queryText appendFormat:@"&%@=%@",
             [NSURL urlEncodedString:obj],
             [NSURL urlEncodedString:[NSString stringWithFormat:@"%@",value]]];
        }
    }];
    return queryText;
}

+ (NSString *)mergeUrl:(NSString *)urlPath withParams:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:urlPath];
    if (url == nil) return urlPath;
    
    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithDictionary:[NSURL parserQueryText:[url query]]];
    for(NSString *key in [params allKeys]) {
        if ([args valueForKey:key] == nil) {
            [args setValue:[params valueForKey:key]
                    forKey:key];
        }
    }
    NSMutableString *result = [NSMutableString new];
    [result appendFormat:@"%@://",[url scheme]];
    if([url user] && [url password]) {
        [result appendFormat:@"%@:%@",
         [NSURL urlEncodedString:[url user]],
         [NSURL urlEncodedString:[url password]]];
    }
    if ([url host]) {
        [result appendString:[url host]];
    }
    if([url port]) {
        [result appendFormat:@":%@",[url port]];
    }
    [result appendString:[url path]];
    
    if([args count] != 0) {
        [result appendFormat:@"?%@",[NSURL generateQueryText:args]];
    }
    if ([url fragment]) {
        [result appendFormat:@"#%@",[url fragment]];
    }
    
    return result;
}

+(NSString *)relativePathFrom:(NSURL *)baseUrl to:(NSURL *)target {
    if ([[baseUrl host] isEqualToString:[target host]] == NO) {
        return nil;
    }
    
    NSArray *baseNodes = [[baseUrl relativePath] componentsSeparatedByString:@"/"];
    NSArray *targetNodes = [[target relativePath] componentsSeparatedByString:@"/"];
    
    NSInteger base_index = 1;
    NSInteger target_index = 1;
    for (NSInteger index = 1; index < [targetNodes count]; index++) {
        NSString *target_node = [targetNodes objectAtIndex:index];
        NSString *base_node = [baseNodes objectAtIndex:base_index];
        if ([base_node isEqualToString:target_node]) {
            base_index++;
            target_index++;
            continue;
        } else {
            break;
        }
    }
    NSMutableArray *result = [NSMutableArray new];
    for (NSInteger index = base_index; index < [baseNodes count] - 1; index++) {
        [result addObject:@".."];
    }
    for (NSInteger index = target_index; index < [targetNodes count]; index++) {
        [result addObject:[targetNodes objectAtIndex:index]];
    }
    if ([result count] == 0) {
        result;
        return @"";
    }
    NSString *temp = [result componentsJoinedByString:@"/"];
    result;
    return temp;
}

+(NSString *)mergeRelativePath:(NSString *)source to:(NSString *)target {
    NSArray *source_nodes = [source componentsSeparatedByString:@"/"];
    NSArray *target_nodes = [target componentsSeparatedByString:@"/"];
    
    NSInteger source_index = 0;
    NSInteger target_index = [target_nodes count] - 1;
    for (NSInteger index = 0; index < [source_nodes count]; index++) {
        source_index = index;
        NSString *source_node = [source_nodes objectAtIndex:index];
        if ([source_node isEqualToString:@".."]) {
            target_index--;
        } else {
            break;
        }
    }
    
    NSMutableArray *result = [NSMutableArray new];
    for (NSInteger index = 0; index < target_index; index++) {
        [result addObject:[target_nodes objectAtIndex:index]];
    }
    for (NSInteger index = source_index; index < [source_nodes count]; index++) {
        [result addObject:[source_nodes objectAtIndex:index]];
    }
    
    NSString *temp = [result componentsJoinedByString:@"/"];
    return temp;
}
@end
