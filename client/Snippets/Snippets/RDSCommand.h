//
//  RDSCommand.h
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle.h>

@class WNCDatabase;

@interface RDSCommand : MTLModel <MTLJSONSerializing>

// e.g "GET"
@property (nonatomic, copy, readonly) NSString *name;
// e.g "Get the value of a key"
@property (nonatomic, copy, readonly) NSString *summary;
// e.g ["HSET myhash field1 \"foo\"", "HGET myhash field1", "HGET myhash field2"]
@property (nonatomic, copy, readonly) NSArray *cli;

// Properties out-of-scope of Mantle
@property (nonatomic, copy) NSString *uid;

@end
