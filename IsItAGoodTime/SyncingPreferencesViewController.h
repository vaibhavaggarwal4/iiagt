//
//  SyncingPreferencesViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/6/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncingPreferencesViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> 
@property (weak, nonatomic) IBOutlet UIPickerView *startTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *endTimePicker;

@end
