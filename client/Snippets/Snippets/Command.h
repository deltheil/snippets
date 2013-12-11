//
//  RDSCommand.h
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle.h>

@interface Command : MTLModel <MTLJSONSerializing>

// command unique identifier, e.g "hset"
@property (nonatomic, copy) NSString *uid;
// e.g "HSET"
@property (nonatomic, copy, readonly) NSString *name;
// e.g "key field value"
@property (nonatomic, copy, readonly) NSString *args;
// e.g "Set the string value of a hash field"
@property (nonatomic, copy, readonly) NSString *summary;
// e.g ["HSET myhash field1 \"foo\"", "HGET myhash field1"]
@property (nonatomic, copy, readonly) NSArray *cli;

- (NSString *)htmlHeader;

@end
