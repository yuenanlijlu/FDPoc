//
//  UV_Maps.h
//  FunDing_IPhone
//
//  Created by apple on 12-11-9.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface UV_Maps : UIViewController
<CLLocationManagerDelegate>{
    IBOutlet MKMapView *mapView;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView; 
//@property (strong, nonatomic) MKMapView *mkmap;

@end
