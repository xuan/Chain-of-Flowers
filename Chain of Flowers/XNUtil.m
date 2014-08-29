//
//  XNUtil.m
//  Chain of Flowers
//
//  Created by Xuan Nguyen on 8/14/14.
//  Copyright (c) 2014 Xuan Nguyen. All rights reserved.
//
#import "XnUtil.h"
#import <Foundation/Foundation.h>


@implementation XNUtil:NSObject

+ (NSString*) getImage:(NSString*) rawHTML {
    NSRange rangeOfString = NSMakeRange(0, [rawHTML length]);
    
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"<\\s*?img\\s+[^>]*?\\s*src\\s*=\\s*([\"\'])((\\\\?+.)*?)\\1[^>]*?>" options:NSRegularExpressionCaseInsensitive error:nil];

    NSTextCheckingResult *match = [regex firstMatchInString:rawHTML options:0 range:rangeOfString];
    if (match != NULL ) {
        NSString *imgUrl = [rawHTML substringWithRange:[match rangeAtIndex:2]];
        return imgUrl;
    }
    return NULL;
}

@end
