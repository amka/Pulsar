//
//  LNSSourceListSourceGroupCell.m
//  SourceList
//
//  Created by Mark Alldritt on 07/09/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LNSSourceListSourceGroupCell.h"

//	A source group is the unselectable (grayed out) group at the top of the source list
//	hierarchy.

//	These colors are sampled from the Finder's source group display.  I suspect at some point NSColor
//	will gain constants for these colors.
#define INACTIVE_TEXT_COLOR	[NSColor colorWithCalibratedRed:0.311 green:0.311 blue:0.311 alpha:1.000]
#define ACTIVE_TEXT_COLOR	[NSColor colorWithCalibratedRed:0.378 green:0.432 blue:0.503 alpha:1.000]


@implementation LNSSourceListSourceGroupCell

- (id) initTextCell:(NSString*)aString
{
	if ((self = [super initTextCell:aString]))
	{
		//	Get an etched background behind the cell's text to mimic the Finder
#if 0
		[self setBackgroundStyle:NSBackgroundStyleRaised];
#else
		[self setBackgroundStyle:NSBackgroundStyleLowered];
#endif
		//	Convert the cell's default font to Bold to mimic the Finder
		[self setFont:[[NSFontManager sharedFontManager] convertFont:[self font] toHaveTrait:NSBoldFontMask]];
	}
	
	return self;
}

- (void) drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	BOOL isActive = [[controlView window] isMainWindow];
	
	[self setTextColor:isActive ? ACTIVE_TEXT_COLOR : INACTIVE_TEXT_COLOR];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
