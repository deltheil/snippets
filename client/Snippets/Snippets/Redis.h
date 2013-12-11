//
//  Redis.h
//  Snippets
//
//  Created by Cédric Deltheil on 19/10/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

// In-memory Redis session
@interface Redis : NSObject

- (void)close;

- (NSString *)exec:(NSString *)command;
- (NSString *)exec:(NSString *)command error:(NSError **)error;

@end
