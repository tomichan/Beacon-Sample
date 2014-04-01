//
//  ViewController.m
//  Beecon
//
//  Created by 富居 聡 on 2014/03/29.
//  Copyright (c) 2014年 富居 聡. All rights reserved.
//

#import "ViewController.h"
#import "CouponViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self initBeacon];
        [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBeacon {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"00000000-89DE-1001-B000-001C4D078A14"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"bT1q8mZN"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [self sendLocalNotificationForMessage:@"Start Monitoring Region"];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self sendLocalNotificationForMessage:@"Enter Region"];
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self sendLocalNotificationForMessage:@"Exit Region"];
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    NSString *rangeMessage;
    switch (beacon.proximity) {
        case CLProximityImmediate:
            rangeMessage = @"Range Immediate: ";
            break;
        case CLProximityNear:
            rangeMessage = @"Range Near: ";
            break;
        case CLProximityFar:
            rangeMessage = @"Range Far: ";
            break;
        default:
            rangeMessage = @"Range Unknown: ";
            break;
    }
    
    if (beacon.proximity == CLProximityImmediate) {
        CouponViewController* nextViewController = [[CouponViewController alloc] init];
        if(nextViewController) {
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
    }
    
    NSString *message = [NSString stringWithFormat:@"major:%@, minor:%@, accuracy:%f, rssi:%d",
                         beacon.major, beacon.minor, beacon.accuracy, beacon.rssi];
    [self sendLocalNotificationForMessage:[rangeMessage stringByAppendingString:message]];
    NSLog(@"%@", message);
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    [self sendLocalNotificationForMessage:@"Exit Region"];
}


- (void)sendLocalNotificationForMessage:(NSString *)message
{
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.alertBody = message;
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
