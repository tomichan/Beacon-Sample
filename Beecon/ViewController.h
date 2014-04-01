//
//  ViewController.h
//  Beecon
//
//  Created by 富居 聡 on 2014/03/29.
//  Copyright (c) 2014年 富居 聡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CouponViewController.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;

@end
