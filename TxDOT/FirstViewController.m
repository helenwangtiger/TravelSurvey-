//
//  FirstViewController.m
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "FirstViewController.h"
#import "RegistrationViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize textview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Instructions", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_settings.png"];
    }
    return self;
}
- (void)viewDidLayoutSubviews{
    if(loadRegistration) {
        RegistrationViewController *reg =[[RegistrationViewController alloc]initWithNibName:nil bundle:nil];
        [self presentViewController:reg animated:NO completion:nil];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *sampleNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"sample_number"];
    if(sampleNumber==nil) {
        loadRegistration = YES;
    }
    else {
        loadRegistration = NO;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    
    float sysversion= [[[UIDevice currentDevice]systemVersion]floatValue];
    CGSize screensize= [[UIScreen mainScreen]bounds].size;
    if(sysversion >=6.0 && sysversion <7.0){
        //iphone 3.5 inch
        if (screensize.height<500) {
            [textView setFrame:CGRectMake(5, 55, 320, 360)];
            
        }
        // iphone 4 inch
        if(screensize.height>500){
            [textView setFrame:CGRectMake(5, 50, 320, 460)];
               }
    }
    if (sysversion >= 7.0) {
        //3.5 inch
        if (screensize.height < 500) {
            [textView setFrame:CGRectMake(5, 50, 320, 385)];
            
            
        }
        //4 inch
        if (screensize.height > 500) {
            [textView setFrame:CGRectMake(5, 50, 320, 470)];
            
        
        }

    }



}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
