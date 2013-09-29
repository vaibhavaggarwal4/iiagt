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
@interface SettingsViewController ()
@property(strong,nonatomic)NSMutableArray *userContacts;

@end

@implementation SettingsViewController
@synthesize userContacts;
ABAddressBookRef addressBook ;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   // [self getCalendarData];
    CFErrorRef error = NULL;
    
    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRegisterExternalChangeCallback(addressBook,addressBookChanged,(__bridge void *)(self));
    [self determineAccessToAddressBookAndHandle];
}

-(void)viewDidAppear:(BOOL)animated{
    [self checkIfNewUserAndPresentLoginView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkIfNewUserAndPresentLoginView{

    UIStoryboard *storyboard = self.storyboard;
    
    LoginViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    UINavigationController *loginNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:svc];
    svc.navigationController.navigationBarHidden=true;
    [self presentViewController:loginNavigationController animated:YES completion:nil];
    
    //To dismiss
    //[loginNavigationController dissmissViewController]
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
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];
    [params setValue:contacts forKey:@"contacts"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"http://localhost:8080/user/contacts"
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
