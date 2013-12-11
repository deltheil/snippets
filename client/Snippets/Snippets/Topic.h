//
//  Topic.h
//  Snippets
//
//  Created by James Heng on 11/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

// identifier, e.g "rds"
@property (strong, nonatomic) NSString *uid;
// e.g "redis"
@property (strong, nonatomic) NSString *name;
// e.g "redis is a ..."
@property (strong, nonatomic) NSString *description;

@end
