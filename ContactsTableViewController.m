//
//  ContactsTableViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/19/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "ContactsCell.h"
#import "ContactViewController.h"
#import "AppDelegate.h"
#import "Contact.h"
@interface ContactsTableViewController ()

@property(strong,nonatomic)NSMutableArray *contactsArray;

@property(strong,nonatomic)UILabel *availabilityLabel;
@property(strong,nonatomic)NSString *availabilityStatus;
@property(strong,nonatomic)NSDictionary *selfDataDictionary;
@property(strong,nonatomic)NSArray *controlItems;
@property(strong,nonatomic)UISegmentedControl *controlSegment;
@property(strong,nonatomic)NSMutableDictionary *availabilityResponse;
@property(strong,nonatomic)NSMutableArray *filteredContacts;
@property(strong,nonatomic)NSDateFormatter *formatterForCallingHours;
@property(strong,nonatomic)NSNumber *currentUTCTime;
@end

@implementation ContactsTableViewController

@synthesize serverResponse;
@synthesize availabilityLabel;
@synthesize availabilityStatus;
@synthesize selfDataDictionary;
@synthesize controlItems;
@synthesize controlSegment;
@synthesize availabilityResponse;
@synthesize filteredContacts;
@synthesize contactsArray;
@synthesize searchBar;
@synthesize formatterForCallingHours;
@synthesize currentUTCTime;
bool available=true;
bool isCalendarSyncOn=NO;
UIView *headerView;
NSInteger controlSelectedIndex;
UIApplication *networkIndicator;
NSArray *indices;
NSDate *today;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    contactsArray=[[NSMutableArray alloc]init];
    filteredContacts=[[NSMutableArray alloc]init];
    
    networkIndicator= [UIApplication sharedApplication];
    [self.refreshControl addTarget:self action:@selector(loadDataInBackgroundThread) forControlEvents:UIControlEventValueChanged];
    
    controlItems = [NSArray arrayWithObjects: @"Available", @"Busy", @"Driving",@"Calendar", nil];
    
    controlSegment = [[UISegmentedControl alloc]initWithItems:controlItems];
    [controlSegment addTarget:self action:@selector(updateAvailabilityAndControl :) forControlEvents:UIControlEventValueChanged];
    controlSegment.frame = CGRectMake(60, 40, 200, 20);
    
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
    self.navigationItem.titleView=controlSegment;
    [self loadDataInBackgroundThread];
    indices=[[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D", nil];
    formatterForCallingHours = [[NSDateFormatter alloc]init];
    [formatterForCallingHours setDateFormat:@"yyyy-MM-dd HH:mm"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        headerView.alpha=0.7f;

        availabilityLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
        //availabilityLabel.center=headerView.center;
        [availabilityLabel setTextAlignment:NSTextAlignmentCenter];
        // get the users calendar sync yes or no
        // if yes, see meeting start and end and then decide, basically set the availability status here
        // if no do this
    if(isCalendarSyncOn){
        controlSegment.selectedSegmentIndex = 3;
        headerView.backgroundColor=[UIColor blueColor];


    }
    else{
        if([availabilityStatus isEqualToString:@"Available"]){
            controlSegment.selectedSegmentIndex = 0;
            headerView.backgroundColor=[UIColor greenColor];

            
        }else if([availabilityStatus isEqualToString:@"Busy"])
        {
            controlSegment.selectedSegmentIndex = 1;
            headerView.backgroundColor=[UIColor redColor];

            
        }else{
            controlSegment.selectedSegmentIndex = 2;
            headerView.backgroundColor=[UIColor yellowColor];

            
        }
    }
        // [headerView addSubview:controlSegment];
        availabilityLabel.text=availabilityStatus;
        [headerView addSubview:availabilityLabel];
        controlSelectedIndex=controlSegment.selectedSegmentIndex;
        return headerView;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredContacts count];
    } else {
        return [contactsArray count];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *contactCellIdentifier = @"contactCell";
    ContactsCell *contactCell = (ContactsCell *)[tableView dequeueReusableCellWithIdentifier:contactCellIdentifier];
    
    if (contactCell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ContactsCell" owner:self options:nil];
		contactCell = [nib objectAtIndex:0];
    }
    
    Contact *contact;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        contact = [filteredContacts objectAtIndex:indexPath.row];
    }
    else{
        contact = [contactsArray objectAtIndex:indexPath.row];

    }
    
        contactCell.nameLabel.text = contact.name;
        contactCell.timeZoneLabel.text=contact.localTime;
        contactCell.lastSyncedLabel.text=contact.lastSynced;
        if([contact.calendarSync isEqualToString:@"No"]){
    
            if([contact.availability isEqualToString:@"Available"]){
                contactCell.statusImage.image=[UIImage imageNamed:@"available.png"];
            }
            else if([contact.availability isEqualToString:@"Busy"]){
                //contactCell.availabilityLabel.textColor=[UIColor redColor];
                contactCell.statusImage.image=[UIImage imageNamed:@"busy.png"];
            }
            else{
                contactCell.statusImage.image=[UIImage imageNamed:@"car.png"];
                //contactCell.availabilityLabel.textColor=[UIColor redColor];
            }
            
    }else{
        
            if(![contact.meetingStartTime isKindOfClass:[NSNull class]]){
                contactCell.statusImage.image=[UIImage imageNamed:@"busy.png"];

            }
            else{
                if([contact.callingHoursStartTime integerValue]<[currentUTCTime integerValue] && [contact.callingHoursEndTime integerValue]>[currentUTCTime integerValue]){
                    contactCell.statusImage.image=[UIImage imageNamed:@"available.png"];

                }
                else{
                    contactCell.statusImage.image=[UIImage imageNamed:@"busy.png"];

                }

            }
    }
    /*else {
    
    
    // Configure the cell...
        NSString *number = [contactPhoneNumbers objectAtIndex:indexPath.row];
        contactCell.nameLabel.text = [contactNamesDictionary valueForKey:number];
        contactCell.timeZoneLabel.text=[contactsLocalTimeDictionary valueForKey:number];
        contactCell.lastSyncedLabel.text=[contactsLastSyncedDictionary valueForKey:number];
        if([[contactAvailabilityDictionary valueForKey:number] isEqualToString:@"Available"]){
            contactCell.statusImage.image=[UIImage imageNamed:@"available.png"];

        }
       else if([[contactAvailabilityDictionary valueForKey:number] isEqualToString:@"Busy"]){
            //contactCell.availabilityLabel.textColor=[UIColor redColor];
            contactCell.statusImage.image=[UIImage imageNamed:@"busy.png"];
            
        }
        else{
            contactCell.statusImage.image=[UIImage imageNamed:@"car.png"];
            //contactCell.availabilityLabel.textColor=[UIColor redColor];


            }
        }*/
   // contactCell.availabilityLabel.text=[contactAvailabilityDictionary valueForKey:number];
    return contactCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"contactSegue" sender:tableView];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"contactSegue"])
        
    {
        ContactViewController *destinationViewController = segue.destinationViewController;
        Contact *contact;
        if(sender == self.searchDisplayController.searchResultsTableView) {
            NSIndexPath *path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];

            contact = [filteredContacts objectAtIndex:path.row];
        }
        else{
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];

            contact = [contactsArray objectAtIndex:path.row];
        }
        
        
        destinationViewController.passedName = contact.name;
        destinationViewController.passedPhoneNumber=contact.number;
        destinationViewController.passedAvailabilityStatus=contact.availability;
        destinationViewController.passedCurrentTime=contact.localTime;
        destinationViewController.passedLastSynced=contact.lastSynced;
        destinationViewController.hasWhatsapp = contact.hasWhatsapp;
        destinationViewController.hasViber = contact.hasViber;
        
        
    }

}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filteredContacts removeAllObjects];
    NSPredicate *predicate;
    // Filter the array using NSPredicate
    NSString *regEx = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    if([phoneTest evaluateWithObject:searchText]){
        predicate = [NSPredicate predicateWithFormat:@"SELF.number BEGINSWITH[c] %@",searchText];
        filteredContacts = [NSMutableArray arrayWithArray:[contactsArray filteredArrayUsingPredicate:predicate]];
    }
    
    else{
    predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    filteredContacts = [NSMutableArray arrayWithArray:[contactsArray filteredArrayUsingPredicate:predicate]];
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)loadDataInBackgroundThread{
    
    if(contactsArray.count>0){
        [contactsArray removeAllObjects];
    
    }
    networkIndicator.networkActivityIndicatorVisible=YES;
    
    dispatch_queue_t loadDataQueue = dispatch_queue_create("dataLoadingQueue", NULL);
    [self.refreshControl beginRefreshing];
        dispatch_async(loadDataQueue, ^{
            [self loadData];

           // [self loadSelfStatus];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
                networkIndicator.networkActivityIndicatorVisible=NO;
            
            });
        
        
        });
   

}


