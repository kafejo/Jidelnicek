//
//  dayManager.m
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "MenuManager.h"

NSString * const MenuManagerMenuKey = @"jidelnicek";
NSInteger const MenuManagerNoLoginError = 1023;

@interface MenuManager ()

@property (readwrite, copy) SuccessBlock successBlock;
@property (readwrite, copy) FailureBlock failureBlock;

@end

@implementation MenuManager

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _days = [@[] mutableCopy];
        _selectedDay = nil;
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static MenuManager * sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MenuManager alloc] init];
    });
    
    return sharedManager;
}

- (void)loadMenuFromURL:(NSURL *)url
                success:(SuccessBlock)successBlock
                failure:(FailureBlock)failureBlock {
    
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer new];
        
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/xml", @"application/xml", nil]];
        __block NSData *xml = nil;
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:XML_URL]];
        request.timeoutInterval = 30;
        request.networkServiceType = NSURLNetworkServiceTypeDefault;
        request.allowsCellularAccess = YES;
        request.HTTPMethod = @"GET";
        
        AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

            xml = (NSData *)responseObject;
            /*  XML log
            NSString *data = [[NSString alloc] initWithData:xml encoding:NSUTF8StringEncoding];
            NSLog(@"%@", data);
             */
            [[NSUserDefaults standardUserDefaults] setObject:xml forKey:MenuManagerMenuKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self parseXML];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.failureBlock(error);
        }];
        
        [requestOperation start];
        
    } else {
        NSError *error = [NSError errorWithDomain:@"No connection" code:AFNetworkReachabilityStatusNotReachable userInfo:@{}];
        
        self.failureBlock(error);
    }
}

- (Day *)lastAvailableDay {
    __block Day *actualDay = [self.days firstObject];
    
    [self.days enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([[(Day *)obj date] compare:[NSDate new]] == NSOrderedAscending) {
            actualDay = obj;
        } else {
            *stop = YES;
        }
        
    }];
    
    return actualDay;
}

-(void)parseXML{
    
    NSData *xmlContent = [[NSUserDefaults standardUserDefaults] objectForKey:MenuManagerMenuKey];
    NSError *error;
    
    if (xmlContent == NULL) {
        // NSLog(@"Nemam zadny data!!");
        error = [NSError errorWithDomain:@"No data" code:123 userInfo:nil];
        self.failureBlock(error);
        return;
    }
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithData:xmlContent options:0 error:&error];
    
    if (error) {
        // NSLog(@"Fuck");
        self.failureBlock(error);
        return ;
    }
    
    DDXMLElement *root = [xml rootElement]; // ITEMS
    
    [self.days removeAllObjects]; // remove all days before setting news
    
    NSString *date = @"";
    NSDate *converted_date = [[NSDate alloc]init];
    
    for (DDXMLElement *element in [root children]) {
        if ([[element name] isEqualToString:@"day"]) { // tag day
            // nactu si time
            date = [element stringElementForName:@"time"];
            
            // prevedu string na NSDate
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd.MM.yyyy"];
            converted_date = [dateFormat dateFromString:date];
            // inicializuju s timem
            Day * tempDay = [[Day alloc]initWithDate:converted_date];
          //  NSLog(@"Datum je: %@",temp_string);
            
            for (DDXMLElement *subItem in [element children]) {
                if([[subItem name]isEqualToString:@"food"]){
                    
                    NSInteger type = [[subItem stringElementForName:@"type"] integerValue];
                    
                   // alloc and set new food
                    Food *tempFood = [[Food alloc] init];
                    tempFood.name = [subItem stringElementForName:@"name"];
                    tempFood.score = [NSNumber numberWithDouble:[[subItem stringElementForName:@"score"] doubleValue]];
                    tempFood.foodId = [NSNumber numberWithInteger:[[subItem stringElementForName:@"id"] integerValue]];
                    tempFood.price = [NSNumber numberWithFloat:[[subItem stringElementForName:@"price"] floatValue]];
                    [tempDay addFood:tempFood Type:(FoodType)--type]; // -- because i want number in range 0–2 and there is range 1-3
                }
            }
     //       NSLog(@"Pocet jidel je %i.",[[PomDay foods] count]);
            
            [self.days addObject:tempDay];
        }
        
    }
    // set actual date
    self.selectedDay = [self lastAvailableDay];
    
    self.successBlock();
    
}

- (void)rateFood:(NSInteger)foodID rate:(CGFloat)rating {
    
    NSString *rateURL = [NSString stringWithFormat:@"%@%@", BASE_URL, RATE_SCRIPT_NAME];
    NSDictionary *parameters = @{@"id_food" : [NSString stringWithFormat:@"%lu", (long)foodID],
                                 @"score" : [NSString stringWithFormat:@"%f", rating]
                                 };
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    
    [manager GET:rateURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Hotovo");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ohodnoceno" message:@"Vaše hodnocení bylo úspěšně započteno" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Nehotovo %@", error.localizedDescription);
       
    }];
    /*
    alert = [[UIAlertView alloc] initWithTitle:@"Chyba" message:@"Při hodnocení nastala chyba, zkontrolujte připojení k internetu." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    alert = [[UIAlertView alloc] initWithTitle:@"Ohodnoceno" message:@"Vaše hodnocení bylo úspěšně započteno" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
     */
    
}


- (void)accountBalanceWithLoginSuccess:(SuccessCashBlock)success failure:(FailureBlock)failure {
    
    NSMutableURLRequest *authRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://is.mendelu.cz/system/login.pl"] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    if (!(username && password)) {
        failure([NSError errorWithDomain:@"No login data" code:MenuManagerNoLoginError userInfo:nil]);
        return ;
    }
    
    NSString *body = [NSString stringWithFormat:@"destination=/auth/&credential_0=%@&credential_1=%@&login=Přihlásit+se&credential_2=86400", username, password];
    authRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    //[authRequest setHTTPShouldHandleCookies:YES];
    
    authRequest.HTTPMethod = @"POST";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:authRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Login request finished");
        [self accountBalanceWithSuccess:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Login error: %@", error.localizedDescription);
        failure (error);
    }];
    
    [operation start];
}

- (void)accountBalanceWithSuccess:(SuccessCashBlock)success failure:(FailureBlock)failure {
    
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    NSString *user = [sud objectForKey:@"username"];
    NSString *password = [sud objectForKey:@"password"];
    if (!(user && password)) {
        failure([NSError errorWithDomain:@"No login data" code:MenuManagerNoLoginError userInfo:nil]);
        return ;
    }
    
    NSMutableURLRequest *moneyRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MONEY_URL]];
    /*
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", user, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    */
    //[moneyRequest setHTTPShouldHandleCookies:YES];
    //[moneyRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    [moneyRequest addValue:@"en-US" forHTTPHeaderField:@"Content-Language"];
    [moneyRequest addValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer new];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:moneyRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *s_data = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSASCIIStringEncoding];
        // parsing account balance from
        NSString *pattern = @"Account balance&nbsp;(.*?)&nbsp;CZK";
        NSError* error = nil;
        
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:s_data options:0 range:NSMakeRange(0, [s_data length])];
        NSString *fs = [s_data substringWithRange:[match rangeAtIndex:1]];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *number = [f numberFromString:fs];
        
        NSString *amount = [NSString stringWithFormat:@" %0.2f Kč", [number floatValue]];
        success(amount);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    if ([manager.reachabilityManager isReachable]) {
        [operation start];
    } else {
        failure([NSError errorWithDomain:@"Network is not reachable" code:AFNetworkReachabilityStatusNotReachable userInfo:nil]);
    }
    
}

@end