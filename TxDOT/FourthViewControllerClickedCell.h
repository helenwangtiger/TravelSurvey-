//
//  FourthViewControllerClickedCell.h
//  TxDOT
//
//  Created by CYT on 11/26/13.
//  Copyright (c) 2013 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FourthViewControllerClickedCell : UIViewController <MKMapViewDelegate> {
    IBOutlet UINavigationBar *topBar;
    NSString *tripName;
    IBOutlet MKMapView *mapView;
}

@property(nonatomic,retain) IBOutlet UINavigationBar *topBar;
@property(nonatomic,retain) NSString *tripName;
@property(nonatomic,retain) IBOutlet MKMapView *mapView;

-(IBAction)close;

@end
