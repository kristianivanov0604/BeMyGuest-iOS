//
//  Purchases.m
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 11/1/13.
//  Copyright (c) 2013 Leonardo Bortolotti. All rights reserved.
//

#import "Purchases.h"
#import "Global.h"
#import "CustomCellPurchases.h"
#import "OffersDescription.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Purchases ()

@end

@implementation Purchases

@synthesize purchasesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"%@", ticketsJSON);
    
    if (ticketsJSON == nil) {
        _bmgAPI = [[BeMyGuestAPI alloc] init];
        [_bmgAPI getTicketsOrdered];
    }
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        
    } else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    
    navController.navigationBar.topItem.title = @"Config";
    navController.topViewController.navigationItem.rightBarButtonItem = mapButtonItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    purchasesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - navController.navigationBar.bounds.size.height - 20 + varAxisY)];
    purchasesTableView.dataSource = self;
    purchasesTableView.delegate = self;
    [purchasesTableView setRowHeight:105];
    purchasesTableView.backgroundColor = [UIColor whiteColor];
    purchasesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:purchasesTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPurchasesTableView) name:@"reloadPurchasesTableView" object:nil];
}

#pragma table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ticketsJSON valueForKeyPath:@"tickets.code"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
	
    CustomCellPurchases *cell = (CustomCellPurchases*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomCellPurchases alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.name.text = [NSString stringWithFormat:@"%@", [[ticketsJSON valueForKeyPath:@"tickets.ticketType.partyId.name"] objectAtIndex:indexPath.row]];
    cell.description.text = [NSString stringWithFormat:@"%@", [[ticketsJSON valueForKeyPath:@"tickets.ticketType.name"] objectAtIndex:indexPath.row]];
    cell.userName.text = [NSString stringWithFormat:@"%@ (%@)", [[ticketsJSON valueForKeyPath:@"tickets.guestInfo.name"] objectAtIndex:indexPath.row], [[ticketsJSON valueForKeyPath:@"tickets.guestInfo.rg"] objectAtIndex:indexPath.row]];
//    cell.preco.text = [NSString stringWithFormat:@"%@ pts", [[purchasesJSON valueForKeyPath:@"paid"] objectAtIndex:indexPath.row]];
    
    if ([[[ticketsJSON valueForKeyPath:@"tickets.used"] objectAtIndex:indexPath.row] boolValue] == NO) {
        cell.used.backgroundColor = corVerde;
    }
    else {
        cell.used.backgroundColor = [UIColor colorWithRed:0.95 green:0.67 blue:0.37 alpha:1.00];
    }
    
//    NSString *partnerId = [NSString stringWithFormat:@"%@", [[purchasesJSON valueForKeyPath:@"offerId.placeId"] objectAtIndex:indexPath.row]];
//    
//    for (int i = 0; i < [[placesJSON valueForKeyPath:@"places.name"] count]; i++) {
//        if ([partnerId isEqualToString:[[placesJSON valueForKeyPath:@"places._id"] objectAtIndex:i]]) {
////            [cell.thumbnail setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[placesJSON valueForKeyPath:@"places.pictures.logo"] objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
//            cell.description.text = [NSString stringWithFormat:@"%@ pts - %@", [[purchasesJSON valueForKeyPath:@"paid"] objectAtIndex:indexPath.row], [[placesJSON valueForKeyPath:@"places.name"] objectAtIndex:i]];
//        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    indexRow = indexPath.row;
    
    NSLog(@"%@", [[ticketsJSON valueForKeyPath:@"tickets._id"] objectAtIndex:indexRow]);
    
    sheet = [[UIActionSheet alloc] initWithTitle:@"O que deseja?"
                                        delegate:self
                               cancelButtonTitle:@"Cancelar"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Abrir com Passbook", @"Trocar titular", nil];
    
    // Show the sheet
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    if (buttonIndex == 0) {
        NSString *linkPassbook = [NSString stringWithFormat:@"https://bemygue.st/tickets/passbook/%@", [[ticketsJSON valueForKeyPath:@"tickets.code"] objectAtIndex:indexRow]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkPassbook]];
    }
    else if (buttonIndex == 1) {
        blackView = [[UIView alloc] init];
        blackView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [blackView setBackgroundColor:corGelo];
//        blackView.alpha = 0.85;
        blackView.alpha = 1;
        [self.view addSubview:blackView];
        
        name = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, 310, 30)];
        rg = [[UITextField alloc] initWithFrame:CGRectMake(5, 75, 310, 30)];
        
        name.placeholder = @"Nome Completo";
        name.borderStyle = UITextBorderStyleRoundedRect;
        name.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [blackView addSubview:name];
        
        rg.placeholder = @"RG";
        rg.borderStyle = UITextBorderStyleRoundedRect;
        rg.keyboardType = UIKeyboardTypeDefault;
        [blackView addSubview:rg];
        
        sendTicketInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        sendTicketInfo.titleLabel.font = [UIFont fontWithName:@"Nobile" size:23];
        sendTicketInfo.layer.cornerRadius = 5;
        sendTicketInfo.titleLabel.textAlignment = NSTextAlignmentCenter;
        [sendTicketInfo addTarget:self action:@selector(sendChangeTicketName) forControlEvents:UIControlEventTouchUpInside];
        sendTicketInfo.frame = CGRectMake(15, 120, 290, 50);
        [sendTicketInfo setTitle:@"Trocar titular" forState:UIControlStateNormal];
        sendTicketInfo.backgroundColor = [UIColor colorWithRed:1 green:0.38 blue:0.48 alpha:1.00];
        [blackView addSubview:sendTicketInfo];
    }
}

