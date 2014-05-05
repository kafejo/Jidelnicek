//
//  ViewController.m
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "ViewController.h"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define SYSTEM_7_0() [[UIDevice currentDevice] systemVersion]
#define UIColorFromHEX(HEXValue) [UIColor \
colorWithRed:((float)((HEXValue & 0xFF0000) >> 16))/255.0 \
green:((float)((HEXValue & 0xFF00) >> 8))/255.0 \
blue:((float)(HEXValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()

@property UIRefreshControl *refresh;
@property BOOL initialized;

@end

@implementation ViewController

-(void) viewDidAppear:(BOOL)animated {
    // aktualizuji si data po prechodu - jako kdybych stisknoul tlacitko na aktualizaci
     //[self reload];
    //[self performSelectorInBackground:@selector(setMoneyToBar) withObject:nil];
    if (!self.initialized) {
        [self.activityIndicator startAnimating];
        [self refreshData];
        self.initialized = YES;
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.activityIndicator.frame = CGRectMake(0, 0, 100, 100);
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) - 44);
    self.activityIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.activityIndicator.layer.cornerRadius = 10.0f;
    [self.view addSubview:self.activityIndicator];
    self.screenName = @"Main screen";
    
    if(self.pickerView == NULL){
        #if DEBUG
        NSLog(@"Null picker");
        #endif
    }
    
    UIColor *greenColor = [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
   
    if (IDIOM != IPAD) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, self.pickerView.frame.size.height)];
        self.table.tableFooterView = view;
    }
    self.navigationController.navigationItem.leftBarButtonItem.tintColor= [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(refreshXML:) forControlEvents:UIControlEventValueChanged];
    
    [self.table addSubview:self.refresh];
    
    self.pickerView.pickerDelegate = self;
    self.pickerView.backgroundColor = greenColor;
    // vytvorim si hlasku kdyz nemam data
    [self createNoDataWarn];
    
    self.initialized = NO;
    
    
}

- (void)dealloc {
    
}

- (void)refreshData {
    
    [self refreshXML:self.refresh];
}

- (void)refreshXML:(UIRefreshControl *)refreshControl {
    [self loadData:refreshControl];
    [[MenuManager sharedManager] accountBalanceWithLoginSuccess:^(NSString *amount) {
        NSLog(@"Mam penize %@", amount);
        self.navigationItem.leftBarButtonItem.title = amount;
        [refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    } failure:^(NSError *error) {
        NSLog(@"Mam hovno %@", error.localizedDescription);
        [refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)loadData:(UIRefreshControl *)refreshControl {
    MenuManager *manager = [MenuManager sharedManager];
    
    [manager loadMenuFromURL:[NSURL URLWithString:XML_URL] success:^{
        
        //NSLog(@"Stazeno %lu", (unsigned long)[manager.days count]);
        //[self.refresh endRefreshing];
        [self.table reloadData];
        [self.pickerView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"Nastala chyba %@", error.localizedDescription);
        //[self.refresh endRefreshing];
    }];
    
}

-(IBAction)showInfo:(id)sender{
    NSString *info = [NSString stringWithFormat:@"Application made by webCentre.cz\n\nVersion: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About" message:info delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    [alert show];
}


-(void) createNoDataWarn{
    // vytvoreni upozorneni pro nedostupna data pro urcity den
    self.noDataWarn = [[UILabel alloc] initWithFrame:CGRectMake(self.table.contentSize.width,
                                                                self.table.contentSize.height, 320, 20)];
    self.noDataWarn.font = [UIFont fontWithName:@"Arial" size:25.0];
    self.noDataWarn.text = @"Žádné data pro tento den";
    self.noDataWarn.textColor = [UIColor grayColor];
    self.noDataWarn.textAlignment = NSTextAlignmentCenter;
    self.noDataWarn.hidden = true;
    self.table.backgroundView = self.noDataWarn;
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"rate"]){
        RateViewController* rateView = segue.destinationViewController;
        NSIndexPath *indexPath = [_table indexPathForCell:sender];
        MenuManager *manager = [MenuManager sharedManager];
        switch (indexPath.section) {
            case 0:
                rateView.ratingData = [[[[manager.selectedDay foods]objectAtIndex:indexPath.row ] score]floatValue];
                rateView.foodLabelData = [[[manager.selectedDay foods] objectAtIndex:indexPath.row] name];
                rateView.foodId = [[[manager.selectedDay foods] objectAtIndex:indexPath.row] foodId];
                break;
            case 1:
                rateView.ratingData = [[[[manager.selectedDay shortOrder]objectAtIndex:indexPath.row ] score]floatValue];
                rateView.foodLabelData = [[[manager.selectedDay shortOrder] objectAtIndex:indexPath.row] name];
                rateView.foodId = [[[manager.selectedDay shortOrder] objectAtIndex:indexPath.row] foodId];
                break;
            case 2:
                rateView.ratingData = [[[[manager.selectedDay otherFood]objectAtIndex:indexPath.row ] score]floatValue];
                rateView.foodLabelData = [[[manager.selectedDay otherFood] objectAtIndex:indexPath.row] name];
                rateView.foodId = [[[manager.selectedDay otherFood] objectAtIndex:indexPath.row] foodId];
                break;
                
            default:
                break;
        }
        
    }
}

#pragma mark - Table view data source
// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Denní menu";
            break;
        case 1:
            return @"Minutky";
            break;
        case 2:
            return @"Ostatní jídla";
            
        default:
            break;
    }
    return @"";
}

-( UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver <= 6.1) {
        
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 22)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.table.frame.size.width-10, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12.0];
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1.0f];

    switch (section) {
        case 0:
            label.text = @"Denní menu";
            break;
        case 1:
            label.text = @"Minutky";
            break;
        case 2:
            label.text = @"Ostatní jídla";
            
        default:
            break;
    }
    
    return view;
    } else {
        [self tableView:tableView titleForHeaderInSection:section];
        
        return NULL;
    }
}


// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MenuManager *manager = [MenuManager sharedManager];
    
    switch (section) {
        case 0:
            return [[manager.selectedDay foods] count];
            break;
        case 1:
            return [[manager.selectedDay shortOrder] count];
            break;
        case 2:
            return [[manager.selectedDay otherFood] count];
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    float t_score = 0.0;
    float price = 0.0;
    MenuManager *manager = [MenuManager sharedManager];
    
    switch (indexPath.section) {
        case 0:
            cell.name.text = [[[manager.selectedDay foods]objectAtIndex:indexPath.item ] name];
            t_score = [[[[manager.selectedDay foods]objectAtIndex:indexPath.row ] score] floatValue];
            price = [[[[manager.selectedDay foods] objectAtIndex:indexPath.row] price] floatValue];
            break;
        case 1:
            cell.name.text = [[[manager.selectedDay shortOrder]objectAtIndex:(indexPath.item) ] name];
            t_score = [[[[manager.selectedDay shortOrder]objectAtIndex:indexPath.row ] score] floatValue];
            price = [[[[manager.selectedDay shortOrder] objectAtIndex:indexPath.row] price] floatValue];
            break;
        case 2:
            cell.name.text = [[[manager.selectedDay otherFood]objectAtIndex:indexPath.item ] name];
            t_score = [[[[manager.selectedDay otherFood]objectAtIndex:indexPath.row ] score] floatValue];
            price = [[[[manager.selectedDay otherFood] objectAtIndex:indexPath.row] price] floatValue];
            break;
            
        default:
            break;
    }
    
    if (price == 0.0) {
        cell.price.text = @"-";
    } else {
        cell.price.text = [NSString stringWithFormat:@"%0.2f Kč", price];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"money"] != nil) {
        
        float money = [[[NSUserDefaults standardUserDefaults] objectForKey:@"money"] floatValue];
        //NSLog(@"Cena: %0.2f – %0.2f", price, money);
        if (money < price) {
            cell.price.textColor = UIColorFromHEX(0xcf0606);
        }else{
            cell.price.textColor = [UIColor blackColor];
        }
    }
    
    
    NSInteger score = (NSInteger)lroundf(t_score);
    
    //cell.testRate.text = [NSString stringWithFormat:@"%d\n%0.2f", score, t_score];
    if (score > 5 || score < 0) {
        score = 0;
    }
    NSString *image = [NSString stringWithFormat:@"rate_bar%ld", (long)score];
    cell.score.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:image]];
    
    //cell.score.text = [NSString stringWithFormat:@"%0.0f / 5", t_score];
    //cell.score.textColor = [UIColor colorWithRed:39.0f/255.0f green:104.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
    
    return cell;
}

#pragma mark - CCPicker data source and delegate method

-(NSInteger)numberOfRowForPicker:(CCPicker *)picker{
     // NSLog(@"UPDATUJU PICKER");
    return [[MenuManager sharedManager].days count];
}

-(void)CCPicker:(CCPicker *)picker didChangePage:(NSInteger)page{
    MenuManager *manager = [MenuManager sharedManager];
    if ([manager.days count]> 0) {
        manager.selectedDay = manager.days[page];
        //[self ShowOrHideNoDataWarn];
        [_table reloadData];
    }

}

-(UILabel*)CCPicker:(CCPicker *)picker labelForRow:(NSInteger)row{
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:182.0f/255.0f green:213.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
    tempLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    tempLabel.backgroundColor = [UIColor clearColor];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (IDIOM == IPAD) {
        [formatter setDateFormat:@"EEEE - dd.MM."];
    } else {
        [formatter setDateFormat:@"EE - dd.MM."];
    }
    
    MenuManager *manager = [MenuManager sharedManager];
    
    if ([manager.days count] > 0) {
        
        NSDate *date = [manager.days[row] date];
        NSString *str = [formatter stringFromDate:date];
        tempLabel.text =  [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString], [str substringFromIndex:1]];
    } else {
        tempLabel.text = @"";
    }
    
    return tempLabel;
}

-(NSInteger)actualPageForCCPicker:(CCPicker *)picker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM"];
    MenuManager *manager = [MenuManager sharedManager];
    
    NSString * actualDate =  [formatter stringFromDate:manager.selectedDay.date];
    
    NSInteger i = 0;
    for (Day * t_day in manager.days){
        NSString * tempDate = [formatter stringFromDate:t_day.date];
        if ([actualDate isEqualToString:tempDate]){
            return i;
        }
        i++;
        
    }
    return 0;
}



@end
