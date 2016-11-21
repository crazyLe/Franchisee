//
//  GroundMapController.h
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/8/15.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KZCityModel.h"

@protocol GroundMapControllerDelegate <NSObject>

@optional
- (void)getCityModel:(KZCityModel *)city andWeizhi:(CLLocationCoordinate2D)loc;

@end

@interface GroundMapController : UIViewController
@property(weak,nonatomic)id<GroundMapControllerDelegate> delegate;
@end
