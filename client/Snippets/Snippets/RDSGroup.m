//
//  RDSGroup.m
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSGroup.h"

#import <Winch/Winch.h>

@implementation RDSGroup

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"name",
             @"cmds": @"cmds"
             };
}

+ (RDSGroup *)groupsUnion:(NSArray *)groups
{
    NSMutableSet *set = [NSMutableSet set];
    
    for (RDSGroup *group in groups) {
        [set addObjectsFromArray:group.cmds];
    }
    
    NSArray *cmds = [NSArray arrayWithArray:[set allObjects]];
    
    return [MTLJSONAdapter modelOfClass:RDSGroup.class
                     fromJSONDictionary:@{@"name": @"All", @"cmds": cmds}
                                  error:nil];
}

@end
