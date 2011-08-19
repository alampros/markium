//
//  markium.m
//  
//
//  Created by Aaron Lampros on 8/17/11.
//  Copyright (c) 2011 Dealer Tire, LLC. All rights reserved.
//

#import "markium.h"
#import <AdiumContentFiltering.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIContentMessage.h>


@implementation markium

- (NSString *)pluginAuthor
{
	return @"Aaron Lampros";
}

- (NSString *)pluginVersion
{
	return @"0.1";
}

- (NSString *)pluginDescription
{
	return @"TOP SECRET.";
}

- (NSString *)pluginURL
{
	return @"http://github.com/";
}

- (void)installPlugin {
    [[adium contentController] registerHTMLContentFilter:self direction:AIFilterIncoming];
    NSLog(@"Markium installed");
}

- (void)uninstallPlugin {
    [[adium contentController] unregisterHTMLContentFilter:self];
    NSLog(@"Markium uninstalled");
}

- (CGFloat)filterPriority {
    return LOW_FILTER_PRIORITY;
}


- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject *)content
{
    NSLog(@"body: %@", inHTMLString);
    NSLog(@"Recieved text");
    NSMutableString *newMessage = [[[NSMutableString alloc] initWithString:@"heythere"] autorelease];
    return newMessage;
}



@end
