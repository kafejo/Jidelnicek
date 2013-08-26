//
//  dayManager.h
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "Day.h"

@interface DayManager : NSObject

@property(strong,nonatomic) NSMutableArray *days;
@property(nonatomic,strong) NSDate *lastUpdate;
@property(nonatomic,strong) Day * actual;


-(id) initWithDate:(NSDate *)paramDate;
-(void) addDay:(Day *) paramDay;
-(void) parseXML:(NSString*)xmlFile;
-(void) setActualDay;
-(void) printActualDay;






@end
