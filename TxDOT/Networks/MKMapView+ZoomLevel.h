//
//  MKMapView+ZoomLevel.h
//  MapKitDragAndDrop
//
//  Created by CYT on 6/5/13.
//
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end