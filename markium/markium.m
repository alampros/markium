//
//  markium.m
//  
//
//  Created by Aaron Lampros on 8/17/11.
//  Copyright (c) 2011 Dealer Tire, LLC. All rights reserved.
//

#import <Adium/AIContentControllerProtocol.h>
#import "markium.h"
#import "CBActionSupportPlugin.h"
#import <Adium/AIContentObject.h>
#import <Adium/AIListObject.h>
#import <Adium/AIContentMessage.h>
#import <AdiumContentFiltering.h>



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
    NSLog(@"Markium installed.");
    [adium.contentController registerContentFilter:self ofType:AIFilterMessageDisplay direction:AIFilterOutgoing];
    [adium.contentController registerContentFilter:self ofType:AIFilterMessageDisplay direction:AIFilterIncoming];
    [adium.contentController registerHTMLContentFilter:self direction:AIFilterOutgoing];
    [adium.contentController registerHTMLContentFilter:self direction:AIFilterIncoming];
    NSLog(@"Markium registered.");
    
}

- (void)uninstallPlugin {
	[adium.contentController unregisterHTMLContentFilter:self];
	[adium.contentController unregisterContentFilter:self];
    NSLog(@"Markium uninstalled");
}

- (CGFloat)filterPriority {
    return LOW_FILTER_PRIORITY;
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)inAttributedString context:(id)context;
{
    NSLog(@"Recieved text %@",inAttributedString);
	return inAttributedString;
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject*)content;
{
    NSLog(@"Recieved HTML STRING!!!");
    
    return inHTMLString;
}



@end
