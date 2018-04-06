//
//  TicketOrderCreditCard.m
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 4/22/14.
//  Copyright (c) 2014 Leonardo Bortolotti. All rights reserved.
//

#import "TicketOrderCreditCard.h"
#import "Global.h"

@interface TicketOrderCreditCard ()

@end

@implementation TicketOrderCreditCard

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
    navc.navigationItem.title = @"Cartão de Crédito";
    
    self.view.backgroundColor = corGelo;
    
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    bg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bg];
    
    UILabel *lFirstName = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 310, 30)];
    firstName = [[UITextField alloc] initWithFrame:CGRectMake(5, 40, 310, 30)];
    UILabel *lLastName = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 310, 30)];
    lastName = [[UITextField alloc] initWithFrame:CGRectMake(5, 110, 310, 30)];
    UILabel *lCardNumber = [[UILabel alloc] initWithFrame:CGRectMake(5, 150, 310, 30)];
    cardNumber = [[UITextField alloc] initWithFrame:CGRectMake(5, 180, 310, 30)];
    UILabel *lSecurityCode = [[UILabel alloc] initWithFrame:CGRectMake(5, 220, 310, 30)];
    securityCode = [[UITextField alloc] initWithFrame:CGRectMake(5, 250, 310, 30)];
    UILabel *lExpirationDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 290, 310, 30)];
    monthExpiration = [[UITextField alloc] initWithFrame:CGRectMake(5, 320, 145, 30)];
    yearExpiration = [[UITextField alloc] initWithFrame:CGRectMake(155, 320, 145, 30)];
    
    continueOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (deviceType == 1) {
        continueOrderButton.frame = CGRectMake(15, 360, 290, 50);
    }
    else {
        continueOrderButton.frame = CGRectMake(15, 440, 290, 50);
    }
    
    lFirstName.text = @"Nome";
    lFirstName.backgroundColor = [UIColor clearColor];
    lFirstName.textColor = corPreta;
    lFirstName.font = [UIFont fontWithName:@"Nobile" size:16];
    [bg addSubview:lFirstName];
    
    firstName.borderStyle = UITextBorderStyleRoundedRect;
    firstName.delegate = self;
    firstName.tag = 0;
    firstName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [bg addSubview:firstName];
    
    lLastName.text = @"Sobrenome";
    lLastName.backgroundColor = [UIColor clearColor];
    lLastName.textColor = corPreta;
    lLastName.font = [UIFont fontWithName:@"Nobile" size:16];
    [bg addSubview:lLastName];
    
    lastName.borderStyle = UITextBorderStyleRoundedRect;
    lastName.delegate = self;
    lastName.tag = 1;
    lastName.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [bg addSubview:lastName];
    
    lCardNumber.text = @"Número do cartão";
    lCardNumber.backgroundColor = [UIColor clearColor];
    lCardNumber.textColor = corPreta;
    lCardNumber.font = [UIFont fontWithName:@"Nobile" size:16];
    [bg addSubview:lCardNumber];
    
    cardNumber.borderStyle = UITextBorderStyleRoundedRect;
    cardNumber.delegate = self;
    cardNumber.tag = 2;
    cardNumber.keyboardType = UIKeyboardTypeNumberPad;
    [bg addSubview:cardNumber];
    
    lSecurityCode.text = @"Código de segurança";
    lSecurityCode.backgroundColor = [UIColor clearColor];
    lSecurityCode.textColor = corPreta;
    lSecurityCode.font = [UIFont fontWithName:@"Nobile" size:16];
    [bg addSubview:lSecurityCode];
    
    securityCode.placeholder = @"ex. 311";
    securityCode.borderStyle = UITextBorderStyleRoundedRect;
    securityCode.delegate = self;
    securityCode.tag = 3;
    securityCode.keyboardType = UIKeyboardTypeNumberPad;
    [bg addSubview:securityCode];
    
    lExpirationDate.text = @"Expiração";
    lExpirationDate.backgroundColor = [UIColor clearColor];
    lExpirationDate.textColor = corPreta;
    lExpirationDate.font = [UIFont fontWithName:@"Nobile" size:16];
    [bg addSubview:lExpirationDate];
    
    monthExpiration.placeholder = @"MM";
    monthExpiration.borderStyle = UITextBorderStyleRoundedRect;
    monthExpiration.delegate = self;
    monthExpiration.tag = 4;
    monthExpiration.keyboardType = UIKeyboardTypeNumberPad;
    [bg addSubview:monthExpiration];
    
    yearExpiration.placeholder = @"YYYY";
    yearExpiration.borderStyle = UITextBorderStyleRoundedRect;
    yearExpiration.delegate = self;
    yearExpiration.tag = 4;
    yearExpiration.keyboardType = UIKeyboardTypeNumberPad;
    [bg addSubview:yearExpiration];
    
    // teste
