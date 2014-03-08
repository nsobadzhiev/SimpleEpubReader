//
//  DDXMLNode+ChildForName.h
//  SimpleEpubReader
//
//  Created by Nikola Sobadjiev on 3/6/14.
//  Copyright (c) 2014 Nikola Sobadjiev. All rights reserved.
//

#import "DDXMLNode.h"

@interface DDXMLNode (ChildForName)

- (DDXMLNode*)childForName:(NSString*)name;

@end
