//
//  TicketOrder.m
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 4/16/14.
//  Copyright (c) 2014 Leonardo Bortolotti. All rights reserved.
//

#import "TicketOrder.h"
#import "Global.h"
#import "CustomCellOrderInfo.h"
#import "TicketOrderCreditCard.h"

@interface TicketOrder ()

@end

@implementation TicketOrder

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
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
    } else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
//    if (deviceType == 1) {
//        screenDifference = 30;
//    }
    
    navController.topViewController.navigationItem.rightBarButtonItem = mapButtonItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UINavigationController *navc  = (UINavigationController *)[navController.viewControllers objectAtIndex:[navController.viewControllers count] - 1];
    navc.navigationItem.title = @"Dados Tickets";
    
    self.view.backgroundColor = corGelo;
    
    ticketsTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - navController.navigationBar.bounds.size.height - 20 + varAxisY)];
    ticketsTypeTableView.dataSource = self;
    ticketsTypeTableView.delegate = self;
    [ticketsTypeTableView setRowHeight:110];
    ticketsTypeTableView.backgroundColor = [UIColor clearColor];
    ticketsTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:ticketsTypeTableView];
    
    arrayWithTicketTypesCount = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[ticketTypesDict allKeys] count]; i++) {
        if (![[[ticketTypesDict allKeys] objectAtIndex:i] isEqualToString:@"total"]) {
            for (int j = 0; j < [[ticketTypesDict valueForKey:[[ticketTypesDict allKeys] objectAtIndex:i]] intValue]; j++) {
                [arrayWithTicketTypesCount addObject:[[ticketTypesDict allKeys] objectAtIndex:i]];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ticketTypesDict valueForKey:@"total"] intValue] + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
	if (indexPath.row < [[ticketTypesDict valueForKey:@"total"] intValue]) {
        CustomCellOrderInfo *cell = (CustomCellOrderInfo*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[CustomCellOrderInfo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.ticketNumber.text = [NSString stringWithFormat:@"Ticket %d: %@", (indexPath.row + 1), [arrayWithTicketTypesCount objectAtIndex:indexPath.row]];
        
        // teste
        //    cell.name.text = @"Leonardo";
        //    cell.rg.text = @"1234";
        
        //    cell.idTicket = [arrayWithTicketTypesCount objectAtIndex:indexPath.row];
        for (int i = 0; i < [[tickettypesJSON valueForKeyPath:@"tickettypes.name"] count]; i++) {
            if ([[[tickettypesJSON valueForKeyPath:@"tickettypes.name"] objectAtIndex:i] isEqualToString:[arrayWithTicketTypesCount objectAtIndex:indexPath.row]]) {
                cell.idTicket = [[tickettypesJSON valueForKeyPath:@"tickettypes._id"] objectAtIndex:i];
            }
        }
        return cell;
    }
    else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = corGelo;
        
        UIButton *continueOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        continueOrderButton.frame = CGRectMake(15, 5, 290, 50);
        continueOrderButton.titleLabel.font = [UIFont fontWithName:@"Nobile" size:23];
        continueOrderButton.layer.cornerRadius = 5;
        continueOrderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [continueOrderButton setTitle:@"Finalizar Compra" forState:UIControlStateNormal];
        [continueOrderButton addTarget:self action:@selector(continueOrder) forControlEvents:UIControlEventTouchUpInside];
        continueOrderButton.backgroundColor = corVerde;
        [cell addSubview:continueOrderButton];
        return cell;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//    footer.backgroundColor = corGelo;
//    
//    UIButton *continueOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    continueOrderButton.frame = CGRectMake(15, 5, 290, 50);
//    continueOrderButton.titleLabel.font = [UIFont fontWithName:@"Nobile" size:23];
//    continueOrderButton.layer.cornerRadius = 5;
//    continueOrderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [continueOrderButton setTitle:@"Finalizar Compra" forState:UIControlStateNormal];
//    [continueOrderButton addTarget:self action:@selector(continueOrder) forControlEvents:UIControlEventTouchUpInside];
//    continueOrderButton.backgroundColor = corVerde;
//    [footer addSubview:continueOrderButton];
//    
//    return footer;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 60.0f;
//}

-(void)continueOrder {
    BOOL isComplete = YES;
    NSString *tempIdTicket;
    
    for (int j = 0; j < [[tickettypesJSON valueForKeyPath:@"tickettypes.name"] count]; j++) {
        tempIdTicket = [[tickettypesJSON valueForKeyPath:@"tickettypes._id"] objectAtIndex:j];
        
        for (int i = 0; i < [[ticketTypesDict objectForKey:@"total"] integerValue]; i++) {
            CustomCellOrderInfo *cell = (id)[ticketsTypeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (tempIdTicket == cell.idTicket) {
                if (cell.name.text.length == 0 || cell.rg.text.length == 0) {
                    isComplete = NO;
                }
            }
        }
    }
    
    if (isComplete) {
        NSMutableDictionary *ticketsInfoDict = [[NSMutableDictionary alloc] init];
        NSMutableArray *ticketsArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < [[tickettypesJSON valueForKeyPath:@"tickettypes.name"] count]; j++) {
            tempIdTicket = [[tickettypesJSON valueForKeyPath:@"tickettypes._id"] objectAtIndex:j];
            NSMutableArray *guestInfosArray = [[NSMutableArray alloc] init];
            NSDictionary *guestInfosDict = [[NSDictionary alloc] init];
            
            NSLog(@"ID: %@", tempIdTicket);
            
            for (int i = 0; i < [[ticketTypesDict objectForKey:@"total"] integerValue]; i++) {
                CustomCellOrderInfo *cell = (id)[ticketsTypeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if (tempIdTicket == cell.idTicket) {
                    guestInfosDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      cell.name.text, @"name",
                                      cell.rg.text, @"rg", nil];
                    [guestInfosArray addObject:guestInfosDict];
                    
                    NSLog(@"CELL ID: %@ --- IDTicket: %@", cell.idTicket, tempIdTicket);
                    [ticketsInfoDict setObject:cell.idTicket forKey:@"_id"];
                }
            }
            //        NSData *json = [NSJSONSerialization dataWithJSONObject:guestInfosArray options:NSJSONWritingPrettyPrinted error:nil];
            //        guestInfosArray = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
            
            [ticketsInfoDict setObject:guestInfosArray forKey:@"guestInfos"];
            [ticketsInfoDict setObject:[NSString stringWithFormat:@"%d", [guestInfosArray count]] forKey:@"quantity"];
            NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:ticketsInfoDict];
            if ([[tempDict valueForKey:@"quantity"] intValue] != 0) {
                [ticketsArray addObject:tempDict];
            }
        }
        //    NSData *json = [NSJSONSerialization dataWithJSONObject:ticketsArray options:NSJSONWritingPrettyPrinted error:nil];
        //    ticketsArray = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
        
        [orderDict setObject:ticketsArray forKey:@"tickets"];
        
        TicketOrderCreditCard *ticketOrderCC = [[TicketOrderCreditCard alloc] init];
        [navController pushViewController:ticketOrderCC animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campos incompletos" message:@"Preencha todos os campos corretamente para continuar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
