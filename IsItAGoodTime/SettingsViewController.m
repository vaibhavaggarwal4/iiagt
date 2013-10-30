//
//  SecondViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/17/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "SettingsViewController.h"
#import <EventKit/EventKit.h>
#import "LoginViewController.h"
#import "ContactsCell.h"
#import "SettingCell.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "CalendarEvent.h"
@interface SettingsViewController ()
@property(strong,nonatomic)NSMutableArray *userContactNames;
@property(strong,nonatomic)NSArray *optionList;
@end

@implementation SettingsViewController
bool loggedIn= false;
@synthesize optionList;
@synthesize settingsTable;
- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view, typically from a nib.
    optionList =[[NSArray alloc]initWithObjects:@"Profile",@"Font and Colors",@"Syncing preferences",@"About", nil];
   [self getCalendarData];

    [prefs removeObjectForKey:@"appUserUniqueHash"];
    [prefs synchronize];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    //[settingsTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)viewDidAppear:(BOOL)animated{
    //[prefs removeObjectForKey:@"name"];
    //[prefs synchronize];
    if([prefs valueForKey:@"appUserUniqueHash"]){

    }
    else{
        [self checkIfNewUserAndPresentLoginView];

    }
    
}
-(void)dismissLoginViewController:(UIViewController *)loginViewController{
    
    [loginViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section==0){
        return 1;
    }
    return [optionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *settingCellIdentifier = @"settingCell";
    SettingCell *settingCell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
    if (settingCell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil];
		settingCell = [nib objectAtIndex:0];
    }
    if(indexPath.section==0){
        settingCell.optionLabel.transform=CGAffineTransformMakeTranslation(130, 10);
        settingCell.optionLabel.text=@"Vaibhav Aggarwal";
        settingCell.accessoryType=UITableViewCellAccessoryNone;
        settingCell.userInteractionEnabled=NO;
        return settingCell;
    }
    // Configure the cell...
    settingCell.optionLabel.text=[optionList objectAtIndex:indexPath.row];
    return settingCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section==0){
        return;
    }
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"profileSettingSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"colorAndFontSettingSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"syncingSettingSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"aboutSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
            break;
            
        default:
            // there should not be invalid selection, we show only as many cells
            break;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"profileSettingSegue"])
        
    {
//        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//        ContactViewController *destinationViewController = segue.destinationViewController;
//        NSString *number = [contactPhoneNumbers objectAtIndex:path.row];
//        destinationViewController.passedName=[contactNamesDictionary valueForKey:number];
//        destinationViewController.passedPhoneNumber=number;
//        destinationViewController.hasWhatsapp=[contactHasWhatsappDictionary valueForKey:number];
//        destinationViewController.hasViber=[contactHasViberDictionary valueForKey:number];
//        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkIfNewUserAndPresentLoginView{

    UIStoryboard *storyboard = self.storyboard;
    
    WelcomeViewController *welcomeViewController = [storyboard instantiateViewControllerWithIdentifier:@"welcomeView"];
    UINavigationController *welcomeNavigationController = [[UINavigationController alloc]
                                                         initWithRootViewController:welcomeViewController];

    welcomeViewController.navigationController.navigationBarHidden=true;
    [self presentViewController:welcomeNavigationController animated:YES completion:nil];
    
   // LoginViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    //UINavigationController *loginNavigationController = [[UINavigationController alloc]
                                                //    initWithRootViewController:svc];
    //svc.navigationController.navigationBarHidden=true;
    //[self presentViewController:loginNavigationController animated:YES completion:nil];
    
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
            NSMutableArray*endTimes = [[NSMutableArray alloc]init];
            for(NSObject *item in cal){

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
            NSLog(@"yaar!");
        }
    }];
    
}
-(void)updateCalendarWithStart:(NSMutableArray *)startTimes AndEndTimes:(NSMutableArray *)endTimes {
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    //[params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
   // [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    NSLog(@"%@",[prefs valueForKey:@"appUserUniqueHash"]);
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];

    [params setValue:startTimes forKey:@"start_times"];
    [params setValue:endTimes forKey:@"end_times"];


    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/calendar",BASEURL]
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            
                    }
                                    
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            // Message for the geeks
        UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not change status"
        message:[NSString stringWithFormat:@"%@",error]
        delegate:nil
        cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [failure show];
    }];
    
    [operation start];
    
}


-(void) postContacts:(NSMutableArray *)contacts{
    
    //NSMutableArray *contacts = [[NSMutableArray alloc]initWithObjects:@"6507437883",@"6505678567",@"9047654987",@"609876453"
     //                           , nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    //[params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    //[params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];
    [params setValue:contacts forKey:@"contacts"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/contacts",BASEURL]
                                                      parameters:params];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                        //self.response = (NSDictionary *) JSON;
                        NSLog(@"%@",(NSDictionary *) JSON);
                                                                                }
                                         
            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            
                                                                                            
                                // Message for the geeks
            UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Profile Data"
                                        message:[NSString stringWithFormat:@"%@",error]
                                        delegate:nil
                                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [failure show];
                                        }];
    
    [operation start];
    
}




@end
