//
//  VerificationViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 11/12/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerificationViewController : UIViewController

- (IBAction)verifyViaTextButton:(id)sender;

- (IBAction)verifyViaCallButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

- (IBAction)readyToGoButton:(id)sender;

@end
