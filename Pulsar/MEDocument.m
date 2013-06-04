//
//  MEDocument.m
//  Pulsar
//
//  Created by Andrey M. on 02.06.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import "MEDocument.h"
#import "LNSSourceListSourceGroupCell.h"


#define kSnapToDelta			8.0
#define	kMinSourceListWidth		110.0
#define kSnapSourceListWidth	250.0
#define kMinContentWidth		150.0


@implementation MEDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        _sourceList = [[NSMutableArray alloc] init];
        
        [_sourceList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithBool:YES], @"isSourceGroup",
                                NSLocalizedString(@"Versions", "appcast application versions"), @"name",
                                [NSArray arrayWithObjects:
                                 [NSDictionary dictionaryWithObjectsAndKeys: @"Music", @"name", nil],
                                 [NSDictionary dictionaryWithObjectsAndKeys: @"Movies", @"name", nil],
								 [NSDictionary dictionaryWithObjectsAndKeys: @"TV Shows", @"name", nil],
								 [NSDictionary dictionaryWithObjectsAndKeys: @"Podcasts", @"name", nil],
                                 nil], @"children",
                                nil]];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MEDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
	
	[_sourceListView setDelegate:self];
    
	//	Expand the group items...
	for (id node in [[_sourceListController arrangedObjects] childNodes])
		[_sourceListView expandItem:node];
	//	Select the first item of the first group...
	[_sourceListView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithData:data
                                                             options:NSXMLNodeOptionsNone
                                                               error:nil];
    self.document = xmlDocument;
    return YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - NSSplitView Delegate
- (void) splitView:(NSSplitView*) splitView resizeSubviewsWithOldSize:(NSSize) oldSize
{
	if (splitView == _splitView)
	{
		CGFloat dividerPos = NSWidth([[[splitView subviews] objectAtIndex:0] frame]);
		CGFloat width = NSWidth([splitView frame]);
        
		if (dividerPos < kMinSourceListWidth)
			dividerPos = kMinSourceListWidth;
		if (width - dividerPos < kMinContentWidth + [splitView dividerThickness])
			dividerPos = width - (kMinContentWidth + [splitView dividerThickness]);
		
		[splitView adjustSubviews];
		[splitView setPosition:dividerPos ofDividerAtIndex:0];
	}
}

- (CGFloat) splitView:(NSSplitView*) splitView constrainSplitPosition:(CGFloat) proposedPosition ofSubviewAt:(NSInteger) dividerIndex
{
	if (splitView == _splitView)
	{
		CGFloat width = NSWidth([splitView frame]);
		
		if (ABS(kSnapSourceListWidth - proposedPosition) <= kSnapToDelta)
			proposedPosition = kSnapSourceListWidth;
		if (proposedPosition < kMinSourceListWidth)
			proposedPosition = kMinSourceListWidth;
		if (width - proposedPosition < kMinContentWidth + [splitView dividerThickness])
			proposedPosition = width - (kMinContentWidth + [splitView dividerThickness]);
	}
	
	return proposedPosition;
}


#pragma mark - NSOutlineView Delegate
//	Method to determine if an outline item is a source group
- (BOOL) isSourceGroupItem:(id) item
{
	return [[[item representedObject] objectForKey:@"isSourceGroup"] boolValue];
}

//	NSOutlineView delegate methods
//
//	Do the minimum to implement a iTunes/Finder inspired source list outline.
//
//	The combination of NSTableView's new setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList
//	property and -outlineView:isGroupItem: delegate method do a lot of the work for us.  However, there are still
//	a few cosmetic and functional overrides needed to fully mimic the Finder's source list.
//
//	Note that LNSSourceListSourceGroupCell further customizes the appearance of Source List group items to mimic
//	the Finder.  LNSSourceListSourceGroupCell is *a lot* simpler in this verison that my previous SopurceList
//	implementation.

- (BOOL) outlineView:(NSOutlineView*) outlineView shouldShowOutlineCellForItem:(id) item
{
	//	Don't show the expander triangle for group items...
	return ![self isSourceGroupItem:item];
}

- (BOOL)outlineView:(NSOutlineView*) outlineView isGroupItem:(id) item
{
	return [self isSourceGroupItem:item];
}

- (void) outlineView:(NSOutlineView*) outlineView willDisplayCell:(id) cell forTableColumn:(NSTableColumn*) tableColumn item:(id) item
{
	if ([self isSourceGroupItem:item])
		[cell setTitle:[[cell title] uppercaseString]];
}

- (NSCell*) outlineView:(NSOutlineView*) outlineView dataCellForTableColumn:(NSTableColumn*) tableColumn item:(id) item
{
	if ([self isSourceGroupItem:item])
		return [[LNSSourceListSourceGroupCell alloc] init];
	else
		return [tableColumn dataCell];
}

- (BOOL) outlineView:(NSOutlineView*) outlineView shouldSelectItem:(id) item
{
	return ![self isSourceGroupItem:item];
}

- (CGFloat)outlineView:(NSOutlineView*) outlineView heightOfRowByItem:(id) item
{
	//	Make the height of Source Group items a little higher
	if ([self isSourceGroupItem:item])
		return [outlineView rowHeight] + 5.0;
	return [outlineView rowHeight];
}

@end
