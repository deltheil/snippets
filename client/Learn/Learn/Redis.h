//
//  Redis.h
//  Learn
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import <Foundation/Foundation.h>

// In-memory Redis session
@interface Redis : NSObject

- (BOOL)close;
- (BOOL)close:(NSError **)error;

- (NSString *)exec:(NSString *)command;
- (NSString *)exec:(NSString *)command error:(NSError **)error;

@end
