//
//  SyncingPreferencesViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/6/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "SyncingPreferencesViewController.h"

@interface SyncingPreferencesViewController ()
@property(strong,nonatomic)NSArray *startTimes;
@end

@implementation SyncingPreferencesViewController
@synthesize startTimePicker;
@synthesize endTimePicker;
@synthesize startTimes;
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
    startTimes=[[NSArray alloc]initWithObjects:@"0600",@"0700", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
