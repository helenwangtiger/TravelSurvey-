//
//  ThirdViewController.m
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "ThirdViewController.h"
#import "ThirdViewControllerTrip.h"
#import "ThirdViewControllerNavTrip.h"
#import <MapKit/MapKit.h>

@interface ThirdViewController ()

@end

@implementation ThirdViewController

@synthesize mapView,tripName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Route", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_record.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"tripName: %@",tripName);
    if([tripName isEqualToString:@"fillouttripinfonowusersaidno"]) {
        [self.tabBarController setSelectedIndex:3];
        tripName = nil;
    }
    else if(tripName != nil) {
        [self.tabBarController setSelectedIndex:3];
        ThirdViewControllerNavTrip *trip = [[ThirdViewControllerNavTrip alloc] initWithNibName:nil bundle:nil];
        trip.tripName = tripName;
        trip.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:trip animated:YES completion:nil];
        tripName = nil;
    }
 
        float sysversion= [[[UIDevice currentDevice]systemVersion]floatValue];
        CGSize screensize= [[UIScreen mainScreen]bounds].size;
        if(sysversion >=6.0 && sysversion <7.0){
            //iphone 3.5 inch
            if (screensize.height<500) {
                [mapView setFrame:CGRectMake(0, 0, 320, 440)];

            }
            // iphone 4 inch
            if(screensize.height>500){
                [mapView setFrame:CGRectMake(0, 0, 320, 528)];
                            }
        }
        if (sysversion >= 7.0) {
            //3.5 inch
            if (screensize.height < 500) {
                [mapView setFrame:CGRectMake(0, 0, 320, 440)];
                            }
            //4 inch
            if (screensize.height > 500) {
                [mapView setFrame:CGRectMake(0, 0, 320, 528)];
                
            }
            
        }

}

- (void)secondViewControllerDismissed:(NSString *)stringForFirst
{
    tripName = stringForFirst;
}

- (IBAction)startButton:(id)sender {
   
    ThirdViewControllerTrip *trip = [[ThirdViewControllerTrip alloc] initWithNibName:nil bundle:nil];
    trip.myDelegate = self;

	[self presentViewController:trip animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end        


