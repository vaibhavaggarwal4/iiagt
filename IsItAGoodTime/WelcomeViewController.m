//
//  WelcomeViewController.m
//  IsItAGoodTime
//
//  Created by Vaibhav  Aggarwal on 10/12/13.
//  Copyright (c) 2013 Vaibhav  Aggarwal. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()
@property(nonatomic,strong)NSArray *pageImages;
@property(nonatomic,strong)NSMutableArray *pageViews;
@end

@implementation WelcomeViewController

@synthesize getStartedButton;
@synthesize buttonParentView;
@synthesize tutorialPageControl;
@synthesize tutorialScrollView;
@synthesize pageImages;
@synthesize pageViews;
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
    getStartedButton.frame= CGRectMake(75, 6, 0, 35);
    
    self.pageImages  = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"],[UIImage imageNamed:@"firefox.png"],
                        [UIImage imageNamed:@"apple1.png"],[UIImage imageNamed:@"apple2.png"], nil];
    
    
    NSInteger pageCount = pageImages.count;
    self.tutorialPageControl.currentPage=0;
    self.tutorialPageControl.numberOfPages = pageCount;
    
    self.pageViews = [[NSMutableArray alloc]init];
    
    for(NSInteger i=0;i<pageCount;i++){
        [self.pageViews addObject:[NSNull null]];
    }
    
    
    
   
}

-(void)viewWillAppear:(BOOL)animated
{
    CGSize pageScrollViewSize = self.tutorialScrollView.frame.size;
    
    self.tutorialScrollView.contentSize = CGSizeMake(pageScrollViewSize.width * self.pageImages.count, pageScrollViewSize.height);
    [self loadVisiblePages];
}
-(void)loadPage:(NSInteger )page
{
    if(page<0 || page>=self.pageImages.count)
    {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.tutorialScrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.tutorialScrollView addSubview:newPageView];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}
-(void)purgePage : (NSInteger)page
{
    if(page<0 || page>=self.pageViews.count)
    {
        return;
    }
    
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if((NSNull *)pageView != [NSNull null]){
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}
-(void)loadVisiblePages{
    
    CGFloat pageWidth = self.tutorialScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.tutorialScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.tutorialPageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}
-(void)viewDidAppear:(BOOL)animated
{
   
    
    [UIView animateWithDuration:0.6f
                     animations:^{
                         // getStartedButton.transform = CGAffineTransformMakeTranslation(0, -80);
                         buttonParentView.transform=CGAffineTransformMakeTranslation(0, -160);
                         
                         // self.getStartedButton.alpha = 0.0;
                         // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                         
                     }
     
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:.6f
                                          animations:^{
                                              // getStartedButton.transform = CGAffineTransformMakeTranslation(0, -80);
                                              getStartedButton.alpha=0.9;
                                              // self.getStartedButton.alpha = 0.0;
                                              // self.infoView.frame=CGRectMake(self.infoView.center.x, self.infoView.center.y, 0, 0);
                                              
                                          }
                          
                                          completion:^(BOOL finished){
                                          }];

                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getStartedButton:(id)sender {
    
    
    
}
@end
