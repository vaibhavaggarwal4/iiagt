//
//  FirstViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/17/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "ContactViewController.h"
#import "SettingsViewController.h"
#import "MessageControllerViewController.h"
@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize nameLabel;
@synthesize passedName;
@synthesize phoneNumberLabel;
@synthesize passedPhoneNumber;
@synthesize contactImage;
@synthesize hasViber;
@synthesize hasWhatsapp;
@synthesize whatsappButtonOutlet;
@synthesize viberButtonOutlet;
MessageControllerViewController *messenger;
NSString *trueVal = @"1";
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated{
    nameLabel.text = passedName;
    phoneNumberLabel.text= passedPhoneNumber;
    [self.view bringSubviewToFront:contactImage];
    
    if([hasViber intValue]==1){
        viberButtonOutlet.enabled=true;
        
    }
    
    if([hasWhatsapp intValue]==1){
        whatsappButtonOutlet.enabled=true;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)callButton:(id)sender {
    
    NSString *phoneLinkString = [NSString stringWithFormat:@"tel:%@",passedPhoneNumber];
    NSURL *phoneLinkURL = [NSURL URLWithString:phoneLinkString];
    [[UIApplication sharedApplication] openURL:phoneLinkURL];
    NSLog(@"%@",phoneLinkURL);
    
    
}
- (IBAction)messageButton:(id)sender {
    messenger=[[MessageControllerViewController alloc]init];
        [messenger displaySmsComposerSheet:passedPhoneNumber];
    
    
}


- (IBAction)whatsAppButton:(id)sender {
}

- (IBAction)viberButton:(id)sender {
}
@end
