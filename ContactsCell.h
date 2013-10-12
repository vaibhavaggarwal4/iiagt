//
//  ContactsCell.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/19/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSyncedLabel;
@property (weak, nonatomic) IBOutlet UIView *contactCell;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
