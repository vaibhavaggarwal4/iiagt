//
//  SyncingPreferencesViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/6/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "SyncingPreferencesViewController.h"

@interface SyncingPreferencesViewController ()
@property(strong,nonatomic)NSArray *hours;
@property(strong,nonatomic)NSArray *minutes;
@property(strong,nonatomic)NSArray *amOrPm;


@end

@implementation SyncingPreferencesViewController
@synthesize startTimePicker;
@synthesize endTimePicker;
@synthesize hours;
@synthesize minutes;
@synthesize amOrPm;
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
    
    
    hours=[[NSArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12", nil];
    minutes=[[NSArray alloc]initWithObjects:@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55", nil];
    amOrPm=[[NSArray alloc]initWithObjects:@"AM",@"PM", nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   // If we want to do something else
    if(pickerView == startTimePicker){
    return 3;
    }
    else{
        return 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0){
    return [hours count];
    }
    else if(component==1){
        return [minutes count];
    }
    else if(component==2){
        return 2;
    }
    else{
        return 0;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 25.0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0){
    return [hours objectAtIndex:row];
    }
    else if(component==1){
        return [minutes objectAtIndex:row];
    }
    else if(component==2){
        return [amOrPm objectAtIndex:row];
    }
    else{
        return Nil;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    if(component==0){
    NSLog(@"Chosen item: %@", [hours objectAtIndex:row]);
    }
    else if(component==1){
        NSLog(@"Chosen item: %@", [minutes objectAtIndex:row]);

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
