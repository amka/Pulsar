//
//  MEDocument.m
//  Pulsar
//
//  Created by Andrey M. on 02.06.13.
//  Copyright (c) 2013 Andrey M. All rights reserved.
//

#import "MEDocument.h"

@implementation MEDocument

static NSUInteger attachedSubViewIndex = 0;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    _toolbar = [[CNSplitViewToolbar alloc] init];
    CNSplitViewToolbarButton *addVersionButton = [[CNSplitViewToolbarButton alloc] init];
    addVersionButton.toolTip = @"Add another version";
    addVersionButton.imageTemplate = CNSplitViewToolbarButtonImageTemplateAdd;
    [_toolbar addItem:addVersionButton align:CNSplitViewToolbarItemAlignLeft];
    
    [_splitView setDelegate:self];
    [_splitView setToolbarDelegate:self];
    [_splitView attachToolbar:_toolbar toSubViewAtIndex:0 onEdge:CNSplitViewToolbarEdgeBottom];
    
    [_splitView showToolbarAnimated:YES];
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

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex
{
    return 180;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex
{
    return [_contentView bounds].size.width - 180;
}

#pragma mark - CNSplitViewToolbar Delegate

- (NSUInteger)toolbarAttachedSubviewIndex:(CNSplitViewToolbar *)theToolbar
{
    return attachedSubViewIndex;
}

- (void)splitView:(CNSplitView *)theSplitView willShowToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:willShowToolbar:onEdge:");
}

- (void)splitView:(CNSplitView *)theSplitView didShowToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:didShowToolbar:onEdge:");
}

- (void)splitView:(CNSplitView *)theSplitView willHideToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:willHideToolbar:onEdge:");
}

- (void)splitView:(CNSplitView *)theSplitView didHideToolbar:(CNSplitViewToolbar *)theToolbar onEdge:(CNSplitViewToolbarEdge)theEdge
{
    NSLog(@"splitView:didHideToolbar:onEdge:");
}

@end
