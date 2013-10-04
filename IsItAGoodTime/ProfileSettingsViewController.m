//
//  ProfileSettingsViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/3/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "ProfileSettingsViewController.h"

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
    
    if(viberSwitch.on){
        viberLabel.text=@"Yes";
    }
    if(whatsappSwitch.on)
    {
        whatsappLabel.text=@"Yes";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)updateViber:(id)sender{
    
    
    if(viberSwitch.on){
        [self updateStatus:@"viber" withValue:on];
        viberLabel.text=@"Yes";

    }
    else{
        [self updateStatus:@"viber" withValue:off];
        viberLabel.text=@"No";


    }
}

-(IBAction)updateWhatsapp:(id)sender{
    if(whatsappSwitch.on)
    {
        [self updateStatus:@"whatsapp" withValue:on];
        whatsappLabel.text=@"Yes";
    }
    else{
        
        [self updateStatus:@"whatsapp" withValue:off];
        whatsappLabel.text=@"No";
    }
}

-(void)updateStatus:(NSString *)appName withValue:(NSNumber *)value{
   
  
    
     NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:@"f8b02e92e32f62d878e3289e04044057" forKey:@"unique_hash"];
    [params setValue:@"7019361484" forKey:@"phone_number"];
    [params setValue:value forKey:appName];
    
    NSString *path =[NSString stringWithFormat:@"http://localhost:8080/user/self/%@",appName];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost:8080/"]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:path
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
