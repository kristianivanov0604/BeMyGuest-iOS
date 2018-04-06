//
//  About.m
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 12/3/13.
//  Copyright (c) 2013 Leonardo Bortolotti. All rights reserved.
//

#import "About.h"
#import "Global.h"

@interface About ()

@end

@implementation About

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
    
    navController.navigationBar.topItem.title = @"Config";
    navController.topViewController.navigationItem.rightBarButtonItem = mapButtonItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.view.backgroundColor = corGelo;
    
    textView = [[UITextView alloc] init];
    
    if (deviceType == 1) {
        textView.frame = CGRectMake(10, 10, 300, 396);
    }
    else if (deviceType == 2) {
        textView.frame = CGRectMake(10, 10, 300, 484);
    }
    
    textView.textColor = corPreta;
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont fontWithName:@"Nobile" size:16];
    textView.text = [NSString stringWithFormat:@"O Be My Guest é um aplicativo e website que tem como intuito principal fazer as pessoas se socializarem e curtirem a vida, principalmente durante a noite. O aplicativo busca facilitar ao máximo a vida noturna de seus usuários.\n\n\n- Eventos\n\nDisponibilizamos uma agenda inteligente, onde a qualquer hora e lugar é possível conferir os eventos de baladas e bares que agitam a sua cidade e mandar o nome para suas listas de desconto. Ao enviar o nome e comparecendo ao evento, o usuário é presenteado com pontos que podem ser utilizados para trocas na Loja Virtual.\n\n\n- Locais: Baladas\n\nContamos com a opção de verificar as baladas da sua região, suas descrições e seus próximos eventos.\n\n\n- Locais: Estabelecimentos Parceiros\n\nÉ possível também realizar check-in em diversos estabelecimentos parceiros do Be My Guest, sendo esta a segunda forma de acumular pontos usando o aplicativo. Para a confirmação dos pontos basta informar ao atendente do estabelecimento a realização do check-in pelo Be My Guest.\n\n\n-Pontos e Loja\n\nAtravés dos pontos acumulados é possível efetuar a troca destes por benefícios, descontos e serviços exclusivos em qualquer estabelecimento que seja parceiro da nossa loja virtual.\n\n\n- Mapa\n\nNo mapa o usuário pode visualizar a localização das baladas e dos estabelecimentos parceiros.\n\n\nPara maiores informações acesse o site:\nhttp://bemygue.st"];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
