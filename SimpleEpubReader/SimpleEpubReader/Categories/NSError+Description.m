//
//  NSError+Description.m
//  GeneraliiPhone
//
//  Created by Nikola Sobadjiev on 11/16/13.
//  Copyright (c) 2013 Nikola Sobadjiev. All rights reserved.
//

#import "NSError+Description.h"

@implementation NSError (Description)

+ (NSError*)errorWithCode:(NSInteger)code
                   domain:(NSString*)domain
              description:(NSString*)desc
{
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:desc
                   forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:domain code:code userInfo:errorDetail];
}

@end
