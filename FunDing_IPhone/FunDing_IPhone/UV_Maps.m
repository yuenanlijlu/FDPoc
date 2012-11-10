//
//  UV_Maps.m
//  FunDing_IPhone
//
//  Created by apple on 12-11-9.
//  Copyright (c) 2012年 apple. All rights reserved.
//

#import "UV_Maps.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface UV_Maps ()

@end

@implementation UV_Maps

@synthesize mapView;

//@synthesize mapView;

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
    
    //MKMapView *mapView=[[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
    //mapView.delegate = self;
    //[self.view addSubview:mapView];
    //[mapView release];
    
    mapView.showsUserLocation=YES;
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器

    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    //locationManager.distanceFilter=1000.0f;//设置距离筛选器
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];//启动位置管理器
  
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=[[locationManager location] coordinate];
    theRegion.span=theSpan;
    [mapView setRegion:theRegion];
    //[locationManager release];
    
}

// get the geographic position
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geocoder.delegate = self;
    [geocoder start];
    
    //[manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Locate position fail!!");
    [manager stopUpdatingLocation];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder
       didFindPlacemark:(MKPlacemark *)placemark
{
    NSLog(@"\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n locality:%@\n subLocality:%@\n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
          placemark.country,
          placemark.postalCode,
          placemark.ISOcountryCode,
          placemark.administrativeArea,
          placemark.subAdministrativeArea,
          placemark.locality,
          placemark.subLocality,
          placemark.thoroughfare,
          placemark.subThoroughfare);
}

-  (void)reverseGeocoder:(MKReverseGeocoder *)geocoder
        didFailWithError:(NSError *)error
{
    NSLog(@"reverse geocoder fail!!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
