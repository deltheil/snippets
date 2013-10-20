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
// rds:cmds_html
extern NSString * const kRDSCommandsHTMLNS;

@interface RDSCommand : MTLModel <MTLJSONSerializing>

// e.g "GET"
@property (nonatomic, copy, readonly) NSString *name;
// e.g "Get the value of a key"
@property (nonatomic, copy, readonly) NSString *summary;
// e.g ["HSET myhash field1 \"foo\"", "HGET myhash field1", "HGET myhash field2"]
@property (nonatomic, copy, readonly) NSArray *cli;

// Properties out-of-scope of Mantle
@property (nonatomic, copy) NSString *uid;

+ (void)setDatabase:(WNCDatabase *)database;

// TODO: add the ability to fetch with a white list of commands (= filters)?
//
// Otherwise we could do something like that:
//
// RDSType *type = ...;
//
// [cmds filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//   RDSCommand *cmd = (RDSCommand *) evaluatedObject;
//   return [type.cmds containsObject:cmd.uid];
// }]];
+ (NSArray *)fetch;
+ (NSArray *)fetch:(NSError **)error;

- (NSString *)getHTMLString;

+ (void)sync:(void (^)(NSArray *cmds, NSError *error))block;
+ (void)sync:(void (^)(NSArray *cmds, NSError *error))block
    progress:(void (^)(NSInteger percentDone))progressBlock;

@end