-(void)loadSelfStatus{
    
    today = [NSDate date];

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:[NSString stringWithFormat:@"%@user/self",BASEURL]
                                                      parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                            selfDataDictionary =(NSDictionary *) JSON;
                            currentUTCTime= [selfDataDictionary valueForKey:@"currentTime"];
                            //[self setYearMonthAndDayWithUTC:[currentUTCTime doubleValue]];

                            NSString *calendarSync=[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"calendar_sync"] objectAtIndex:0];
                            if([calendarSync isEqualToString:@"No"]){
                                isCalendarSyncOn=NO;
                                 availabilityStatus=[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"user_set_busy"] objectAtIndex:0];
                                }
                            else{
                                // do the comparison with current UTC timestamp in same way as before
                                NSNumber *selfCallingHourStartTime = [self giveTimeStampFromHours:[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"calling_hours_start_time"]objectAtIndex:0] timeZone:[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"user_local_time"]objectAtIndex:0] ];
                                 NSNumber *selfCallingHourEndTime = [self giveTimeStampFromHours:[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"calling_hours_end_time"]objectAtIndex:0] timeZone:[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"user_local_time"]objectAtIndex:0] ];
                                
                                    isCalendarSyncOn=YES;
                                    if(![[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"start_time"] objectAtIndex:0] isKindOfClass:[NSNull class]]){
                                        
                                        availabilityStatus=@"Busy";
                                    }
                                    else
                                    {
                                        if([selfCallingHourStartTime integerValue]<[currentUTCTime integerValue] && [selfCallingHourEndTime integerValue]>[currentUTCTime integerValue]){
                                            availabilityStatus=@"Available";

                                        }
                                        else{
                                            availabilityStatus=@"Busy";

                                        }

                                        
                                    }
                                                    
                                        [self.tableView reloadData];

                                
                                }
                }
                                        
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {                                                      UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Profile Data"
                            message:[NSString stringWithFormat:@"%@",error]
                                    delegate:nil
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [failure show];
                    }];
    
    [operation start];
    
}


