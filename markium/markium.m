//
//  markium.m
//  
//
//  Created by Aaron Lampros on 8/17/11.
//  Copyright (c) 2011 Dealer Tire, LLC. All rights reserved.
//

#import "markium.h"


@implementation markium

- (void)installPlugin {
    NSLog(@"Markium installed");
    //[[adium contentController] registerHTMLContentFilter:self ofType:AIFilterMessageDisplay direction:AIFilterIncoming];
    [[adium contentController] registerHTMLContentFilter:self direction:AIFilterIncoming];
    [[adium contentController] registerHTMLContentFilter:self direction:AIFilterOutgoing];
}

- (void)uninstallPlugin {
    NSLog(@"Markium uninstalled");
    [[adium contentController] unregisterHTMLContentFilter:self];
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject*)content
{
    return [inHTMLString autorelease];
}




- (CGFloat)filterPriority
{
	return DEFAULT_FILTER_PRIORITY;
}













- (NSString *)pluginAuthor
{
	return @"Aaron Lampros";
}

- (NSString *)pluginVersion
{
	return @"1.5hg";
}

- (NSString *)pluginDescription
{
	return @"This plugin does almost nothing right now.";
}


@end
