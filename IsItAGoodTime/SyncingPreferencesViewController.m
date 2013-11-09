//
//  SyncingPreferencesViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/6/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "SyncingPreferencesViewController.h"
#import "AppDelegate.h"
#import <EventKit/EventKit.h>
#import "TimePickerCell.h"
#import "SettingCell.h"

@interface SyncingPreferencesViewController ()
@property(strong,nonatomic)NSArray *hours;
@property(strong,nonatomic)NSArray *minutes;
@property(strong,nonatomic)NSArray *amOrPm;
@property(strong,nonatomic)NSArray *options;
@property(strong,nonatomic)UIPickerView *startTimePicker;
@property(strong,nonatomic)UIPickerView *endTimePicker;
@property(strong,nonatomic)NSString *startTime;
@property(strong,nonatomic)NSString *endTime;


@end

@implementation SyncingPreferencesViewController
@synthesize hours;
@synthesize minutes;
@synthesize amOrPm;
@synthesize options;
@synthesize infoView;
@synthesize infoLabel;
@synthesize startTimePicker;
@synthesize endTimePicker;
@synthesize startTime;
@synthesize endTime;
@synthesize optionsTable;
int selectedIndex=-2;
bool isSelected=FALSE;
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
    
    
    hours=[[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    minutes=[[NSArray alloc]initWithObjects:@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55", nil];
    amOrPm=[[NSArray alloc]initWithObjects:@"AM",@"PM", nil];
    options=[[NSArray alloc]initWithObjects:@"Start Time",@"",@"End Time",@"",nil];
    startTimePicker= [[UIPickerView alloc]init];
    endTimePicker=[[UIPickerView alloc]init];
    startTime=@"";
    endTime=@"";
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [startTimePicker selectRow:7 inComponent:0 animated:NO];
    [endTimePicker selectRow:5 inComponent:0 animated:NO];
    [endTimePicker selectRow:1 inComponent:2 animated:NO];
    startTime=[NSString stringWithFormat:@"%@ : %@ %@",[hours objectAtIndex:[startTimePicker selectedRowInComponent:0]],
               [minutes objectAtIndex:[startTimePicker selectedRowInComponent:1]],[amOrPm objectAtIndex:[startTimePicker selectedRowInComponent:2]]];
    endTime=[NSString stringWithFormat:@"%@ : %@ %@",[hours objectAtIndex:[endTimePicker selectedRowInComponent:0]],
             [minutes objectAtIndex:[endTimePicker selectedRowInComponent:1]],[amOrPm objectAtIndex:[endTimePicker selectedRowInComponent:2]]];
    [self.optionsTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
    return 1;
    }
    else{
        return 20;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
    if(indexPath.row%2==0){
        return 40;
    }
    else{
        if(isSelected && selectedIndex+1==indexPath.row){
            return 140;
        }
        else{
            return 0;
        }
    }
    }
    else{
        return 40;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 4;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        static NSString *calendarSyncIdentifier=@"calendarSyncCell";
        SettingCell *calendarSyncCell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:calendarSyncIdentifier];
        if (calendarSyncCell == nil)
        {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil];
            calendarSyncCell = [nib objectAtIndex:0];
        }
        calendarSyncCell.optionLabel.text=@"Sync calendar now";
        return calendarSyncCell;
        
    }
    else{
    static NSString *timePickerCellIdentifier = @"timePickerCell";
    TimePickerCell *timePickerCell = (TimePickerCell *)[tableView dequeueReusableCellWithIdentifier:timePickerCellIdentifier];
        if (timePickerCell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"pickerViewCell" owner:self options:nil];
		timePickerCell = [nib objectAtIndex:0];
    }
        timePickerCell.optionLabel.text=[options objectAtIndex:indexPath.row];
        if(indexPath.row==0){
            timePickerCell.timeLabel.text=startTime;
        }
        else if(indexPath.row==2){
            timePickerCell.timeLabel.text=endTime;
        }
        else{
            timePickerCell.timeLabel.text=@"";

        }
        if(indexPath.row==1){
            startTimePicker.frame=CGRectMake(70, 0, 182, 162);
            startTimePicker.delegate=self;
            [timePickerCell addSubview:startTimePicker];
            
        }
        else if(indexPath.row==3){
            endTimePicker.frame=CGRectMake(70, 0, 182, 162);
            endTimePicker.delegate=self;
            [timePickerCell addSubview:endTimePicker];
        }
        
        return timePickerCell;

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1){
        
    
    }
    else{
        if(isSelected && selectedIndex==indexPath.row){
            isSelected=FALSE;
            selectedIndex=-2;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
        else if(indexPath.row%2==0){
            isSelected=TRUE;
            selectedIndex=indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else{
        }
    }
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   // If we want to do something else
    return 3;
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
    
    
    if(pickerView==startTimePicker){
        startTime=[NSString stringWithFormat:@"%@ : %@ %@",[hours objectAtIndex:[startTimePicker selectedRowInComponent:0]],
                [minutes objectAtIndex:[startTimePicker selectedRowInComponent:1]],[amOrPm objectAtIndex:[startTimePicker selectedRowInComponent:2]]];
    }
    if(pickerView==endTimePicker){
        endTime=[NSString stringWithFormat:@"%@ : %@ %@",[hours objectAtIndex:[endTimePicker selectedRowInComponent:0]],
                   [minutes objectAtIndex:[endTimePicker selectedRowInComponent:1]],[amOrPm objectAtIndex:[endTimePicker selectedRowInComponent:2]]];
    }
    [self.optionsTable reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calendarSync:(id)sender {
    self.infoLabel.text=@"Syncing Calendar";
    self.infoView.alpha=0.6;
    self.infoView.hidden=NO;
    [self getCalendarData];
}
-(void)getCalendarData{
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(granted){
            NSCalendar *calendar =[NSCalendar currentCalendar];
            NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc]init];
            oneDayAgoComponents.day = 0;
            
            NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents toDate:[NSDate date] options:0];
            
            NSDateComponents *twoDaysFromNowComponents = [[NSDateComponents alloc]init];
            
            twoDaysFromNowComponents.day=+2;
            NSDate *twoDaysFromNow =[calendar dateByAddingComponents:twoDaysFromNowComponents toDate:[NSDate date] options:0];
            
            NSPredicate *predicate =[store predicateForEventsWithStartDate:oneDayAgo endDate:twoDaysFromNow calendars:nil];
            
            
            // eventsmatching predicate is synchronous, do not run this on the main thread
            // run this on a seperate background thread
            NSArray *cal = [store eventsMatchingPredicate:predicate];
            NSDate *date;
            
            NSTimeInterval ti;
            NSMutableArray *startTimes = [[NSMutableArray alloc]init];
            NSMutableArray *endTimes = [[NSMutableArray alloc]init];
            for(NSObject *item in cal){
                NSLog(@"%@",item);
                date = [item valueForKey:@"startDate"];
                ti =(double) [date timeIntervalSince1970];
                [startTimes addObject:[NSString stringWithFormat:@"%ld",lroundf(ti)]];
                date = [item valueForKey:@"endDate"];
                ti =(double) [date timeIntervalSince1970];
                [endTimes addObject:[NSString stringWithFormat:@"%ld",lroundf(ti)]];
                
            }
            [self updateCalendarWithStart:startTimes AndEndTimes:endTimes];
            
        }
        else{
            NSLog(@"User has denied the access to calendar");
        }
    }];
    
}
-(void)updateCalendarWithStart:(NSMutableArray *)startTimes AndEndTimes:(NSMutableArray *)endTimes {
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    //[params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    //[params setValue:@"7019361484" forKey:@"phone_number"];
    
    [params setValue:startTimes forKey:@"start_times"];
    [params setValue:endTimes forKey:@"end_times"];
    NSLog(@"%@",[params objectForKey:@"start_times"]);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/calendar",BASEURL]
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    self.infoLabel.text=@"Sync Complete";

                    [UIView animateWithDuration:0.8f
                                     animations:^{

                                         self.infoView.alpha = 0.0;
                                         // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                                         
                                     }
                     
                                     completion:^(BOOL finished){
                                         self.infoView.hidden=YES;
                                     }];


                                                                                        }
                                         
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                            // Message for the geeks
                    UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not change status"
                    message:[NSString stringWithFormat:@"%@",error]
                    delegate:nil
                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [failure show];
                
                self.infoLabel.text=@"Sync Failed";
                [UIView animateWithDuration:0.8f
                                 animations:^{
                                     self.infoView.alpha = 0.0;
                                     // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                                     
                                 }
                 
                                 completion:^(BOOL finished){
                                     self.infoView.hidden=YES;
                                 }];

            }];
    
    [operation start];
    
}

@end
