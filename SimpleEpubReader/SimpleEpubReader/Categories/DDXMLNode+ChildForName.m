//
//  DDXMLNode+ChildForName.m
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DDXMLNode+ChildForName.h"

@implementation DDXMLNode (ChildForName)

- (DDXMLNode*)childForName:(NSString*)name
{
    for (DDXMLNode* child in [self children])
    {
        if ([child.name isEqualToString:name])
        {
            return child;
        }
    }
    return nil;
}

@end
