//
//  markium.m
//  
//
//  Created by Aaron Lampros on 8/17/11.
//  Copyright (c) 2011 Dealer Tire, LLC. All rights reserved.
//

#import <Adium/AIContentControllerProtocol.h>
#import "markium.h"
#import <Adium/AIContentMessage.h>
#import "HTMLParser.h"


@implementation markium

- (NSString *)pluginAuthor
{
	return @"Aaron Lampros";
}

- (NSString *)pluginVersion
{
	return @"0.1.3";
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
}

- (void)uninstallPlugin {
	[adium.contentController unregisterHTMLContentFilter:self];
	[adium.contentController unregisterContentFilter:self];
}

- (CGFloat)filterPriority {
    return LOW_FILTER_PRIORITY;
}

- (NSAttributedString *)filterAttributedString:(NSAttributedString *)inAttributedString context:(id)context;
{
	return inAttributedString;
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject*)content;
{
//	NSLog(@"==================RECEIVED STRING=====================");
	NSString *messageStr = [NSString stringWithString:content.messageString];
//	NSLog(@"INPUT:%@\n----------\n\n",messageStr);
	
	if ([[messageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
		return messageStr;
	}
	
	NSBundle *pluginBundle = [NSBundle bundleWithIdentifier:@"com.alampros.markium"];
	NSString *mdExecPath = [pluginBundle pathForResource:@"redcarpet_w" ofType:@"rb"];

	NSTask *task;
	NSData *markedResult;//*sortResult;
	// Data object for grabbing marked text
    
	NSFileHandle *fileToWrite;
//	Handle to standard input for pipe
	NSPipe *inputPipe, *outputPipe;
	NSString *markedText;
	
	task = [[NSTask alloc] init];
	inputPipe = [[NSPipe alloc] init];
	outputPipe = [[NSPipe alloc] init];
	
	[task setLaunchPath:mdExecPath];
//	[task setArguments:[NSArray arrayWithObjects: @"-x", @"--nonotes", @"--nolabels", @"--nosmart", @"--process-html", nil]];
	
	[task setStandardOutput: outputPipe];
	[task setStandardInput:[NSPipe pipe]];
	[task setStandardInput: inputPipe];
	[task setStandardError:outputPipe];
	[task waitUntilExit];
	[task launch];

	fileToWrite = [inputPipe fileHandleForWriting];
	
	[fileToWrite writeData:[messageStr dataUsingEncoding:NSUTF8StringEncoding]];
//	NSLog(@"INPUT:%@",content.messageString);
	
	[fileToWrite closeFile];
	
	markedResult = [[outputPipe fileHandleForReading] readDataToEndOfFile];
	
	markedText = [[NSString alloc] initWithData: markedResult encoding: NSUTF8StringEncoding];
	
//	NSLog(@"MARKED:%@",markedText);
	
	[inputPipe release];
	[outputPipe release];
	[task release];
	NSString *retstr = [NSString stringWithString:[self replaceNewLinesInPreTags:markedText]];
	[markedText release];
	return retstr;
}


-(NSString*)replaceNewLinesInPreTags:(NSString*)string
{
	NSMutableString *newStr = [NSMutableString stringWithString:@""];
	NSError *htmlParseError = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:string error:&htmlParseError];
	if (htmlParseError) {
		NSLog(@"Error: %@", htmlParseError);
	}
	HTMLNode *bodyNode = [parser body];
	[newStr appendString:[self getRawChildContents:bodyNode]];
	
//	NSLog(@"newStr:\n%@",newStr);
	NSArray *preNodes = [bodyNode findChildTags:@"pre"];
	for (HTMLNode *preNode in preNodes) {
		NSMutableString *rawcontents = [NSMutableString stringWithString:[preNode rawContents]];
		[rawcontents replaceOccurrencesOfString:@"\n" withString:@"<br/>" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [rawcontents length])];
//		NSLog(@"replaced: \"%@\"",rawcontents);
		[newStr replaceOccurrencesOfString:[preNode rawContents] withString:rawcontents options:NSCaseInsensitiveSearch range:NSMakeRange(0, [newStr length])];
	}
//	NSLog(@"newStr: \"%@\"",newStr);
	return newStr;
}

-(NSString*)getRawChildContents:(HTMLNode*)inXMLNode
{
	NSMutableString *newStr = [NSMutableString stringWithString:@""];
	NSArray *children = [inXMLNode children];
	for (HTMLNode *child in children) {
		[newStr appendString:[child rawContents]];
	}
	return [NSString stringWithFormat:@"%@",newStr ];
}


@end



