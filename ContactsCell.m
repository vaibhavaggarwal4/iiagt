//
//  ContactsCell.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/19/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell
@synthesize nameLabel;
@synthesize timeZoneLabel;
@synthesize lastSyncedLabel;
@synthesize availabilityLabel;
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
