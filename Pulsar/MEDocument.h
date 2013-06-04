//
//  MEDocument.h
//  Pulsar
//
//  Created by Andrey M. on 02.06.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MEDocument : NSDocument <NSOutlineViewDataSource, NSOutlineViewDelegate, NSSplitViewDelegate>

@property NSXMLDocument *document;
@property NSMutableArray *sourceList;

@property (weak) IBOutlet NSOutlineView *sourceListView;
@property (strong) IBOutlet NSTreeController *sourceListController;

@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSSplitView *splitView;

@end
