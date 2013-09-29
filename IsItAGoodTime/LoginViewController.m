//
//  MyViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/28/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (IBAction)infoViewButton:(id)sender {
    
    self.infoView.hidden=false;
}
- (IBAction)loginButton:(id)sender {
}

- (IBAction)infoViewCloseButton:(id)sender {
    
    self.infoView.hidden=true;
}
@end
