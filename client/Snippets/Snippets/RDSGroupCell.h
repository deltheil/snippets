//
//  RDSGroupCell.h
//  Snippets
//
//  Created by James on 12/6/13.
//  Copyright (c) 2013 Snippets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDSGroupCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIView *underlineView;

@property (strong, nonatomic) NSString *groupName;

@end
