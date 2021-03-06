//
//  MyViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/28/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
SettingsViewController *settingsMessenger;
@synthesize nameField;
@synthesize numberField;
@synthesize numberFormatLabel;
UIBarButtonItem *nextButton ;
UIBarButtonItem *previosButton;
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
   // UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,40)];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
   /* [toolBar setBackgroundColor:[UIColor clearColor]];
    [toolBar setOpaque:NO];
    [toolBar setTranslucent:YES];*/
    toolBar.barTintColor = [[UIColor clearColor] colorWithAlphaComponent:0.1];
    nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(pushNext)];
    previosButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered  target:self action:@selector(pushPrevious)];
    NSArray *buttons = [[NSArray alloc]initWithObjects:previosButton, nextButton, nil];
    [toolBar setItems:buttons];
    [nameField setInputAccessoryView:toolBar];
    [numberField setInputAccessoryView:toolBar];
    nameField.returnKeyType=UIReturnKeyDone;
    numberField.returnKeyType=UIReturnKeyDone;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    numberFormatLabel.hidden=YES;

    	return YES;
}
-(void)pushNext{
    [numberField becomeFirstResponder];
    previosButton.enabled=TRUE;

    
}
-(void)pushPrevious{
    [nameField becomeFirstResponder];
    nextButton.enabled=TRUE;

}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==nameField){
        previosButton.enabled=FALSE;
        nextButton.enabled=TRUE;
        numberFormatLabel.hidden=YES;
        
    }
    else{
        nextButton.enabled=FALSE;
        previosButton.enabled=TRUE;
        numberFormatLabel.hidden=NO;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//- (IBAction)loginButton:(id)sender {
//    
//    // login the user automatically
//    //if the login is successful then only remove the loginview and go to the contacts tab
//    //else show the error and
//    //ask user to enter credentials correctly
//    
//    [UIView animateWithDuration:0.8f
//                     animations:^{loginView.alpha = 0.0;}
//                     completion:^(BOOL finished){ [loginView removeFromSuperview];
//                         //[self.tabBarController setSelectedIndex:1];
//                         UIStoryboard *storyboard = self.storyboard;
//                         
//                         LoginViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
//                         UINavigationController *navigationController = [[UINavigationController alloc]
//                                                                         
//                                                                         initWithRootViewController:svc];
//                         svc.navigationController.navigationBarHidden=true;
//                         [self presentViewController:navigationController animated:YES completion:^{[navigationController dismissViewControllerAnimated:YES completion:nil];
//                         }];
//                     }];
//    
//    
//    //[UIView beginAnimations:@"removeLoginView" context:NULL];
//    //[UIView setAnimationDuration:0.40f];
//    //loginView.frame=CGRectMake(loginView.center.x, loginView.center.y, 0, 0);
//    
//    /* loginView.transform =
//     CGAffineTransformMakeTranslation(
//     loginView.frame.origin.x,
//     480.0f + (loginView.frame.size.height/2)  // move the whole view offscreen
//     );*/
//    //loginView.alpha=0;
//    //loginView.background.alpha = 0; // also fade to transparent
//    //[UIView commitAnimations];
//    // [loginView removeFromSuperview];
//    
//    
//    /*[UIView animateWithDuration:0.8f
//     animations:^{ loginView.frame=CGRectMake(loginView.center.x, loginView.center.y, 0, 0);
//     }
//     completion:^(BOOL finished){
//     [loginView removeFromSuperview];
//     
//     }];*/
//    
//}
//

//-(void)addShadow{
//    loginView.layer.shadowOffset = CGSizeMake(10, 10);
//    
//    loginView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    
//    loginView.layer.shadowRadius = 4.0f;
//    
//    loginView.layer.shadowOpacity = 0.80f;
//    
//    loginView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:loginView.layer.bounds] CGPath];
//}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(nameField.isEditing){
        [nameField resignFirstResponder];
    }
    if(numberField.isEditing){
        [numberField resignFirstResponder];
        numberFormatLabel.hidden=YES;

    }
    
    //[numberField becomeFirstResponder];
}
- (IBAction)infoViewButton:(id)sender {
    
    self.infoView.hidden=false;
    
    [UIView animateWithDuration:0.4f
                     animations:^{
                         self.infoView.alpha = 1.0;
                         // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                         
                     }
     
                     completion:^(BOOL finished){ //[self.infoView removeFromSuperview];
                     }];

}
- (IBAction)loginButton:(id)sender {
    
    
    //settingsMessenger = [[SettingsViewController alloc]init];
    //[settingsMessenger dismissLoginViewController:self];
//[self dismissViewControllerAnimated:YES completion:nil];
  //  [self.presentingViewController.presentingViewController.tabBarController setSelectedIndex:1];
    
    // Sign Up/ Log the user in
    // if server response is 200 and true, save all the information
    // in the userdefaulsts ( number, name, unique hash, local time zone and all the likes)
    // then perform the segue
    // The problem with saving this in the app delegate is that you would have to set it every time and you dont want that
    // save it in the NSUSERDEFAULTS instead
    
    appUserPhoneNumber=@"7019361484";
    appUserUniqueHash=@"f8b02e92e32f62d878e3289e04044057";
    [prefs setObject:appUserPhoneNumber forKey:@"appUserPhoneNumber"];
    [prefs setObject:appUserUniqueHash forKey:@"appUserUniqueHash"];
    [prefs synchronize];

    
    // verify the name is entered, number is legal
    // take out the local time zone of the user
    // we need to ask him that
    
    
    
    
    
   // [self signUpWithNumber:numberField.text];
    if([self isNamePresent] && [self isNumberTenDigits]){
       // [self signUpWithNumber:numberField.text name:nameField.text];

    }
    
    
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

   // [self performSegueWithIdentifier:@"verificationSegue" sender:self];

    
}
-(BOOL)isNamePresent{

    if(nameField.text.length<1){
    
        return FALSE;
        // show message
    }
    else{
        return TRUE;
    }
    
}
-(BOOL)isNumberTenDigits{
    // check that all are digits
    if(numberField.text.length==10){
        return TRUE;
    }
    else{
        return FALSE;
        //show message
    }
}

// TODO: Handle if user already exists
-(void)signUpWithNumber:(NSString *) number name:(NSString *)name {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:number forKey:@"phone_number"];
    [params setValue:name forKey:@"name"];
    [params setObject:[[NSTimeZone localTimeZone]name] forKey:@"local_time"];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user",BASEURL]
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

            if([[JSON valueForKey:@"status"] isEqualToString:@"false" ]){
            
                NSLog(@"%@",[JSON valueForKey:@"description"]);
            }
            else{
                appUserPhoneNumber=number;
                appUserUniqueHash=[JSON valueForKey:@"unique_hash"];
                [prefs setObject:appUserPhoneNumber forKey:@"appUserPhoneNumber"];
                [prefs setObject:appUserUniqueHash forKey:@"appUserUniqueHash"];
                [prefs synchronize];

                [self performSegueWithIdentifier:@"verificationSegue" sender:self];



            }
            
            
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                // Message for the geeks
                UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Error in connecting to our servers"
                message:[NSString stringWithFormat:@"%@",error]
                delegate:nil
            cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failure show];
        }];
    
    [operation start];
    


}




- (IBAction)infoViewCloseButton:(id)sender {
    

    [UIView animateWithDuration:0.4f
                         animations:^{
                             self.infoView.alpha = 0.0;
                            // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                             
                         }
    
                     completion:^(BOOL finished){
                         self.infoView.hidden=true;
                     }];


}
- (IBAction)cancelButton:(id)sender {
}
@end
