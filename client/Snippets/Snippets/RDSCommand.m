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
    return @{
             @"name": @"name",
             @"summary": @"summary",
             @"cli": @"cli"
    };
}

@end
