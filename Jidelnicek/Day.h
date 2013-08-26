//
//  day.h
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Food.h"

typedef enum {
    standartFood = 0,
    shortOrder = 1,
    otherFood = 2
}FoodType;

@interface Day : NSObject

@property(strong,nonatomic) NSMutableArray *foods;
@property(strong, nonatomic) NSMutableArray *shortOrder;
@property(strong, nonatomic) NSMutableArray *otherFood;
@property(strong,nonatomic) NSDate *date;

-(id) initWithDate:(NSDate *)paramDate;

-(BOOL) addFood:(Food *)paramFood Type:(FoodType)type;

-(BOOL) addFoodName:(NSString *) paramName
        addFoodScore:(NSNumber *) paramScore
          addFoodId:(NSNumber*) paramId;

@end
