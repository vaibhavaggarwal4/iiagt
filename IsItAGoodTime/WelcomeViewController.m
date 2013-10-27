//
//  WelcomeViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/12/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize getStartedButton;
@synthesize buttonParentView;
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
    getStartedButton.frame= CGRectMake(75, 6, 0, 35);

    
   
}
-(void)viewDidAppear:(BOOL)animated
{
   
    
    [UIView animateWithDuration:0.6f
                     animations:^{
                         // getStartedButton.transform = CGAffineTransformMakeTranslation(0, -80);
                         buttonParentView.transform=CGAffineTransformMakeTranslation(0, -160);
                         
                         // self.getStartedButton.alpha = 0.0;
                         // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                         
                     }
     
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:.6f
                                          animations:^{
                                              // getStartedButton.transform = CGAffineTransformMakeTranslation(0, -80);
                                              getStartedButton.alpha=0.9;
                                              // self.getStartedButton.alpha = 0.0;
                                              // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                                              
                                          }
                          
                                          completion:^(BOOL finished){
                                          }];

                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getStartedButton:(id)sender {
    
    
    
}
@end
