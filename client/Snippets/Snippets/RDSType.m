//
//  RDSType.m
//  Snippets
//
//  Created by Cédric Deltheil on 20/10/13.
//  Copyright (c) 2013 AppHACK. All rights reserved.
//

#import "RDSType.h"

#import <Winch/Winch.h>

static __weak WNCDatabase *_wnc_database;

NSString * const kRDSTypesNS = @"rds:types";

@implementation RDSType

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"name"
             };
}

+ (NSArray *)fetch
{
    return [self fetch:nil];
}

+ (void)setDatabase:(WNCDatabase *)database
{
    _wnc_database = database;
}

+ (NSArray *)fetch:(NSError **)error
{
    WNCNamespace *ns = [_wnc_database getNamespace:kRDSTypesNS];
    NSMutableArray *cmds = [NSMutableArray array];
    NSError *iterError = nil;
    __block BOOL dataError = NO;
    
    [ns enumerateRecordsUsingBlock:^(NSString *key, NSMutableData *data, int *option) {
        NSError *jsonError = nil;
        id jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            dataError = YES;
            *option = kWNCIterStop;
            return;
        }
        
        NSError *parseError = nil;
        RDSType *cmd = [MTLJSONAdapter modelOfClass:RDSType.class
                                 fromJSONDictionary:jsonDict
                                              error:&parseError];
        if (parseError) {
            dataError = YES;
            *option = kWNCIterStop;
            return;
        }
        
        [cmds addObject:cmd];
    } error:&iterError];
    
    if (iterError || dataError) {
        if (error) {
            *error = [NSError errorWithDomain:@"RDSType" code:1 userInfo:nil];
            return nil;
        }
    }
    
    return cmds;
}

@end