-(void)loadData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:[NSString stringWithFormat:@"%@user",BASEURL]
                                                      parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                          
                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    // check for status true or not
                        serverResponse =(NSDictionary *) JSON;
                        [self arrangeDataToDisplay:serverResponse];
                       //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                       // [self.tableView reloadData];
                        [self loadSelfStatus];
                    }
                                          
                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                             
                                                                                             
                        UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Profile Data"
                                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                                    delegate:nil
                                                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [failure show];
            }];

        [operation start];
}

-(IBAction)updateAvailabilityAndControl  :(id)sender{
    if([[controlSegment titleForSegmentAtIndex:[controlSegment selectedSegmentIndex]] isEqualToString:@"Calendar"]){
    // change calendar_sync to Yes
    // figure out how that affects that availability status
        [self turnCalendarOn];
    }
    else{
    [self updateAvailability:[controlSegment titleForSegmentAtIndex:[controlSegment selectedSegmentIndex]]];
    }
}

-(void)turnCalendarOn{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/calendarSync",BASEURL]
                                                      parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    // parse response if status true, only then update
                        if([[JSON valueForKey:@"status"] isEqualToString:@"true" ]){
                                    //availabilityStatus=available;
                            // call this in background thread
                            // or if we do not want to make this call, we can send join the meeting table here as well
                            // you should make this call, otherwise you would not know if the user has a meeting at this time or not
                            isCalendarSyncOn=YES;

                                    [self loadSelfStatus];
                                  //  [self.tableView reloadData];
                            
                            
                            }
                        else{
                            
                            UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not change status"
                                                    message:[NSString stringWithFormat:@"Try again later"]
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                    controlSegment.selectedSegmentIndex=controlSelectedIndex;
                                                    [failure show];
                                                                                                
                                                                                                
                            }
                                                                                            
                }
                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                        // Message for the geeks
                        UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not change status"
                        message:[NSString stringWithFormat:@"%@",error]
                        delegate:nil
                        cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        controlSegment.selectedSegmentIndex=controlSelectedIndex;
                        [failure show];
                    }];
    
    [operation start];


}
-(void)updateAvailability:(NSString *) available{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    [params setValue:@"user_set_busy" forKey:@"target"];
    [params setValue:available forKey:@"value"];

    
    
       AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/changeStatus",BASEURL]
                                                      parameters:params];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request

        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            // parse response if status true, only then update
                    if([[JSON valueForKey:@"status"] isEqualToString:@"true" ]){
                        isCalendarSyncOn=NO;
                        availabilityStatus=available;
                        [self.tableView reloadData];

                    }
                    else{
                        
                        UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not change status"
                                                                          message:[NSString stringWithFormat:@"Try again later"]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        controlSegment.selectedSegmentIndex=controlSelectedIndex;
                        [failure show];

                        
                    }
                    
                }

        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    // Message for the geeks
                    UIAlertView *failure = [[UIAlertView alloc] initWithTitle:@"Could not change status"
                                                                      message:[NSString stringWithFormat:@"%@",error]
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK" otherButtonTitles:nil];
            controlSegment.selectedSegmentIndex=controlSelectedIndex;
            [failure show];
                }];

