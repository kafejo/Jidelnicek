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

@interface ViewController (){
Reachability *internetReachableFoo;
}
@end

@implementation ViewController

-(void) viewDidAppear:(BOOL)animated {
    // aktualizuji si data po prechodu - jako kdybych stisknoul tlacitko na aktualizaci
     //[self reload];
     [self performSelectorInBackground:@selector(createMoneyLabel) withObject:nil];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.pickerView == NULL){
        #if DEBUG
        NSLog(@"Null picker");
        #endif
    }
    
    self.navigationController.navigationItem.leftBarButtonItem.tintColor= [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshXML:) forControlEvents:UIControlEventValueChanged];
    
    [self.table addSubview:refresh];
    
    self.pickerView.pickerDelegate = self;
    self.pickerView.backgroundColor = [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    
    // vytvorim si hlasku kdyz nemam data
    [self createNoDataWarn];
    
    // stahnu data z netu
    //[self downloadXmlFromInternet];
    // aktualizuji tabulku
    [self reload];
}

- (void)refreshXML:(UIRefreshControl *)refreshControl {
    [self downloadXmlFromInternet];
    [self reload];
    [refreshControl endRefreshing];
}

// aktualizuje data
-(void) reload{
    // novej manager
    self.manager = [[DayManager alloc] initWithDate:[[NSDate alloc]init]];
    // vyparsuju jidelnicek
    [_manager parseXML:@"jidelnicek"];
    // nastavim aktualni den
    [_manager setActualDay];
    // nastavim money label
   
    //[self createMoneyLabel];
    
    // debug vypis
   //[_manager printActualDay];
    // podle stavu zobrazim nebo nezobrazim zpravu o nedostupnosti dat pro dany den
    [self ShowOrHideNoDataWarn];
    #if DEBUG
        NSLog(@"Celkovy pocet dnu je %i",[_manager.days count]);
    #endif
    // zmenil jsem actualni den proto obnovuju tabulku
    [_table reloadData];
    [self.pickerView reloadData];
    
}

-(IBAction)showInfo:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About" message:@"Application made by KeepUp\n\nAleš Kocur\nMikuláš Muroň\n\n Version 0.8" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    
    UITextView *someTextView = [[UITextView alloc] initWithFrame:CGRectMake(40, 10, 350, 500)];
    someTextView.backgroundColor = [UIColor blueColor];
    someTextView.textColor = [UIColor blackColor];
    someTextView.editable = NO;
    someTextView.font = [UIFont systemFontOfSize:15];
    someTextView.text = @"Application made by KeepUp\n\nAleš Kocur\nMikuláš Muroň";
    [alert addSubview:someTextView];
    [alert show];
}

-(void) ShowOrHideNoDataWarn {
    if (_manager.actual == nil){
        self.noDataWarn.hidden = FALSE;
    }
    else {
        self.noDataWarn.hidden = TRUE;
    }
    
}

-(void) downloadXmlFromInternet {
    //UIActivityIndicatorView *indicator =
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    /* The capture of self here is coming in with your implicit property access 
     * of self.timerDisp you can't refer to self or properties on self from within a block that
     * will be strongly retained by self.
     */
    __weak typeof(self) weakSelf = self;
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *url = [[NSString stringWithFormat:@"http://akela.mendelu.cz/~xmuron1/jidelnicek/jidelnicek.xml"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *jidelnicek_xml = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:jidelnicek_xml forKey:@"jidelnicek"];
        
            //NSLog(@"Jsem na netu a stahnul jsem novy jidelnicek");
            
            [weakSelf reload];
        });
        
    };
    
    
    [internetReachableFoo startNotifier];
    
    
}


// akce pri stisknuti tlacitka

// Prihlaseni do IS a parsovani
-(void) createMoneyLabelInternetOk {
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://is.mendelu.cz/auth/uskm/jidelnicek.pl"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    [urlRequest addValue:@"en-US" forHTTPHeaderField:@"Content-Language"];
    [urlRequest addValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];
    
    
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response error:&error];
    
    // Odkomentuj pokud chces zobrazit data co ti prisla
    // NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);

    
    if (error == nil)
    {
        NSString * s_data = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSString *pattern = @"Account balance&nbsp;(.*?)&nbsp;CZK";
        NSError* error = nil;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:s_data options:0 range:NSMakeRange(0, [s_data length])];
        
        
        
        NSString * TextLabel = [NSString stringWithFormat:@" %@ Kč", [s_data substringWithRange:[match rangeAtIndex:1]]];
        self.navigationItem.leftBarButtonItem.title = TextLabel;
        
        [[NSUserDefaults standardUserDefaults] setObject:TextLabel  forKey:@"money"];
        //NSLog(@"Ukladam kredit");
        
    }
    

    
}


-(void) createMoneyLabelInternetError {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"money"] != nil){
        self.navigationItem.leftBarButtonItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"money"];
    }

}

