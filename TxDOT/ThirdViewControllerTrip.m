//
//  ThirdViewControllerTrip.m
//  TxDOT
//
//  Created by CYT on 11/15/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "ThirdViewControllerTrip.h"
#import "ThirdViewController.h"
#import "ThirdViewControllerNavTrip.h"
#import "MKMapView+ZoomLevel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ThirdViewControllerTrip ()

@end

@implementation ThirdViewControllerTrip

@synthesize myDelegate,locationManager,currentLocation,mapView,topBar,myAlertView,tripName,tripArray,existsAlert,emptyAlert,startTime,endTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    float sysversion= [[[UIDevice currentDevice]systemVersion]floatValue];
    CGSize screensize= [[UIScreen mainScreen]bounds].size;
    if(sysversion >=6.0 && sysversion <7.0){
        //iphone 3.5 inch
        if (screensize.height<500) {
            [mapView setFrame:CGRectMake(0, 44, 320, 372)];
            [topBar setFrame:CGRectMake(0, 0, 320, 44)];
            
            
        }
        // iphone 4 inch
        if(screensize.height>500){
            [mapView setFrame:CGRectMake(0, 44, 320, 460)];
            [topBar setFrame:CGRectMake(0, 0, 320, 44)];
        }
    }
    if (sysversion >= 7.0) {
        //3.5 inch
        if (screensize.height < 500) {
            [mapView setFrame:CGRectMake(0, 44, 320, 392)];
            [topBar setFrame:CGRectMake(0, 10, 320, 44)];
            
        }
        //4 inch
        if (screensize.height > 500) {
            [mapView setFrame:CGRectMake(0, 54, 320, 470)];
            [topBar setFrame:CGRectMake(0, 0, 320, 54)];
        }
        
    }
}

- (void)viewDidLoad
{
    NSLog(@"vewiDidLoad Called");
    
    [super viewDidLoad];
    
    tripArray = [[NSMutableArray alloc] init];
    mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = YES;
    mapView.zoomEnabled = YES;
    [self.view addSubview:mapView];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 50.0f;
    [locationManager startUpdatingLocation];
    
    myAlertView = [[UIAlertView alloc] initWithTitle:@"Set Trip Name" message:@"Please set a trip name." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Start Trip", nil];
    [myAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [myAlertView show];
    
    [self performSelector:@selector(centerMap) withObject:(self) afterDelay:(2.0)];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self centerMap];

    currentLocation = [locations lastObject];
    
    NSString *lat = [[NSString alloc] initWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSString *lon = [[NSString alloc] initWithFormat:@"%f",currentLocation.coordinate.longitude];
    NSMutableArray *currentCoordinates = [[NSMutableArray alloc] init];
    [currentCoordinates addObject:lat];
    [currentCoordinates addObject:lon];
    [tripArray addObject:currentCoordinates];
    
    NSLog(@"Current Array: %@",currentCoordinates);
    
    lat = nil;
    lon = nil;
    currentCoordinates = nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView == myAlertView) {
        tripName = [myAlertView textFieldAtIndex:0];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"trips.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"plist"];
            [fileManager copyItemAtPath:bundle toPath: path error:&error];
        }
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        id object = [data objectForKey:tripName.text];
        BOOL exists = (object != nil);
        if(tripName.text == NULL || tripName.text == nil || [tripName.text isEqualToString:@""]) {
            emptyAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"The trip name cannot be blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [emptyAlert show];
        }
        else if(exists) {
            existsAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"This trip name is already in use. Please pick another one." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [existsAlert show];
        }
        else {
            topBar.topItem.title = [NSString stringWithFormat:@"Recording Trip: %@",tripName.text];
            NSDate *senddate=[NSDate date];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HH:mm"];
            NSString *startTimeString=[dateformatter stringFromDate:senddate];
            NSCalendar *calendar=[NSCalendar  currentCalendar];
            NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
            NSDateComponents *conponent= [calendar components:unitFlags fromDate:senddate];
            NSInteger year=[conponent year];
            NSInteger month=[conponent month];
            NSInteger day=[conponent day];
            NSString *nsDateString= [NSString  stringWithFormat:@"%4ld-%ld-%ld",(long)year,(long)month,(long)day];
            startTime =[NSString stringWithFormat:@"%@/%@",nsDateString,startTimeString];
            NSLog(@"the compended clendar string is %@",startTime);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *tripPlist = [[NSString alloc] initWithFormat:@"%@.plist",tripName.text];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:tripPlist];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath: path]) {
                path = [documentsDirectory stringByAppendingPathComponent:tripPlist];
            }
            NSMutableDictionary *data;
            if ([fileManager fileExistsAtPath: path]) {
                data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
            }
            else {
                // If the file doesn’t exist, create an empty dictionary
                data = [[NSMutableDictionary alloc] init];
            }
            
            [data setObject:startTime forKey:@"trip_start_time"];
            [data writeToFile:path atomically:YES];
            NSLog(@"data: %@",data);
            NSString *status = @"0";
            [[NSUserDefaults standardUserDefaults] setValue:status forKey:tripName.text];
            [[NSUserDefaults standardUserDefaults] synchronize];
          
        }
    }
    else if(alertView == existsAlert || alertView == emptyAlert) {
        [myAlertView show];
    }
}

