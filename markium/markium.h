//
//  markium.h
//  
//
//  Created by Aaron Lampros on 8/17/11.
//  Copyright (c) 2011 Dealer Tire, LLC. All rights reserved.
//

#import <Adium/AIPlugin.h>
#import <Adium/AISharedAdium.h>
#import <Adium/AIContentControllerProtocol.h>

//@protocol AIContentFilter;

//
//@interface markium : AIPlugin <AIContentFilter> {
//    
//}
//
//@end


@protocol AIHTMLContentFilter;

@interface markium : AIPlugin <AIHTMLContentFilter> {
    
}
@end