//
//  Configurations.m
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 11/1/13.
//  Copyright (c) 2013 Leonardo Bortolotti. All rights reserved.
//

#import "Configurations.h"
#import "Global.h"
#import "CustomCellConfigurations.h"
#import "Purchases.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "About.h"
#import "Copyright.h"

@interface Configurations ()

@end

@implementation Configurations

@synthesize configTableView;

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
    
    navController.navigationBar.topItem.title = @"Configurações";
    navController.topViewController.navigationItem.leftBarButtonItem = listButtonItem;
    navController.topViewController.navigationItem.rightBarButtonItem = mapButtonItem;
    
//    array = [[NSArray alloc] initWithObjects:@"Editar perfil", @"Minhas compras", @"Sobre", @"Copyright", @"Sair", nil];
    array = [[NSArray alloc] initWithObjects:@"Meus Tickets", @"Sobre", @"Copyright", @"Sair", nil];
    
    UIView *secondBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    secondBgView.backgroundColor = corPreta;
    [self.view addSubview:secondBgView];
    
    UILabel *lNome = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    lNome.backgroundColor = [UIColor clearColor];
    lNome.text = [NSString stringWithFormat:@"%@", [userJSON valueForKeyPath:@"user.profile.name"]];
    lNome.font = [UIFont fontWithName:@"Nobile" size:20];
    lNome.textAlignment = NSTextAlignmentCenter;
    lNome.textColor = corGelo;
    lNome.adjustsFontSizeToFitWidth = YES;
    [secondBgView addSubview:lNome];
    
    configTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + secondBgView.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - navController.navigationBar.bounds.size.height - 20 - 40)];
    configTableView.dataSource = self;
    configTableView.delegate = self;
    [configTableView setRowHeight:80];
    configTableView.backgroundColor = [UIColor whiteColor];
    configTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:configTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // Reload your data here, and this gets called
    // before the view transition is complete.
    
    navController.navigationBar.topItem.title = @"Configurações";
}

#pragma table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
	
    CustomCellConfigurations *cell = (CustomCellConfigurations*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomCellConfigurations alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.name.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        FBSDKLoginManager *logMeOut = [[FBSDKLoginManager alloc] init];
        [logMeOut logOut];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"0"] forKey:@"accesstoken"];
        [defaults synchronize];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else if (indexPath.row == 0) {
        Purchases *purchases = [[Purchases alloc] init];
        [navController pushViewController:purchases animated:YES];
    }
    else if (indexPath.row == 1) {
        About *about = [[About alloc] init];
        [navController pushViewController:about animated:YES];
    }
    else if (indexPath.row == 2) {
        Copyright *copyright = [[Copyright alloc] init];
        [navController pushViewController:copyright animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
