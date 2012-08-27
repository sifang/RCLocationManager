//
//  BlocksExampleViewController.m
//  RCLocationManager_SampleProject
//
//  Created by Alejandro Martinez on 27/08/12.
//  Copyright (c) 2012 Ricardo Caballero. All rights reserved.
//

#import "BlocksExampleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RCLocationManager.h"

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


@end
