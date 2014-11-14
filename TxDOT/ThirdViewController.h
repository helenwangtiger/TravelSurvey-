//
//  ThirdViewController.h
//  TxDOT
//
//  Created by Qian on 6/14/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ThirdViewControllerTrip.h"

@interface ThirdViewController : UIViewController <MKMapViewDelegate,SecondDelegate> {
    IBOutlet MKMapView *mapView;
    NSString *tripName;
}

@property (nonatomic,retain) IBOutlet MKMapView *mapView;
@property (nonatomic,retain) NSString *tripName;

- (IBAction)startButton:(id)sender;

@end