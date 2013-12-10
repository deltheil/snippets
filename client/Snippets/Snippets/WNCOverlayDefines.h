//
//  WNCOverlayDefines.h
//  Snippets
//
//  Created by James Heng on 10/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#ifndef Snippets_WNCOverlayDefines_h
#define Snippets_WNCOverlayDefines_h

#define DEF_OPT    @(kWNCSyncDefault)

// -------------------------------------------------
// Per-topic
// -------------------------------------------------

#define SN_CMDS   @"%@:cmds"                    // % Topic Name
#define SN_DOCS   @"%@:docs"                    // % Topic Name
#define SN_GROUPS @"%@:groups"                  // % Topic Name

#define SN_CMDS_TOPIC(TOPIC) \
[NSString stringWithFormat:SN_CMDS, TOPIC]

#define SN_DOCS_TOPIC(TOPIC) \
[NSString stringWithFormat:SN_DOCS, TOPIC]

#define SN_GROUPS_TOPIC(TOPIC) \
[NSString stringWithFormat:SN_GROUPS, TOPIC]

#endif