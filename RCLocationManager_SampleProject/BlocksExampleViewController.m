//
//  BlocksExampleViewController.m
//  RCLocationManager_SampleProject
//
//  Created by Alejandro Martinez on 27/08/12.
//  Copyright (c) 2012 Ricardo Caballero. All rights reserved.
//

#import "BlocksExampleViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BlocksExampleViewController ()

@end

@implementation BlocksExampleViewController

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
    
    self.infoBox.layer.cornerRadius = 6;
    
    // Create location manager with filters set for battery efficiency.
    RCLocationManager *locationManager = [RCLocationManager sharedManager];
    [locationManager setPurpose:@"My custom purpose message"];
    // UserDistanceFilter:kCLLocationAccuracyHundredMeters
    // userDesiredAccuracy:kCLLocationAccuracyBest purpose
    
    // Start updating location changes.
    [locationManager startUpdatingLocationWithBlock:^(CLLocation *newLocation, CLLocation *oldLocation, NSError *error) {
        if (!error) {
            
            MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 10000.0, 10000.0);
            [self.mapView setRegion:userLocation animated:YES];
            
            NSLog(@"Updated location using block.");
        }
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[RCLocationManager sharedManager] stopMonitoringAllRegions];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setInfoBox:nil];
    
    [[RCLocationManager sharedManager] stopUpdatingLocation];
    [[RCLocationManager sharedManager] stopMonitoringAllRegions];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)addRegion:(id)sender
{
    if ([RCLocationManager regionMonitoringAvailable]) {
		// Create a new region based on the center of the map view.
		CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
		CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
																	  radius:1000.0
																  identifier:[NSString stringWithFormat:@"%f, %f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude]];
		
		// Create an annotation to show where the region is located on the map.
		RegionAnnotation *myRegionAnnotation = [[RegionAnnotation alloc] initWithCLRegion:newRegion];
		myRegionAnnotation.coordinate = newRegion.center;
		myRegionAnnotation.radius = newRegion.radius;
		
		[self.mapView addAnnotation:myRegionAnnotation];
		
		
		// Start monitoring the newly created region.
        [[RCLocationManager sharedManager] addRegionForMonitoring:newRegion desiredAccuracy:kCLLocationAccuracyBest withBlock:^(CLRegion *region, BOOL enter, NSError *error) {

            if (error) {
                NSLog(@"Region ERROR using block");
            } else if (enter) {
                NSLog(@"Region ENTER using block");
            } else {
                NSLog(@"Region EXIT using block");
            }
            
        }];
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}
}


@end
