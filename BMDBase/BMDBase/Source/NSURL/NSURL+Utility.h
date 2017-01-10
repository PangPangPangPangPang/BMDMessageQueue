//
//  NSURL+Utility.h
//  BMDBase
//
//  Created by Wang,Yefeng on 10/01/2017.
//  Copyright © 2017 Wang,Yefeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utility)
+(NSString *)urlEncodedString:(NSString *)sourceText;
+(NSString *)urlDecodingString:(NSString *)sourceText;

+(NSMutableDictionary *)parserQueryText:(NSString *)queryText;
+(NSString *)generateQueryText:(NSDictionary *)params;

+(NSString *)mergeUrl:(NSString *)urlPath withParams:(NSDictionary *)params;
+(NSString *)relativePathFrom:(NSURL *)baseUrl to:(NSURL *)target;
+(NSString *)mergeRelativePath:(NSString *)source to:(NSString *)target;

@end
