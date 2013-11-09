//
//  AllContactsTableViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/28/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "AllContactsTableViewController.h"
#import <AddressBook/AddressBook.h>
#import "ContactsCell.h"
#import "Contact.h"


@interface AllContactsTableViewController ()
@property(strong,nonatomic)NSMutableArray *userContacts;

@end

@implementation AllContactsTableViewController
ABAddressBookRef addressBook ;
@synthesize userContacts;
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
    CFErrorRef error = NULL;
    
    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRegisterExternalChangeCallback(addressBook,addressBookChanged,(__bridge void *)(self));
    [self determineAccessToAddressBookAndHandle];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [userContacts count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
    Contact *contact=[userContacts objectAtIndex:indexPath.row];
    contactCell.nameLabel.text=contact.name;
    return contactCell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       

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
            Contact *userPhoneContact = [[Contact alloc]init];

            ABRecordRef contact = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue((contact), kABPersonLastNameProperty);
            NSLog(@"%@,%@",lastName,firstName);
            userPhoneContact.name=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
            NSString *phoneNumber1 = (__bridge_transfer NSString *)ABRecordCopyValue(contact, kABPersonPhoneProperty);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount((__bridge ABMultiValueRef)(phoneNumber1)); i++) {
                
                
                //[userContacts addObject:(__bridge id)(ABMultiValueCopyValueAtIndex((__bridge ABMultiValueRef)(phoneNumber1), i))];
                
                
            }
            [userContacts addObject:userPhoneContact];
            
        }
       
        NSLog(@"%@",userContacts);
        [self.tableView reloadData];
        
    }else{
        NSLog(@"cannot load contacts from phone");
    }
    
}

void addressBookChanged(ABAddressBookRef reference, CFDictionaryRef dictionary, void *context) {
    NSLog(@"There was a change in the addressbook");
    
}

@end
