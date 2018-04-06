//
//  Checkin.m
//  BeMyGuest
//
//  Created by Leonardo Bortolotti on 2/25/14.
//  Copyright (c) 2014 Leonardo Bortolotti. All rights reserved.
//

#import "Checkin.h"
#import "CustomCellPlaces.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface Checkin ()

@end

@implementation Checkin

@synthesize checkinTableView;

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
    
    if (placesJSON == nil) {
        _bmgAPI = [[BeMyGuestAPI alloc] init];
        [_bmgAPI getPlaces];
    }
    
    navController.navigationBar.topItem.title = @"Check-in";
    navController.topViewController.navigationItem.leftBarButtonItem = listButtonItem;
    navController.topViewController.navigationItem.rightBarButtonItem = mapButtonItem;
    
    self.view.backgroundColor = corPreta;
    
    arrayWithCanCheckin = [[NSMutableArray alloc] init];
    arrayWithSortDistance = [[NSMutableArray alloc] init];
    linksImagesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [[placesJSON valueForKeyPath:@"places.name"] count]; i++) {
        if ([[placesJSON valueForKeyPath:@"places.canCheckin"] objectAtIndex:i] != [NSNull null]) {
            if ([[[placesJSON valueForKeyPath:@"places.canCheckin"] objectAtIndex:i] intValue] == 1) {
                [arrayWithCanCheckin addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    
    NSLog(@"CanCheckin: %@", arrayWithCanCheckin);
    
    for (int i = 0; i < [arrayWithCanCheckin count]; i++) {
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[placesJSON valueForKeyPath:@"places.location.lat"] objectAtIndex:[[arrayWithCanCheckin objectAtIndex:i] intValue]] doubleValue] longitude:[[[placesJSON valueForKeyPath:@"places.location.lng"] objectAtIndex:[[arrayWithCanCheckin objectAtIndex:i] intValue]] doubleValue]];
        
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
        
        CLLocationDistance distanceA = [locA distanceFromLocation:locB];
        
        if ([arrayWithSortDistance count] == 0) {
            [arrayWithSortDistance addObject:[NSNumber numberWithInt:[[arrayWithCanCheckin objectAtIndex:i] intValue]]];
        }
        else {
            int j = 0;
            CLLocation *locC = [[CLLocation alloc] initWithLatitude:[[[placesJSON valueForKeyPath:@"places.location.lat"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:j] intValue]] doubleValue] longitude:[[[placesJSON valueForKeyPath:@"places.location.lng"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:j] intValue]] doubleValue]];
            
            CLLocationDistance distanceB = [locC distanceFromLocation:locB];
            
            while (distanceA > distanceB) {
                j++;
                NSLog(@"SortDist: %@", arrayWithSortDistance);
                if (j <= [arrayWithSortDistance count] - 1) {
                    CLLocation *locD = [[CLLocation alloc] initWithLatitude:[[[placesJSON valueForKeyPath:@"places.location.lat"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:j] intValue]] doubleValue] longitude:[[[placesJSON valueForKeyPath:@"places.location.lng"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:j] intValue]] doubleValue]];
                    distanceB = [locD distanceFromLocation:locB];
                }
                else {
                    distanceB = distanceA;
                }
            }
            [arrayWithSortDistance insertObject:[arrayWithCanCheckin objectAtIndex:i] atIndex:j];
        }
    }
    NSLog(@"SortDist: %@", arrayWithSortDistance);
    
    if ([arrayWithSortDistance count] > 0) {
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logobranco.png"]];
        logo.frame = CGRectMake(32, -25, 256, 200);
        [self.view addSubview:logo];
    }
    
    NSLog(@"placesJSON: %d", [[placesJSON valueForKeyPath:@"places.name"] count]);
    NSLog(@"arraywithcan: %d", [arrayWithCanCheckin count]);
    NSLog(@"arraywithsort: %d", [arrayWithSortDistance count]);
    
    for (int i = 0; i < [arrayWithSortDistance count]; i++) {
        NSString *link = [NSString alloc];
        NSArray *array = [[placesJSON valueForKeyPath:@"places.pictures.photos"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:i] intValue]];
        if (array.count > 0 && [[array objectAtIndex:0] length] > 0) {
            NSInteger randomNumber = arc4random() % [array count];
            link = [NSString stringWithFormat:@"%@", [array objectAtIndex:randomNumber]];
            link = [link stringByReplacingOccurrencesOfString:@"/upload/" withString:@"/upload/w_320,h_197,c_fill/"];
            NSLog(@"LINK: %@", [NSString stringWithFormat:@"%@", link]);
        }
        [linksImagesArray addObject:link];
    }
    
    checkinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - navController.navigationBar.bounds.size.height - 20 + varAxisY)];
    checkinTableView.dataSource = self;
    checkinTableView.delegate = self;
    [checkinTableView setRowHeight:197];
    checkinTableView.backgroundColor = [UIColor clearColor];
    checkinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:checkinTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopIndicatorPlaces) name:@"stopIndicatorPlaces" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingIndicatorPlaces) name:@"loadingIndicatorPlaces" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // Reload your data here, and this gets called
    // before the view transition is complete.
    
    [checkinTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayWithSortDistance count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
	
    CustomCellPlaces *cell = (CustomCellPlaces*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomCellPlaces alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
//    if ([[[placesJSON valueForKeyPath:@"places.canCheckin"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:indexPath.row] intValue]] intValue] == 1) {
//        //            cell.points.text = @"+8 pts";
//        cell.points.text = [NSString stringWithFormat:@"+%@ pts", [[placesJSON valueForKeyPath:@"places.checkinReward"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:indexPath.row] intValue]]];
//        cell.points.layer.cornerRadius = 5;
//        cell.points.layer.masksToBounds = YES;
//        cell.points.backgroundColor = corVerde;
//    }
//    else {
//        cell.points.text = @"";
//        cell.points.backgroundColor = [UIColor clearColor];
//    }
    
    cell.points.text = [NSString stringWithFormat:@"+%@ pts", [[placesJSON valueForKeyPath:@"places.checkinReward"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:indexPath.row] intValue]]];
    cell.points.layer.cornerRadius = 5;
    cell.points.layer.masksToBounds = YES;
    cell.points.backgroundColor = corVerde;
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[placesJSON valueForKeyPath:@"places.location.lat"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:indexPath.row] intValue]] doubleValue] longitude:[[[placesJSON valueForKeyPath:@"places.location.lng"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:indexPath.row] intValue]] doubleValue]];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    dispatch_queue_t queue = dispatch_get_global_queue
    (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,  ^{
        [cell.cellImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [linksImagesArray objectAtIndex:indexPath.row]]] placeholderImage:nil];
        NSLog(@"Carregando imagem");
    });
    
    cell.name.text = [NSString stringWithFormat:@"%@", [[placesJSON valueForKeyPath:@"places.name"] objectAtIndex:[[arrayWithSortDistance objectAtIndex:indexPath.row] intValue]]];
