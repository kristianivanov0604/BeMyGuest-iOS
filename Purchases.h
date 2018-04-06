//
//  Purchases.h
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 11/1/13.
//  Copyright (c) 2013 Leonardo Bortolotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeMyGuestAPI.h"

@interface Purchases : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    
//    UIWebView *instructions;
//    UIButton *bCloseInstructions;
    UIView *blackView;
//    UILabel *offerTitle;
//    UILabel *nameOffer;
    UIActionSheet *sheet;
    int indexRow;
    UITextField *name;
    UITextField *rg;
    UIButton *sendTicketInfo;
    
}

@property (nonatomic, strong) UITableView *purchasesTableView;
@property (nonatomic, strong) BeMyGuestAPI *bmgAPI;

@end
