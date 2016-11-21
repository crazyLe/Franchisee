//
//  NSObject+HJGeneral.m
//  小筛子
//
//  Created by zwz on 15/6/27.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import "NSObject+HJGeneral.h"
#import <objc/runtime.h>
@implementation NSObject (HJGeneral)

static BOOL _hasNetwork;
static MyNetworkStatus _status;

-(ProgressHUD *)hudManager {
    return [ProgressHUD sharedInstance];
}

-(void)setHasNetwork:(BOOL)hasNetwork {
    _hasNetwork = hasNetwork;
}

-(BOOL)hasNetwork {
    return _hasNetwork;
}

-(void)setNetworkStatus:(MyNetworkStatus)networkStatus {
    _status = networkStatus;
}

-(MyNetworkStatus)networkStatus {
    return _status;
}

@end
