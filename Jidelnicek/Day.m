//
//  day.m
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "Day.h"

@implementation Day

-(id) initWithDate:(NSDate *)paramDate{
    
    self = [super init];
    if (self){
        _foods = [ [NSMutableArray alloc] init];
        _otherFood = [[NSMutableArray alloc] init];
        _shortOrder = [[NSMutableArray alloc] init];
        [self setDate:paramDate];
    }
    
    return self;
    
}

-(BOOL) addFood:(Food *) paramFood Type:(FoodType)type{
    if (paramFood != nil) {
        
        switch (type) {
            case standartFood:
                [_foods addObject:paramFood];
                break;
            case shortOrder:
                [_shortOrder addObject:paramFood];
                break;
            case otherFood:
                [_otherFood addObject:paramFood];
                break;
                
            default:
                break;
        }
        //[_foods addObject:paramFood];
        return YES;
    }
    return NO;
}

-(BOOL) addFoodName:(NSString *) paramName
       addFoodScore:(NSNumber *) paramScore
          addFoodId:(NSNumber *)paramId
{
    [_foods addObject:[[Food alloc]initWithName:paramName WithScore:paramScore WithFoodId:paramId]];
    return 1;
}

@end
