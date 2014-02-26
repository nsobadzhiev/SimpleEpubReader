//
//  NSError+Description.h
//  GeneraliiPhone
//
//  Created by Nikola Sobadjiev on 11/16/13.
//  Copyright (c) 2013 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Description)

+ (NSError*)errorWithCode:(NSInteger)code
                   domain:(NSString*)domain
              description:(NSString*)desc;

@end
