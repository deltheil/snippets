//
//  RDSGroup.h
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle.h>

@interface Group : MTLModel <MTLJSONSerializing>

// e.g "GET"
@property (nonatomic, copy, readonly) NSString *name;
// e.g ["hdel", "hget", "hlen"]
@property (nonatomic, copy, readonly) NSArray *cmds;

+ (Group *)groupsUnion:(NSArray *)groups;

@end
