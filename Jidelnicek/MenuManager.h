//
//  dayManager.h
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KissXML/DDXML.h>
#import <AFNetworking/AFNetworking.h>
#import "DDXMLElement+StringExtension.h"
#import "Day.h"
#import "NSData+Additions.h"

#define XML_URL @"http://77.93.202.6:5101/mendelu_jidelnicek/jidelnicek.xml"
#define BASE_URL @"http://77.93.202.6:5101/mendelu_jidelnicek/"
#define RATE_SCRIPT_NAME @"send_score.php"
#define MONEY_URL @"https://is.mendelu.cz/auth/uskm/jidelnicek.pl"

FOUNDATION_EXPORT NSString * const MenuManagerMenuKey;
FOUNDATION_EXPORT NSInteger const MenuManagerNoLoginDataError;

typedef void(^SuccessBlock)();
typedef void(^SuccessCashBlock)(NSString *amount);
typedef void(^FailureBlock)(NSError *error);

@interface MenuManager : NSObject

@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) Day *selectedDay;

+ (instancetype)sharedManager;
- (void)loadMenuFromURL:(NSURL *)url success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
- (void)rateFood:(NSInteger)foodID rate:(CGFloat)rating;
- (void)accountBalanceWithLoginSuccess:(SuccessCashBlock)success failure:(FailureBlock)failure;

@end