//    if (distance < 1000) {
//        cell.description.text = [NSString stringWithFormat:@"%.0f m", distance];
//    }
//    else {
    cell.description.text = [NSString stringWithFormat:@"%.1f Km", distance/1000];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    clickedRow = [[arrayWithSortDistance objectAtIndex:indexPath.row] intValue];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-in" message:[NSString stringWithFormat:@"Você deseja fazer check-in no(a) %@?", [[placesJSON valueForKeyPath:@"places.name"] objectAtIndex:clickedRow]] delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim", nil];
    [alert show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self doCheckin];
    }
}

-(void)doCheckin {
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[placesJSON valueForKeyPath:@"places.location.lat"] objectAtIndex:clickedRow] doubleValue] longitude:[[[placesJSON valueForKeyPath:@"places.location.lng"] objectAtIndex:clickedRow] doubleValue]];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    NSLog(@"Distance for checkin: %f meters", distance);
    
    if (distance <= 400) {
        [self loadingIndicatorPlaces];
        BeMyGuestAPI *bmgAPI = [[BeMyGuestAPI alloc] init];
        NSString *placeId = [[placesJSON valueForKeyPath:@"places._id"] objectAtIndex:clickedRow];
        NSLog(@"PLACEID: %@", placeId);
        [bmgAPI postCheckinWithPlaceId:placeId andIndex:clickedRow];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:[NSString stringWithFormat:@"Você precisa estar no(a) %@ para fazer o check-in", [[placesJSON valueForKeyPath:@"places.name"] objectAtIndex:clickedRow]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)loadingIndicatorPlaces {
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    blackView.alpha = 0.5;
    [self.view addSubview:blackView];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(self.view.center.x, (self.view.window.frame.size.height - 20 - 44)/2);
    [activityView startAnimating];
    [self.view addSubview:activityView];
    [CATransaction commit];
}

-(void)stopIndicatorPlaces {
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    [blackView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
