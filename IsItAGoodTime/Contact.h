//
//  Contact.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/12/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *lastSynced;
@property(nonatomic,strong)NSString *localTime;
@property(nonatomic,strong)NSNumber *hasWhatsapp;
@property(nonatomic,strong)NSNumber *hasViber;
@property(nonatomic,strong)NSString *availability;
@end