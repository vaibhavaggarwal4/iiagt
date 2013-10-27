//
//  AdditionalInfoViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/13/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "AdditionalInfoViewController.h"

@interface AdditionalInfoViewController ()

@end

@implementation AdditionalInfoViewController

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

- (IBAction)doneButton:(id)sender {
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
@end
