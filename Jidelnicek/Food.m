//
//  food.m
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "Food.h"




@implementation Food


-(id) initWithName:(NSString *)paramName
         WithScore:(NSNumber *)paramScore
            WithFoodId:(NSNumber *)paramId
{
    self = [super init];
    
    if (self){
        [self setFoodId:paramId];
        [self setName:paramName];
        [self setScore:paramScore];
    }
    
    return self;
}

@end
