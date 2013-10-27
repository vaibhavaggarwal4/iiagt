//
//  MyViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/28/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *infoView;
- (IBAction)infoViewButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;

- (IBAction)loginButton:(id)sender;
- (IBAction)infoViewCloseButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberFormatLabel;

@end
