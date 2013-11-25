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
#import <CoreLocation/CoreLocation.h>
#import "EDSunriseSet.h"
@interface SettingsViewController ()
@property(strong,nonatomic)NSMutableArray *userContactNames;
@property(strong,nonatomic)NSArray *optionList;
@property(strong,nonatomic)CLLocationManager *locationManager;
@end

@implementation SettingsViewController
bool loggedIn= false;
@synthesize optionList;
@synthesize settingsTable;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view, typically from a nib.
    optionList =[[NSArray alloc]initWithObjects:@"Profile",@"Font and Colors",@"Syncing preferences",@"About", nil];

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

-(void)startSignificantLocationUpdates{
    if(locationManager==NULL){
    
        locationManager = [[CLLocationManager alloc]init];
    }
    
    locationManager.delegate=self;
    [locationManager startMonitoringSignificantLocationChanges];

    CLLocation *location = [locationManager location];
    NSLog(@"%f,%f",location.coordinate.latitude, location.coordinate.longitude);
    // After you've got the initial coordinates, turn the GPS off
    [locationManager stopMonitoringSignificantLocationChanges];
    
    EDSunriseSet *sunsetSunriseTime = [EDSunriseSet sunrisesetWithTimezone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"] latitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    NSDateComponents *comp1 = sunsetSunriseTime.localSunrise;
    NSLog(@"%ld",(long)[comp1 hour]);
    NSDateComponents *comp2 = sunsetSunriseTime.localSunset;
    NSLog(@"%ld",(long)[comp2 hour]);


    
}
- (void)locationManager:(CLLocationManager *)manager

     didUpdateLocations:(NSArray *)locations {
    
    // If it's a relatively recent event, turn off updates to save power.
    
    CLLocation* location = [locations lastObject];
    
    NSDate* eventDate = location.timestamp;
    
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0) {
        
        // If the event is recent, do something with it.
        
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              
              location.coordinate.latitude,
              
              location.coordinate.longitude);
        
    }
    
}



@end