// vytvarim a obnovuji tlacitko s loginem ci kreditem
-(void) createMoneyLabel {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"password"] != nil &&
        [[NSUserDefaults standardUserDefaults] objectForKey:@"correctUserNameAndPassword"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"correctUserNameAndPassword"] isEqual: @"1"])
    {
    //NSLog(@"Jmeno,heslo je zadano a je spravne - pokusim se ziskat data o kreditech");
        
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    __weak typeof(self) weakSelf = self;
        
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf performSelectorInBackground:@selector(createMoneyLabelInternetOk) withObject:nil];
            //[weakSelf createMoneyLabelInternetOk];
            
        });
    };
    
    internetReachableFoo.unreachableBlock = ^(Reachability *reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf performSelectorInBackground:@selector(createMoneyLabelInternetError) withObject:nil];
            
        });
    };

    
    [internetReachableFoo startNotifier];
    
    }
    else {
        self.navigationItem.leftBarButtonItem.title = @"Přihlášení";
    }
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
        switch (indexPath.section) {
            case 0:
                rateView.ratingData = [[[[[_manager actual] foods]objectAtIndex:indexPath.row ] score]floatValue];
                rateView.foodLabelData = [[[[_manager actual] foods] objectAtIndex:indexPath.row] name];
                rateView.foodId = [[[[_manager actual] foods] objectAtIndex:indexPath.row] foodId];
                break;
            case 1:
                rateView.ratingData = [[[[[_manager actual] shortOrder]objectAtIndex:indexPath.row ] score]floatValue];
                rateView.foodLabelData = [[[[_manager actual] shortOrder] objectAtIndex:indexPath.row] name];
                rateView.foodId = [[[[_manager actual] shortOrder] objectAtIndex:indexPath.row] foodId];
                break;
            case 2:
                rateView.ratingData = [[[[[_manager actual] otherFood]objectAtIndex:indexPath.row ] score]floatValue];
                rateView.foodLabelData = [[[[_manager actual] otherFood] objectAtIndex:indexPath.row] name];
                rateView.foodId = [[[[_manager actual] otherFood] objectAtIndex:indexPath.row] foodId];
                break;
                
            default:
                break;
        }
        
    }
}


#pragma mark - Table view data source
// Return the number of sections.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
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

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[[_manager actual] foods] count];
            break;
        case 1:
            return [[[_manager actual] shortOrder] count];
            break;
        case 2:
            return [[[_manager actual] otherFood] count];
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
    switch (indexPath.section) {
        case 0:
            cell.name.text = [[[[_manager actual] foods]objectAtIndex:indexPath.item ] name];
            t_score = [[[[[_manager actual] foods]objectAtIndex:indexPath.row ] score] floatValue];
            break;
        case 1:
            cell.name.text = [[[[_manager actual] shortOrder]objectAtIndex:(indexPath.item) ] name];
            t_score = [[[[[_manager actual] shortOrder]objectAtIndex:indexPath.row ] score] floatValue];
            break;
        case 2:
            cell.name.text = [[[[_manager actual] otherFood]objectAtIndex:indexPath.item ] name];
            t_score = [[[[[_manager actual] otherFood]objectAtIndex:indexPath.row ] score] floatValue];
            break;
            
        default:
            break;
    }
    cell.score.text = [NSString stringWithFormat:@"%0.0f / 5",t_score];
    cell.score.textColor = [UIColor colorWithRed:39.0f/255.0f green:104.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
    
    return cell;
}

#pragma mark - CCPicker data source and delegate method

-(NSInteger)numberOfRowForPicker:(CCPicker *)picker{
     // NSLog(@"UPDATUJU PICKER");
    return [_manager.days count];
}

-(void)CCPicker:(CCPicker *)picker didChangePage:(NSInteger)page{
    if ([self.manager.days count]> 0) {
        _manager.actual = [_manager.days objectAtIndex:page];
        [self ShowOrHideNoDataWarn];
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
        [formatter setDateFormat:@"EEEE - dd. MM."];
    }else{
        [formatter setDateFormat:@"EE - dd. MM."];
    }
    
    
    if ([_manager.days count] > 0){
        
        NSDate *Date = [[_manager.days objectAtIndex:row] date];
        NSString *str = [formatter stringFromDate:Date];
        tempLabel.text =  [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString], [str substringFromIndex:1]];
    }
    else {
        tempLabel.text = @"";
    }
    return tempLabel;
}

-(NSInteger)actualPageForCCPicker:(CCPicker *)picker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM"];
    
    NSString * actualDate =  [formatter stringFromDate:_manager.actual.date];
    
    NSInteger i = 0;
    for (Day * t_day in _manager.days){
        NSString * tempDate = [formatter stringFromDate:t_day.date];
        if ([actualDate isEqualToString:tempDate]){
            return i;
        }
        i++;
        
    }
    return 0;
}

/*
// zvolil sis vec v datapickeru
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if ([self.manager.days count]> 0) {
         _manager.actual = [_manager.days objectAtIndex:row];
        [self ShowOrHideNoDataWarn];
        [_table reloadData];
    }
   
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_manager.days count];
}

// jaky index v datapickeru ma aktualni den
-(NSInteger) returnRowOfActualDayInDatePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM"];
    
    
    NSString * actualDate =  [formatter stringFromDate:_manager.actual.date];
    
    NSInteger i = 0;
    for (Day * t_day in _manager.days){
        NSString * tempDate = [formatter stringFromDate:t_day.date];
        if ([actualDate isEqualToString:tempDate]){
            return i;
        }
        i++;
        
    }
    return 0;
}


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE  dd.MM"];
    
    if ([_manager.days count] > 0){
        NSDate *Date = [[_manager.days objectAtIndex:row] date];
        NSString * Date_string =  [formatter stringFromDate:Date];
        return Date_string;
    }
    else {
        return 0;
    }
    
    
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 500;
}

*/


@end
