//
//  VerificationViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 11/12/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "VerificationViewController.h"
#import "AppDelegate.h"

@interface VerificationViewController ()

@end

@implementation VerificationViewController
@synthesize verificationCodeTextField;
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [verificationCodeTextField resignFirstResponder];
    
    //[numberField becomeFirstResponder];
}
- (IBAction)verifyViaTextButton:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message sent"
                                                      message:[NSString stringWithFormat:@"If you do not get the message, tap the button again"]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];

    
}

- (IBAction)verifyViaCallButton:(id)sender {
}
- (IBAction)readyToGoButton:(id)sender {
    
    [self verifyCode];
   /* if([verificationCodeTextField.text isEqualToString:@"12345"]){
    [self performSegueWithIdentifier:@"moreInfoAfteVerificationSegue" sender:self];
    }
    else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Ohh No!"
                                                          message:[NSString stringWithFormat:@"Incorrect verification code, enter again or tap to send a new one"]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
    }*/
}
-(void)verifyCode{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    [params setValue:verificationCodeTextField.text forKey:@"verification_code"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/verify",BASEURL]
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                    NSLog(@"%@",JSON);
                        if([[JSON valueForKey:@"status"] isEqualToString:@"true"]){
                            [self performSegueWithIdentifier:@"moreInfoAfteVerificationSegue" sender:self];
   
                        }
                        else{
                            UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Incorrect code"
                                                                              message:[NSString stringWithFormat:@"%@",@"You can send code again if you want"]
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [failure show];

                        }
                        
                        }

                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                // Message for the geeks
                            UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not Connect"
                            message:[NSString stringWithFormat:@"%@",error]
                                    delegate:nil
                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failure show];
        }];
    
    [operation start];

}
@end
