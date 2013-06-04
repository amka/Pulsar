//
//  MEDocument.h
//  Pulsar
//
//  Created by Andrey M. on 02.06.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CNSplitView.h"


@interface MEDocument : NSDocument <NSOutlineViewDataSource, NSOutlineViewDelegate, NSSplitViewDelegate, CNSplitViewToolbarDelegate>

@property NSXMLDocument *document;
@property NSMutableDictionary *items;

@property CNSplitViewToolbar *toolbar;

@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet CNSplitView *splitView;

@end
