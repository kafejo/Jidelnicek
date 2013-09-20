//
//  dayManager.m
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "DayManager.h"

@implementation DayManager


-(id) initWithDate:(NSDate *)paramDate{
    
    self = [super init];
    if (self){
        _days = [ [NSMutableArray alloc] init];
        [self setLastUpdate:paramDate];
    }
    
    return self;
    
}

-(void) addDay:(Day *) paramDay{
    
    if (paramDay != nil) {
        [_days addObject:paramDay];
    }
    
}

-(void)printActualDay {
    // ladici vystup
#if DEBUG
    NSLog(@"Datum je: %@",[_actual date]);
    NSLog(@"Pocet jidel je: %i",[[_actual foods] count]);
    for ( Food* tmp in [_actual foods]){
        NSLog (@"Jidlo s id: %i ma skore: %f",[tmp.foodId integerValue],[tmp.score floatValue]);
    }
#endif
}

-(void) setActualDay{
    // aktualni den si nastavim jako nil
    _actual = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    // ziskam aktualni datum
    NSDate *currentDate = [[NSDate alloc] init];
    
    // testovaci kod pokud chci zadat jine datum nez dnesni
    //NSString *dateString = @"18-04-13";
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"dd-MM-yy";
    //NSDate *currentDate = [dateFormatter dateFromString:dateString];
    
    // prevedu na string
    NSString * s_CurrentDay =  [formatter stringFromDate:currentDate];

    // hledani aktualniho datumu
    for (Day* t_day in _days){
        NSString * s_Day = [formatter stringFromDate:t_day.date];
        if ([s_Day isEqualToString:s_CurrentDay]) {
            _actual = t_day;
            // NSLog(@"Jako aktualni nastavuji den %@",[formatter stringFromDate:_actual.date]);
        }
    }
    
}

-(void)parseXML:(NSString*)xmlFile{
    // nactu si data do stringu
    NSString *xmlContent = [[NSUserDefaults standardUserDefaults] objectForKey:xmlFile];
    
    if(xmlContent == NULL){
        NSLog(@"Nemam zadny data!!");
        return;
    }
    
    DDXMLDocument *xml = [[DDXMLDocument alloc] initWithXMLString:xmlContent options:0 error:nil];
    DDXMLElement *root = [xml rootElement]; // ITEMS
    
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
                    [tempDay addFood:tempFood Type:--type]; // -- because i want number in range 0–2 and there is range 1-3
                }

            }
     //       NSLog(@"Pocet jidel je %i.",[[PomDay foods] count]);
            [self addDay:tempDay];
        }
        
    }
    
}




@end