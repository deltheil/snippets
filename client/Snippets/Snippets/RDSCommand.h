//
//  RDSCommand.h
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle.h>

@class WNCDatabase;

// rds:cmds
extern NSString * const kRDSCommandsNS;

@interface RDSCommand : NSObject

// e.g "GET"
@property (nonatomic, copy, readonly) NSString *name;
// e.g "Get the value of a key"
@property (nonatomic, copy, readonly) NSString *summary;
// TODO: cli (array)

+ (void)setDatabase:(WNCDatabase *)database;

+ (NSArray *)fetch;
+ (NSArray *)fetch:(NSError **)error;

@end
