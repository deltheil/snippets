//
//  WNCDebug.h
//  Snippets
//
//  Created by Cédric Deltheil on 01/11/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
  #define WNCDLog(...) NSLog(__VA_ARGS__)
#else
  #define WNCDLog(...) ((void)0)
#endif