-(void)reloadPurchasesTableView {
    [purchasesTableView reloadData];
}

-(void)sendChangeTicketName {
    if (name.text.length > 0 && rg.text.length > 0) {
        _bmgAPI = [[BeMyGuestAPI alloc] init];
        [_bmgAPI putChangeTicketNameWithTicketId:[[ticketsJSON valueForKeyPath:@"tickets._id"] objectAtIndex:indexRow] andName:name.text andRg:rg.text];
        [self.view endEditing:YES];
        [blackView removeFromSuperview];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Campos incompletos" message:@"Preencha todos os campos corretamente para continuar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    blackView = [[UIView alloc] init];
//    blackView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [blackView setBackgroundColor:[UIColor blackColor]];
//    blackView.alpha = 0.85;
//    [self.view addSubview:blackView];
//    nameOffer = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
//    nameOffer.backgroundColor = [UIColor clearColor];
//    nameOffer.text = [NSString stringWithFormat:@"%@", [[purchasesJSON valueForKeyPath:@"offerId.name"] objectAtIndex:indexPath.row]];
//    nameOffer.font = [UIFont fontWithName:@"Nobile" size:20];
//    nameOffer.textAlignment = NSTextAlignmentCenter;
//    nameOffer.textColor = corGelo;
//    nameOffer.adjustsFontSizeToFitWidth = YES;
//    [self.view addSubview:nameOffer];
//    NSString *htmlSource = [NSString stringWithFormat:@"<html><head></head><body text=\"#F2F2F2\" style='background-color:transparent;'><font face='Nobile' size='3'>%@</body></html>",[[purchasesJSON valueForKeyPath:@"offerId.instructions"] objectAtIndex:indexPath.row]];
//    
//    instructions = [[UIWebView alloc] init];
//    bCloseInstructions = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    if (deviceType == 1) {
//        instructions.frame = CGRectMake(15, 65, self.view.frame.size.width - 30, 280);
//        bCloseInstructions.frame = CGRectMake(50, 355, 220, 50);
//    }
//    else if (deviceType == 2) {
//        instructions.frame = CGRectMake(15, 65, self.view.frame.size.width - 30, 345);
//        bCloseInstructions.frame = CGRectMake(50, 420, 220, 50);
//    }
//    
//    instructions.backgroundColor = [UIColor clearColor];
//    instructions.opaque = NO;
//    [instructions loadHTMLString:htmlSource baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
//    bCloseInstructions.titleLabel.font = [UIFont fontWithName:@"Nobile" size:23];
//    [bCloseInstructions setTitle:@"OK" forState:UIControlStateNormal];
//    bCloseInstructions.backgroundColor = [UIColor colorWithRed:1 green:0.38 blue:0.48 alpha:1.00];
//    bCloseInstructions.layer.cornerRadius = 5;
//    bCloseInstructions.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [bCloseInstructions addTarget:self action:@selector(closeInstructions) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:instructions];
//    [self.view addSubview:bCloseInstructions];
//}
//
//-(void)closeInstructions {
//    [blackView removeFromSuperview];
//    [nameOffer removeFromSuperview];
//    [instructions removeFromSuperview];
//    [bCloseInstructions removeFromSuperview];
//}

@end