//
//  TopicCell.m
//  Snippets
//
//  Created by James Heng on 10/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TopicCell.h"
#import "Topic.h"

#import "UIColor+Snippets.h"

@implementation TopicCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [self.topicNameLabel setText:_topic.name];
    [self.description setText:_topic.description];
}

- (void)setPercent:(NSInteger)percent
{
    _percent = percent;
    
    NSString *percentString;

    if (_percent < 100) {
        percentString = [NSString stringWithFormat:@"%ld %%", (long)_percent];
    }
    else {
        percentString = @"CHOOSE";
    }
    
    [self.chooseButton setTitle:percentString
                       forState:UIControlStateNormal];
}

@end

#pragma mark - Helpers Subclasses

@implementation ChooseButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithHexString:@"#d3392e" alpha:1] CGColor];
        self.layer.cornerRadius = 3;
    }
    return self;
}

@end
