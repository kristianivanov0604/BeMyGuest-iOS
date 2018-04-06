//
//  Configurations.h
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 11/1/13.
//  Copyright (c) 2013 Leonardo Bortolotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Configurations : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *array;
    
}

@property (nonatomic, strong) UITableView *configTableView;

@end