[operation start];

    
    
}
-(void)arrangeDataToDisplay:(NSDictionary *)response{
   // NSLog(@"%@",response);
    //NSLog(@"%lu",(unsigned long)[[response valueForKey:@"contacts"] count]);
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    for(id contact in [response valueForKeyPath:@"contacts"]){
        //NSLog(@"%@",contact);
        
        Contact *appContact = [[Contact alloc]init];
        
        appContact.number = [contact valueForKey:@"user_phone_number"];
        appContact.name = [contact valueForKeyPath:@"user_name"];
        appContact.lastSynced = [self getDateFromTimeStamp:[contact valueForKeyPath:@"last_synced"]];
        appContact.localTime =[self giveTimeForTimeZone:[contact valueForKeyPath:@"user_local_time"] withFormatter:formatter andDate:now];
       // appContact.skyColor=[NSNumber numberWithInt:[self giveHourforDate:now]];
        appContact.hasWhatsapp= [contact valueForKeyPath:@"has_whatsapp"];
        appContact.hasViber = [contact valueForKeyPath:@"has_viber"];
        appContact.availability = [contact valueForKeyPath:@"user_set_busy"];
        appContact.calendarSync=[contact valueForKey:@"calendar_sync"];
        if([appContact.calendarSync isEqualToString:@"Yes"]){
            appContact.meetingStartTime=[contact valueForKey:@"start_time"];
            appContact.meetingEndTime=[contact valueForKey:@"end_time"];
            appContact.callingHoursStartTime=[self giveTimeStampFromHours:[contact valueForKey:@"calling_hours_start_time"] timeZone:[contact valueForKeyPath:@"user_local_time"]];
            appContact.callingHoursEndTime=[self giveTimeStampFromHours:[contact valueForKey:@"calling_hours_end_time"] timeZone:[contact valueForKeyPath:@"user_local_time"]];
        }
        [self.contactsArray addObject:appContact];
        
    }
    if([contactsArray count]<1){
        UIAlertView *noContacts = [[UIAlertView alloc] initWithTitle:@"You do not have any contacts using the app"
                                                          message:[NSString stringWithFormat:@"Go to all contacts and invite your friends"]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK" otherButtonTitles:nil];
        controlSegment.selectedSegmentIndex=controlSelectedIndex;
        [noContacts show];

    
    }
    [self.tableView reloadData];
    
    

}

-(int)giveHourforDate:(NSDate *)date{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    return [components hour];
}
-(NSString *)giveTimeForTimeZone:(NSString *)timeZone withFormatter:(NSDateFormatter *)dateFormatter andDate:(NSDate *)date
{
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
   

    return [dateFormatter stringFromDate:date];
}
- (NSString *) getDateFromTimeStamp:(NSString *)timeStamp
{
    
    
    NSTimeInterval epoch = [timeStamp doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:epoch];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *formattedDate=[dateFormatter stringFromDate:date];
    return formattedDate;
    
}

-(NSNumber *)giveTimeStampFromHours:(NSString *)hours timeZone:(NSString *)timeZone
{
    if(!today){
        today=[NSDate date];
    }

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    [formatterForCallingHours setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    NSDateComponents* components = [gregorian components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSTimeZoneCalendarUnit fromDate:today];
    NSString *year  = [NSString stringWithFormat:@"%d",[components year]];
    NSString *month = [NSString stringWithFormat:@"%d",[components month]];
    NSString *day   = [NSString stringWithFormat:@"%d",[components day]];
    NSDate *date =  [formatterForCallingHours dateFromString:[NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,hours]];
    
    return [NSNumber numberWithLong:[date timeIntervalSince1970]];
    //return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
}


@end