//    firstName.text = @"Leonardo";
//    lastName.text = @"Bortolotti";
////    cardNumber.text = @"4012888888881881";
//    cardNumber.text = @"4111111111111111";
//    securityCode.text = @"311";
//    monthExpiration.text = @"10";
//    yearExpiration.text = @"2014";
    
    continueOrderButton.titleLabel.font = [UIFont fontWithName:@"Nobile" size:23];
    continueOrderButton.layer.cornerRadius = 5;
    continueOrderButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [continueOrderButton setTitle:@"Confirmar Compra" forState:UIControlStateNormal];
    [continueOrderButton addTarget:self action:@selector(finalizeOrder) forControlEvents:UIControlEventTouchUpInside];
    continueOrderButton.backgroundColor = corVerde;
    [bg addSubview:continueOrderButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndicatorTicketOrder) name:@"stopIndicatorTicketOrder" object:nil];
}

-(void)finalizeOrder {
    if (firstName.text.length > 0 && lastName.text.length > 0 && cardNumber.text.length > 0 && securityCode.text.length > 0 && monthExpiration.text.length == 2 && yearExpiration.text.length == 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmação" message:[NSString stringWithFormat:@"Confirmar compra?\nValor total: R$%.2f", (ticketsPrice * 1.1)] delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Preencha todos os campos corretamente para continuar." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button index: %d", buttonIndex);
    if (buttonIndex == 1) {
        [self loadingIndicatorTicketOrder];
        
        NSDictionary *paymentData = [NSDictionary dictionaryWithObjectsAndKeys:
                           cardNumber.text, @"number",
                           securityCode.text, @"verification_value",
                           firstName.text, @"first_name",
                           lastName.text, @"last_name",
                           monthExpiration.text, @"month",
                           yearExpiration.text, @"year", nil];
        [orderDict setObject:[ticketTypesDict valueForKey:@"total"] forKey:@"ticketCount"];
        [orderDict setObject:[NSString stringWithFormat:@"%.0f", ticketsPrice] forKey:@"total"];
        [orderDict setObject:paymentData forKey:@"payment_data"];
        [orderDict setObject:[[allEvents valueForKeyPath:@"allEvents._id"] objectAtIndex:clickedRow] forKey:@"partyId"];
        NSLog(@"%@", orderDict);
        
        // teste
//        NSDictionary *finalOrderDict = [NSDictionary dictionaryWithObjectsAndKeys:
//                                        orderDict, @"order",
//                                        @"true", @"test", nil];
        NSDictionary *finalOrderDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                        orderDict, @"order", nil];
        
        NSLog(@"%@", finalOrderDict);
        
        _bmgAPI = [[BeMyGuestAPI alloc] init];
        [_bmgAPI postOrderWithDict:finalOrderDict];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self layoutNormal];
    tagForLayout = textField.tag;
    CGRect frame = bg.frame;
    frame.origin.y -= 60 * textField.tag;
    bg.frame = frame;
}

-(void)layoutNormal {
    CGRect frame = bg.frame;
    frame.origin.y += 60 * tagForLayout;
    bg.frame = frame;
    tagForLayout = 0;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self layoutNormal];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self layoutNormal];
}

-(void)loadingIndicatorTicketOrder {
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    blackView.alpha = 0.5;
    [bg addSubview:blackView];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(self.view.center.x, (self.view.window.frame.size.height - 20 - 44)/2);
    [activityView startAnimating];
    [bg addSubview:activityView];
    [CATransaction commit];
}

-(void)stopIndicatorTicketOrder {
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    [blackView removeFromSuperview];
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
