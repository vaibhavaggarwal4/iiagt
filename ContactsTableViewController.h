//
//  ContactsTableViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 9/19/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong,nonatomic)NSDictionary *serverResponse;
@end
