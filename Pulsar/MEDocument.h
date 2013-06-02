//
//  MEDocument.h
//  Pulsar
//
//  Created by Andrey M. on 02.06.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CNSplitView;

@interface MEDocument : NSDocument

@property (weak) IBOutlet CNSplitView *splitView;

@end
