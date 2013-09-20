//
//  DDXMLElement+StringExtension.m
//  Jidelnicek
//
//  Created by Aleš Kocur on 20.09.13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "DDXMLElement+StringExtension.h"

@implementation DDXMLElement (StringExtension)


-(NSString*)stringElementForName:(NSString*)elementName{
    if([[self elementsForName:elementName] count] > 0){
        return [self replaceTabsAndWhiteSpaces:[[[self elementsForName:elementName] objectAtIndex:0] stringValue]];
    }else{
        NSLog(@"Spatne nacteny element!");
        return @"0";
    }
}

-(NSString*)replaceTabsAndWhiteSpaces:(NSString*)str{
    return [[str stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
}

@end
