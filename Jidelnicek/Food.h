//
//  food.h
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Food : NSObject
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSNumber *score;
@property(strong,nonatomic) NSNumber *foodId;
@property(nonatomic, strong) NSNumber *price;

-(id) initWithName:(NSString *)paramName
              WithScore:(NSNumber*)paramScore
                WithFoodId:(NSNumber*)paramId;

@end
