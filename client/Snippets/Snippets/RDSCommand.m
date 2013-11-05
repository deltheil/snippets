//
//  RDSCommand.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSCommand.h"

#define HDR_TPL @"<h1>Example<br/>%@<br/><br/>////////////////////////////////<br/><br/></h1>"

@implementation RDSCommand

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // Note: all other properties are implicitly mapped
    return @{
        @"uid": NSNull.null // tell Mantle we handle it ourselves
    };
}

- (NSString *)htmlHeader
{
    NSMutableArray *ary = [NSMutableArray arrayWithObject:_name];
    if (_args != nil) {
        [ary addObject:_args];
    }
    return [NSString stringWithFormat:HDR_TPL, [ary componentsJoinedByString:@" "]];
}

@end
