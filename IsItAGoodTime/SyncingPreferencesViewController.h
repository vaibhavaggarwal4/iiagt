//
//  SyncingPreferencesViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/6/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncingPreferencesViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> 
- (IBAction)calendarSync:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UITableView *optionsTable;
@end
