//
//  Checkin.h
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 2/25/14.
//  Copyright (c) 2014 Leonardo Bortolotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeMyGuestAPI.h"

@interface Checkin : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    
    NSMutableArray *arrayWithCanCheckin;
    NSMutableArray *arrayWithSortDistance;
    UIView *blackView;
    UIActivityIndicatorView *activityView;
    NSMutableArray *linksImagesArray;
    
}

@property (nonatomic, strong) UITableView *checkinTableView;
@property (nonatomic, strong) BeMyGuestAPI *bmgAPI;

@end
