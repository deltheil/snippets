//
//  RDSCommand.m
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSCommand.h"

#import <Winch/Winch.h>

@implementation RDSCommand

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // Note: all other properties are implicitly mapped
    return @{
        @"uid": NSNull.null // tell Mantle we handle it ourselves
    };
}

@end
