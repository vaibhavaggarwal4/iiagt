//
//  SecondViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/17/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsViewController : UIViewController <CLLocationManagerDelegate>
-(void)dismissLoginViewController:(UIViewController *)loginViewController;
@property (weak, nonatomic) IBOutlet UITableView *settingsTable;

@end