- (IBAction)endButton:(id)sender {
    
    NSString *actionSheetTitle = @"Fill out trip information now?"; //Action Sheet Title
    NSString *other1 = @"Yes";
    NSString *other2 = @"No";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Yes"]) {
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        NSString *endTimeString=[dateformatter stringFromDate:senddate];
        NSCalendar *calendar=[NSCalendar  currentCalendar];
        NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents *conponent= [calendar components:unitFlags fromDate:senddate];
        NSInteger year=[conponent year];
        NSInteger month=[conponent month];
        NSInteger day=[conponent day];
        NSString *nsDateString= [NSString  stringWithFormat:@"%4ld-%ld-%ld",(long)year,(long)month,(long)day];
        endTime =[NSString stringWithFormat:@"%@/%@",nsDateString,endTimeString];
        NSLog(@"the end time in yes %@",endTime);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *tripPlist = [[NSString alloc] initWithFormat:@"%@.plist",tripName.text];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:tripPlist];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: path]) {
            path = [documentsDirectory stringByAppendingPathComponent:tripPlist];
        }
        NSMutableDictionary *data;
        if ([fileManager fileExistsAtPath: path]) {
            data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        }
        else {
            // If the file doesn’t exist, create an empty dictionary
            data = [[NSMutableDictionary alloc] init];
        }
        
        [data setObject:endTime forKey:@"trip_end_time"];
        [data writeToFile:path atomically:YES];
        NSLog(@"data: %@",data);
        [self saveData];
        [locationManager stopUpdatingLocation];
        [self.myDelegate secondViewControllerDismissed:tripName.text];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([buttonTitle isEqualToString:@"No"]) {
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HH:mm"];
        NSString *endTimeString=[dateformatter stringFromDate:senddate];
        NSCalendar *calendar=[NSCalendar  currentCalendar];
        NSUInteger unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents *conponent= [calendar components:unitFlags fromDate:senddate];
        NSInteger year=[conponent year];
        NSInteger month=[conponent month];
        NSInteger day=[conponent day];
        NSString *nsDateString= [NSString  stringWithFormat:@"%4ld-%ld-%ld",(long)year,(long)month,(long)day];
        endTime=[NSString stringWithFormat:@"%@%@",nsDateString,endTimeString];
        NSLog(@"the end time in no %@",endTime);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",tripName.text]];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [data setObject:endTime forKey:@"trip_end_time"];
        [data writeToFile:path atomically:YES];
        [self saveData];
        [locationManager stopUpdatingLocation];
        [self.myDelegate secondViewControllerDismissed:@"fillouttripinfonowusersaidno"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)saveData {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"trips.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    [data setObject:tripArray forKey:tripName.text];
    [data writeToFile:path atomically:YES];
    
    NSLog(@"Path: %@",path);
    NSLog(@"Value: %@",tripArray);
    NSLog(@"Key: %@",tripName.text);
    NSLog(@"Data: %@",data);
    
    if (![data writeToFile:path atomically:YES]) {
        NSLog(@"Error with creating Plist");
    }
}

-(void)centerMap {
    //currentLocation.latitude = mapView.userLocation.location.coordinate.latitude;
    //currentLocation.longitude = mapView.userLocation.location.coordinate.longitude;
    self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied) {
        NSString *msg =  @"You don't have location information enabled. Please go to Settings and enable the GPS location for this app. Thanks.";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
