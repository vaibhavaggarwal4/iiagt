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
@interface ContactsTableViewController ()
@property(strong,nonatomic)NSMutableArray *contactPhoneNumbers;
@property(strong,nonatomic)NSMutableDictionary *contactsLastSyncedDictionary;
@property(strong,nonatomic)NSMutableDictionary *contactsLocalTimeDictionary;
@property(strong,nonatomic)NSMutableDictionary *contactNamesDictionary;
@property(strong,nonatomic)NSMutableDictionary *contactHasViberDictionary;
@property(strong,nonatomic)NSMutableDictionary *contactHasWhatsappDictionary;
@property(strong,nonatomic)UILabel *availabilityLabel;
@property(strong,nonatomic)NSString *availabilityStatus;
@property(strong,nonatomic)NSDictionary *selfDataDictionary;
@property(strong,nonatomic)NSArray *controlItems;
@property(strong,nonatomic)UISegmentedControl *controlSegment;
@end

@implementation ContactsTableViewController
@synthesize serverResponse;
@synthesize contactNamesDictionary;
@synthesize contactPhoneNumbers;
@synthesize contactsLastSyncedDictionary;
@synthesize contactsLocalTimeDictionary;
@synthesize contactHasViberDictionary;
@synthesize contactHasWhatsappDictionary;
@synthesize availabilityLabel;
@synthesize availabilityStatus;
@synthesize selfDataDictionary;
@synthesize controlItems;
@synthesize controlSegment;
bool available=true;
UIApplication *networkIndicator;
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
    
    
    networkIndicator= [UIApplication sharedApplication];
    [self.refreshControl addTarget:self action:@selector(loadDataInBackgroundThread) forControlEvents:UIControlEventValueChanged];
    
    
    controlItems = [NSArray arrayWithObjects: @"Available", @"Busy", @"Driving", nil];
    controlSegment = [[UISegmentedControl alloc]initWithItems:controlItems];
    [controlSegment addTarget:self action:@selector(updateAvailabilityAndControl :) forControlEvents:UIControlEventValueChanged];
    
    [self loadDataInBackgroundThread];
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

    return 80;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    //headerView.backgroundColor=[UIColor grayColor];
    availabilityLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 14, 200, 20)];
    //availabilityLabel.center=headerView.center;
    [availabilityLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    
    controlSegment.frame = CGRectMake(60, 40, 200, 20);
    
    if([availabilityStatus isEqualToString:@"Available"]){
        controlSegment.selectedSegmentIndex = 0;

    }else if([availabilityStatus isEqualToString:@"Busy"])
    {
        controlSegment.selectedSegmentIndex = 1;

    }else{
        controlSegment.selectedSegmentIndex = 2;

    }
    [headerView addSubview:controlSegment];
    availabilityLabel.text=availabilityStatus;
    [headerView addSubview:availabilityLabel];

    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[serverResponse valueForKey:@"contacts"] count];
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
    // Configure the cell...
    NSString *number = [contactPhoneNumbers objectAtIndex:indexPath.row];
    contactCell.nameLabel.text = [contactNamesDictionary valueForKey:number];
    contactCell.timeZoneLabel.text=[contactsLocalTimeDictionary valueForKey:number];
    contactCell.lastSyncedLabel.text=[contactsLastSyncedDictionary valueForKey:number];
    
    return contactCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"contactSegue" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"contactSegue"])
        
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ContactViewController *destinationViewController = segue.destinationViewController;
        NSString *number = [contactPhoneNumbers objectAtIndex:path.row];
        destinationViewController.passedName=[contactNamesDictionary valueForKey:number];
        destinationViewController.passedPhoneNumber=number;
        destinationViewController.hasWhatsapp=[contactHasWhatsappDictionary valueForKey:number];
        destinationViewController.hasViber=[contactHasViberDictionary valueForKey:number];
        
        
    }

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
    
    networkIndicator.networkActivityIndicatorVisible=YES;
    
    dispatch_queue_t loadDataQueue = dispatch_queue_create("dataLoadingQueue", NULL);
    [self.refreshControl beginRefreshing];
    dispatch_async(loadDataQueue, ^{
        [self loadSelfStatus];
        [self loadData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            networkIndicator.networkActivityIndicatorVisible=NO;
        });
        
        
    });
}


-(void)loadSelfStatus{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://localhost:8080/user/self"
                                                      parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                         
                                            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                selfDataDictionary =(NSDictionary *) JSON;
                                                availabilityStatus=[[[selfDataDictionary valueForKey:@"details"] valueForKey:@"user_set_busy"] objectAtIndex:0];

                                                [self.tableView reloadData];
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


-(void)loadData {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://localhost:8080/user"
                                                      parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                          
                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                        //self.response = (NSDictionary *) JSON;
                        serverResponse =(NSDictionary *) JSON;
                        [self arrangeDataToDisplay:serverResponse];
                       // [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
                        [self.tableView reloadData];
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
    //NSLog(@"Hey there %@",[controlSegment titleForSegmentAtIndex:[controlSegment selectedSegmentIndex]]);
    [self updateAvailability:[controlSegment titleForSegmentAtIndex:[controlSegment selectedSegmentIndex]]];

}

-(void)updateAvailability:(NSString *) available{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];
    [params setValue:available forKey:@"availibility"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"http://localhost:8080/user/self/available"
                                                      parameters:params];
AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request

        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            // parse response if status true, only then update
            [self loadSelfStatus];
                                    // response will tell status change was successful or not
                                    
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
-(void)arrangeDataToDisplay:(NSDictionary *)response{
   // NSLog(@"%@",response);
    NSLog(@"%lu",(unsigned long)[[response valueForKey:@"contacts"] count]);
    contactPhoneNumbers=[[NSMutableArray alloc]init];
    contactNamesDictionary = [[NSMutableDictionary alloc]init];
    contactsLocalTimeDictionary=[[NSMutableDictionary alloc]init];
    contactsLastSyncedDictionary=[[NSMutableDictionary alloc]init];
    contactHasViberDictionary = [[NSMutableDictionary alloc]init];
    contactHasWhatsappDictionary = [[NSMutableDictionary alloc]init];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    for(id contact in [response valueForKeyPath:@"contacts"]){
        //NSLog(@"%@",contact);
        NSString *number = [contact valueForKey:@"user_phone_number"];
        
        
        [self.contactPhoneNumbers addObject:number];
        [self.contactNamesDictionary setObject:[contact valueForKeyPath:@"user_name"] forKey:number];
        
        [self.contactsLocalTimeDictionary setObject:[self giveTimeForTimeZone:[contact valueForKeyPath:@"user_local_time"] withFormatter:formatter andTime:now] forKey:number];
        
        [self.contactsLastSyncedDictionary setObject:[self getDateFromTimeStamp:[contact valueForKeyPath:@"last_synced"]] forKey:number];
        [self.contactHasViberDictionary setObject:[contact valueForKeyPath:@"has_viber"] forKey:number];
        [self.contactHasWhatsappDictionary setObject:[contact valueForKeyPath:@"has_whatsapp"] forKey:number];
        
    }
    
    /*NSLog(@"%@",contactPhoneNumbers);
    NSLog(@"%@",contactNamesDictionary);
    NSLog(@"%@",contactsLocalTimeDictionary);
    NSLog(@"%@",contactsLastSyncedDictionary);
    NSLog(@"%@",contactHasViberDictionary);
    NSLog(@"%@",contactHasWhatsappDictionary);*/
    
    

}
-(NSString *)giveTimeForTimeZone:(NSString *)timeZone withFormatter:(NSDateFormatter *)dateFormatter andTime:(NSDate *)date
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



@end
