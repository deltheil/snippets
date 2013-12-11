//
//  Copyright (c) 2013 Moodstocks. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
  #define WNCDLog(...) NSLog(__VA_ARGS__)
#else
  #define WNCDLog(...) ((void)0)
#endif
