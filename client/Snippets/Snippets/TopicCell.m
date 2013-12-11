//
//  TopicCell.m
//  Snippets
//
//  Created by James Heng on 10/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import "TopicCell.h"
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

- (void)setTopicName:(NSString *)topicName
{
    _topicName = topicName;
    
    [self.topicNameLabel setText:_topicName];
}

- (void)setPercent:(NSInteger)percent
{
    _percent = percent;
    
    [self.chooseButton setTitle:[NSString stringWithFormat:@"%ld %%", (long)_percent]
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
