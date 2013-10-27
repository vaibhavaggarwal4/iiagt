//
//  ProfileSettingsViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/3/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "AppDelegate.h"
@interface ProfileSettingsViewController ()

@end

@implementation ProfileSettingsViewController
@synthesize whatsappLabel;
@synthesize viberLabel;
@synthesize viberSwitch;
@synthesize whatsappSwitch;
NSNumber *on;
NSNumber *off;

// TODO : Do JSON operation in background thread
// Show network activity indicator
// change text only if operation was successfull
// Switch default states should be preserved, either fetch from server every time
// or save them with core data, NSUserDefaults might be a very good choice for this

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
    on=[NSNumber numberWithInt:1];
    off=[NSNumber numberWithInt:0];
    [viberSwitch addTarget:self action:@selector(updateViber:) forControlEvents:UIControlEventValueChanged];
    [whatsappSwitch addTarget:self action:@selector(updateWhatsapp:) forControlEvents:UIControlEventValueChanged];
    
    
    
    if([[prefs valueForKey:@"viber"] isEqualToString:@"Yes" ]){
        viberSwitch.on=YES;
        viberLabel.textColor=[UIColor greenColor];
        viberLabel.text=@"Yes";
    }
    else{
        viberSwitch.on=NO;
        viberLabel.text=@"No";

    }
    
    
    if([[prefs valueForKey:@"whatsapp"] isEqualToString:@"Yes"])
    {
        whatsappSwitch.on=YES;
        whatsappLabel.textColor=[UIColor greenColor];
        whatsappLabel.text=@"Yes";
    }
    else{
        whatsappSwitch.on=NO;
        whatsappLabel.text=@"No";

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)updateViber:(id)sender{
    
    
    if(viberSwitch.on){
        [self updateStatus:@"has_viber" withValue:on];
        
        // do all this only if above was successfull
        
        [prefs setObject:@"Yes" forKey:@"viber"];
        [prefs synchronize];
        viberLabel.textColor=[UIColor greenColor];

        viberLabel.text=@"Yes";

    }
    else{
        
        [self updateStatus:@"has_viber" withValue:off];
        [prefs setObject:@"No" forKey:@"viber"];
        [prefs synchronize];
        viberLabel.textColor=[UIColor redColor];

        viberLabel.text=@"No";
  

    }
}

-(IBAction)updateWhatsapp:(id)sender{
    if(whatsappSwitch.on)
    {
        [self updateStatus:@"has_whatsapp" withValue:on];
        [prefs setObject:@"Yes" forKey:@"whatsapp"];
        [prefs synchronize];
        whatsappLabel.textColor=[UIColor greenColor];

        whatsappLabel.text=@"Yes";
    }
    else{
        
        [self updateStatus:@"has_whatsapp" withValue:off];
        [prefs setObject:@"No" forKey:@"whatsapp"];
        [prefs synchronize];
        whatsappLabel.textColor=[UIColor redColor];

        whatsappLabel.text=@"No";
    }
}

-(void)updateStatus:(NSString *)target withValue:(NSNumber *)value{
   

    
     NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[prefs valueForKey:@"appUserUniqueHash"] forKey:@"unique_hash"];
    [params setValue:[prefs valueForKey:@"appUserPhoneNumber"] forKey:@"phone_number"];
    [params setValue:target forKey:@"target"];
    [params setValue:value forKey:@"value"];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:[NSString stringWithFormat:@"%@user/changeStatus",BASEURL]
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


@end
