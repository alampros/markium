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
#import <Adium/AIContentMessage.h>



@implementation markium

- (NSString *)pluginAuthor
{
	return @"Aaron Lampros";
}

- (NSString *)pluginVersion
{
	return @"0.1.1";
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
	return inAttributedString;
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject*)content;
{
    
    NSBundle *pluginBundle = [NSBundle bundleWithIdentifier:@"com.alampros.markium"];
    NSString *mdExecPath = [pluginBundle pathForResource:@"multimarkdown" ofType:@""];
//    NSLog(@"%@",mdExecPath);
    
    NSTask *task;
    NSData *markedResult;//*sortResult;
    // Data object for grabbing marked text
    
    NSFileHandle *fileToWrite;
    // Handle to standard input for pipe
    NSPipe *inputPipe, *outputPipe;
    NSString *markedText;

    task = [[NSTask alloc] init];
    inputPipe = [[NSPipe alloc] init];
    outputPipe = [[NSPipe alloc] init];
    
    [task setLaunchPath:mdExecPath];
    [task setArguments:[NSArray arrayWithObjects: @"--nonotes", @"--nolabels", @"--nosmart", nil]];

    [task setStandardOutput: outputPipe];
    [task setStandardInput:[NSPipe pipe]];
    [task setStandardInput: inputPipe];
    [task setStandardError:outputPipe];
    [task waitUntilExit];
    [task launch];
    
    fileToWrite = [inputPipe fileHandleForWriting];

    [fileToWrite writeData:[inHTMLString dataUsingEncoding:NSUTF8StringEncoding]];

    [fileToWrite closeFile];
    
    markedResult = [[outputPipe fileHandleForReading] readDataToEndOfFile];

    markedText = [[NSString alloc] initWithData: markedResult encoding: NSUTF8StringEncoding];
    
    return markedText;
}



@end
