//
//  SecondViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/17/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *loginView;
- (IBAction)loginButton:(id)sender;
- (IBAction)closeInfoViewButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *infoView;
- (IBAction)whyDoWeNeedThisInformation:(id)sender;
@end
