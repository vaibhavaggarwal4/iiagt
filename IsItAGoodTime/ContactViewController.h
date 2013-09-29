//
//  ContactViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/17/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property(strong,nonatomic)NSString *passedName;
@property(strong,nonatomic)NSString *passedPhoneNumber;
- (IBAction)callButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
- (IBAction)messageButton:(id)sender;
- (IBAction)whatsAppButton:(id)sender;
- (IBAction)viberButton:(id)sender;
@property(strong,nonatomic)NSNumber *hasViber;
@property(strong,nonatomic)NSNumber *hasWhatsapp;
@property (weak, nonatomic) IBOutlet UIButton *whatsappButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *viberButtonOutlet;

@end
