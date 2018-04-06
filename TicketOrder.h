//
//  TicketOrder.h
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 4/16/14.
//  Copyright (c) 2014 Leonardo Bortolotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketOrder : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UILabel *numTickets;
    UILabel *subPriceTickets;
    UILabel *totalPriceTickets;
    NSMutableArray *arrayWithTicketTypesCount;
    
}

@end
