//
//  RDSType.h
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle.h>

@class WNCDatabase;

// rds:cmds
extern NSString * const kRDSTypesNS;

@interface RDSType : MTLModel <MTLJSONSerializing>

// e.g "GET"
@property (nonatomic, copy, readonly) NSString *name;
// e.g ["hdel", "hget", "hlen"]
@property (nonatomic, copy, readonly) NSArray *cmds;

+ (void)setDatabase:(WNCDatabase *)database;

+ (NSArray *)fetch;
+ (NSArray *)fetch:(NSError **)error;

@end
