//
//  TicketOrderCreditCard.h
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 4/22/14.
//  Copyright (c) 2014 Leonardo Bortolotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeMyGuestAPI.h"

@interface TicketOrderCreditCard : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    
    UITextField *firstName;
    UITextField *lastName;
    UITextField *cardNumber;
    UITextField *securityCode;
    UITextField *monthExpiration;
    UITextField *yearExpiration;
    UIButton *continueOrderButton;
    UIView *blackView;
    UIActivityIndicatorView *activityView;
    UIView *bg;
    int tagForLayout;
    
}

@property (nonatomic, strong) BeMyGuestAPI *bmgAPI;

@end
