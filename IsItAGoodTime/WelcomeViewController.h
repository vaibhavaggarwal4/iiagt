//
//  WelcomeViewController.h
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/12/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController <UIScrollViewDelegate>
- (IBAction)getStartedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;
@property (weak, nonatomic) IBOutlet UIView *buttonParentView;
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *tutorialPageControl;
@end
