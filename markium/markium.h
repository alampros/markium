//
//  markium.h
//  
//
//  Created by Aaron Lampros on 8/17/11.
//  Copyright (c) 2011 Dealer Tire, LLC. All rights reserved.
//

#import <Adium/AIPlugin.h>
#import <Adium/AIContentControllerProtocol.h>
#import "HTMLNode.h"


@interface markium : AIPlugin <AIHTMLContentFilter, AIContentFilter>{
}

-(NSString*)replaceNewLinesInPreTags:(NSString*)string;
-(NSString*)getRawChildContents:(HTMLNode*)inXMLNode;

@end