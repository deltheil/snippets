//
//  RDSGroup.m
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "RDSGroup.h"

@implementation RDSGroup

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // Note: all properties are implicitly marked
    return @{};
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
