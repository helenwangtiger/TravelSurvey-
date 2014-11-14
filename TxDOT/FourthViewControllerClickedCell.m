//
//  FourthViewControllerClickedCell.m
//  TxDOT
//
//  Created by CYT on 11/26/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import "FourthViewControllerClickedCell.h"
#import "ThirdViewControllerNavTrip.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "MKMapView+ZoomLevel.h"

@interface FourthViewControllerClickedCell ()

@end

@implementation FourthViewControllerClickedCell
@synthesize tripName,topBar,mapView;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    topBar.topItem.title = [[NSString alloc] initWithFormat:@"Trip Details : %@",tripName];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard;
    mapView.showsUserLocation = NO;
    mapView.zoomEnabled = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tripPlist = [[NSString alloc] initWithFormat:@"trips.plist"];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:tripPlist];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path]) {
        path = [documentsDirectory stringByAppendingPathComponent:tripPlist];
    }
    NSMutableDictionary *data;
    if ([fileManager fileExistsAtPath: path]) {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
    else {
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
    NSArray *tripData = [[NSArray alloc] initWithArray:[data objectForKey:tripName]];
    NSLog(@"Trip data: %@",tripData);
    if (tripData.count == 0) {
        UIAlertView *tripsAlert = [[UIAlertView alloc] initWithTitle:@"Trips" message:@"The location information is null. Please check your location service." delegate:self    cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [tripsAlert show];
    }
    else {
        NSLog(@"Lat: %@",tripData[0][0]);
        NSLog(@"Lon: %@",tripData[0][1]);
        CLLocationCoordinate2D mapCenter;
        double latitudeDouble = [tripData[0][0] doubleValue];
        CLLocationDegrees latitude = latitudeDouble;
        double longitudeDouble = [tripData[0][1] doubleValue];
        CLLocationDegrees longitude = longitudeDouble;
        mapCenter.latitude = latitude;
        mapCenter.longitude = longitude;
        [mapView setCenterCoordinate:mapCenter zoomLevel:14 animated:YES];
    
        for(int i=0;i<[tripData count];i++) {
            CLLocationCoordinate2D coor;
            double iLat = [tripData[i][0] doubleValue];
            double iLon = [tripData[i][1] doubleValue];
            coor.latitude = iLat;
            coor.longitude = iLon;
            DDAnnotation *coorAnnotation;
            coorAnnotation = [[DDAnnotation alloc] initWithCoordinate:coor addressDictionary:nil];
            coorAnnotation.title = [NSString stringWithFormat:@"Location Number %d",i+1];
            coorAnnotation.subtitle = [NSString	stringWithFormat:@"%f | %f", coorAnnotation.coordinate.latitude, coorAnnotation.coordinate.longitude];
            [mapView addAnnotation:coorAnnotation];
        }
    }
}

-(IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)editTripInfo {
    ThirdViewControllerNavTrip *trip = [[ThirdViewControllerNavTrip alloc] initWithNibName:nil bundle:nil];
    trip.tripName = tripName;
    trip.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:trip animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
