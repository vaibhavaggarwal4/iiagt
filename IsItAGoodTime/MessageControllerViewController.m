//
//  MessageControllerViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/22/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "MessageControllerViewController.h"
#import <MessageUI/MessageUI.h>

@interface MessageControllerViewController ()<
    MFMessageComposeViewControllerDelegate
>

@end

@implementation MessageControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)displaySmsComposerSheet:(NSString *)number{
    if ([MFMessageComposeViewController canSendText])
        
        // The device can send email.
        
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        
        picker.messageComposeDelegate = self;
        
         picker.recipients = @[number];
        
        
        
        // You can specify the initial message text that will appear in the message
        
        // composer view controller.
        
        picker.body = @"";
        
        
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
    else
        
        // The device can not send email.
        
    {
        NSLog(@"You can't send sms from this device");
        
    }
    

}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller

                 didFinishWithResult:(MessageComposeResult)result

{
    
    /*self.feedbackMsg.hidden = NO;
    
    // Notifies users about errors associated with the interface
    
    switch (result)
    
    {
            
        case MessageComposeResultCancelled:
            
            self.feedbackMsg.text = @"Result: SMS sending canceled";
            
            break;
            
        case MessageComposeResultSent:
            
            self.feedbackMsg.text = @"Result: SMS sent";
            
            break;
            
        case MessageComposeResultFailed:
            
            self.feedbackMsg.text = @"Result: SMS sending failed";
            
            break;
            
        default:
            
            self.feedbackMsg.text = @"Result: SMS not sent";
            
            break;
            
    }
    */
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
