//
//  TopicCell.h
//  Snippets
//
//  Created by James Heng on 10/12/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@property (nonatomic) NSInteger percent;

@property (strong, nonatomic) NSString *topicName;

@end

#pragma mark - Helpers Subclasses

@interface ChooseButton : UIButton

@end