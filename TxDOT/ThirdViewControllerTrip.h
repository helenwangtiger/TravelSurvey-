//
//  ThirdViewControllerTrip.h
//  TxDOT
//
//  Created by CYT on 11/15/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SecondDelegate <NSObject>
    -(void) secondViewControllerDismissed:(NSString *)stringForFirst;
@end

@interface ThirdViewControllerTrip : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate, MKMapViewDelegate, UIAlertViewDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    IBOutlet MKMapView *mapView;
    IBOutlet UINavigationBar *topBar;
    UIAlertView *myAlertView;
    UIAlertView *existsAlert;
    UIAlertView *emptyAlert;
    UITextField *tripName;
    NSMutableArray *tripArray;
    NSString *startTime;
    NSString *endTime;
    
    id <SecondDelegate> __unsafe_unretained  myDelegate;
}

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) IBOutlet MKMapView *mapView;
@property(nonatomic,retain) IBOutlet UINavigationBar *topBar;
@property(nonatomic,retain) CLLocation *currentLocation;
@property(nonatomic,retain) UIAlertView *myAlertView;
@property(nonatomic,retain) UIAlertView *existsAlert;
@property(nonatomic,retain) UIAlertView *emptyAlert;
@property(nonatomic,retain) UITextField *tripName;
@property(nonatomic,retain) NSMutableArray *tripArray;
@property(unsafe_unretained) id <SecondDelegate> myDelegate;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) NSString *endTime;
@end
