//
//  ProfileSettingsViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/3/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *viberSwitch;
@property (weak, nonatomic) IBOutlet UILabel *viberLabel;

@property (weak, nonatomic) IBOutlet UISwitch *whatsappSwitch;
@property (weak, nonatomic) IBOutlet UILabel *whatsappLabel;
@end
