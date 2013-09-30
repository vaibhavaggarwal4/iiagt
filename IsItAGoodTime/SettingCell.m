//
//  SettingCell.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/29/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
@synthesize optionLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
