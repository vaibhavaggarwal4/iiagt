//
//  SecondViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/17/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "SettingsViewController.h"
#import <EventKit/EventKit.h>
#import <AddressBook/AddressBook.h>
#import "LoginViewController.h"
#import "ContactsCell.h"
#import "SettingCell.h"
#import "AppDelegate.h"
#import "WelcomeViewController.h"
@interface SettingsViewController ()
@property(strong,nonatomic)NSMutableArray *userContacts;
@property(strong,nonatomic)NSMutableArray *userContactNames;
@property(strong,nonatomic)NSArray *optionList;
@end

@implementation SettingsViewController
@synthesize userContacts;
bool loggedIn= false;
ABAddressBookRef addressBook ;
@synthesize optionList;
@synthesize settingsTable;
- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view, typically from a nib.
    optionList =[[NSArray alloc]initWithObjects:@"Profile",@"Font and Colors",@"Syncing preferences",@"About", nil];
   // [self getCalendarData];
    CFErrorRef error = NULL;
    
    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRegisterExternalChangeCallback(addressBook,addressBookChanged,(__bridge void *)(self));
    [self determineAccessToAddressBookAndHandle];

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
            NSDateComponents *ondeDayAgaoComponents = [[NSDateComponents alloc]init];
            ondeDayAgaoComponents.day = -1;
            
            NSDate *oneDayAgo = [calendar dateByAddingComponents:ondeDayAgaoComponents toDate:[NSDate date] options:0];
            
            NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc]init];
            
            oneYearFromNowComponents.day=+1;
            NSDate *oneYearFromNow =[calendar dateByAddingComponents:oneYearFromNowComponents toDate:[NSDate date] options:0];
            
            NSPredicate *predicate =[store predicateForEventsWithStartDate:oneDayAgo endDate:oneYearFromNow calendars:nil];
            
            
            // eventsmatching predicate is synchronous, do not run this on the main thread
            // run this on a seperate background thread
           NSArray *cal = [store eventsMatchingPredicate:predicate];
            
            for(NSObject *item in cal){
                NSLog(@"%@",item);
            }
            NSLog(@"%@",[cal valueForKey:@"title"]);
            NSLog(@"%@",[cal valueForKey:@"startDate"]);
            NSLog(@"%@",[cal valueForKey:@"endDate"]);
            NSLog(@"%@",[cal valueForKey:@"timeZone"]);



        }
        else{
            NSLog(@"yaar!");
        }
    }];
    
}
-(void) determineAccessToAddressBookAndHandle{
    if(ABAddressBookGetAuthorizationStatus()==kABAuthorizationStatusNotDetermined){
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted,CFErrorRef accessError){
            [self getAllContactsFromAddressBook];
            
            
        });
        
    }
    else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        [self getAllContactsFromAddressBook];
        
    }
    else {
        NSLog(@"You have blocked the access, go to settings to grant contact access");
    }
    
}

-(void)getAllContactsFromAddressBook{
    
    
    if(addressBook!=NULL){
        NSLog(@"Opened contacts");
        userContacts = [[NSMutableArray alloc]init];
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSLog(@"%lu",(unsigned long)[allContacts count]);
        for(NSUInteger i=0;i<[allContacts count];i++){
            
            ABRecordRef contact = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue((contact), kABPersonLastNameProperty);
            NSLog(@"%@,%@",lastName,firstName);
            NSString *phoneNumber1 = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonPhoneProperty);

            for (CFIndex i = 0; i < ABMultiValueGetCount((__bridge ABMultiValueRef)(phoneNumber1)); i++) {
                
                
                [userContacts addObject:(__bridge id)(ABMultiValueCopyValueAtIndex((__bridge ABMultiValueRef)(phoneNumber1), i))];
                
                
            }
            
        
        }
        
        NSLog(@"%@",userContacts);
        
    }else{
        NSLog(@"cannot load contacts from phone");
    }
    
}

void addressBookChanged(ABAddressBookRef reference, CFDictionaryRef dictionary, void *context) {
    NSLog(@"There was a change in the addressbook");

}

-(void) postContacts:(NSMutableArray *)contacts{
    
    //NSMutableArray *contacts = [[NSMutableArray alloc]initWithObjects:@"6507437883",@"6505678567",@"9047654987",@"609876453"
     //                           , nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
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


    
    
    
    
    
    /*AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
    
    
}*/



@end
