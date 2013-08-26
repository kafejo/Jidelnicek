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
    
    NSString *date = [[NSString alloc]init];
    NSDate *converted_date = [[NSDate alloc]init];
    NSString *name = [[NSString alloc]init];
    NSString *score = [[NSString alloc]init];
    NSString *id_a = [[NSString alloc]init];
    NSInteger type = 0;

    
    for (DDXMLElement *element in [root children]) {
        if ([[element name] isEqualToString:@"day"]) { // tag day
            // nactu si time
            date = [[[element elementsForName:@"time"] objectAtIndex:0] stringValue];
            // osekam time
            date = [date stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            date = [date stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            // prevedu sting na NSDate
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd.MM.yyyy"];
            converted_date = [dateFormat dateFromString:date];
            // inicializuju s timem
            Day * PomDay = [[Day alloc]initWithDate:converted_date];
        //    NSString * temp_string =  [formatter stringFromDate:converted_date];
          //  NSLog(@"Datum je: %@",temp_string);
            
            for (DDXMLElement *subItem in [element children]) {
                if([[subItem name]isEqualToString:@"food"]){
                    // ulozeni do promenych
                    name = [[[subItem elementsForName:@"name"] objectAtIndex:0] stringValue];
                    score = [[[subItem elementsForName:@"score"] objectAtIndex:0] stringValue];
                    id_a = [[[subItem elementsForName:@"id"] objectAtIndex:0] stringValue];
                    NSString *types = [[[subItem elementsForName:@"type"] objectAtIndex:0] stringValue];
                    type = [[types stringByReplacingOccurrencesOfString:@"\n" withString:@""] integerValue];
                    type -= 1;
                    
                    // uprava
                    name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    score = [score stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    id_a = [id_a stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    name = [name stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    score = [score stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    id_a = [id_a stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                  // vytvoreni objektu
                    Food * PomFood = [[Food alloc]initWithName:name
                                WithScore:[[NSNumber alloc] initWithDouble:[score doubleValue]]
                                WithFoodId:[[NSNumber alloc] initWithInteger:[id_a integerValue]]];
                    [PomDay addFood:PomFood Type:type];
                }
                

            }
     //       NSLog(@"Pocet jidel je %i.",[[PomDay foods] count]);
            [self addDay:PomDay];
        }
        
    }
    
}


@end