/*
 * This file is part of the MenuBarHider project.
 *
 * Copyright 2010-2014 Crazor <crazor@gmail.com>
 *
 * MenuBarHider is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MenuBarHider is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MenuBarHider.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "MenuBarHider.h"

#import "JRSwizzle/JRSwizzle.h"
#import <Carbon/Carbon.h>


@interface NSScreen (MenuBarHider)
- (NSRect)myVisibleFrame;
@end

@implementation NSScreen (MenuBarHider)
- (NSRect)myVisibleFrame
{
    return [self frame];
}
@end


@implementation MenuBarHider

static MenuBarHider *sharedInstance;

+ (void)load
{
#ifdef DEBUG
	NSLog(@"MenuBarHider loaded.");
#endif
	SetSystemUIMode(kUIModeAllSuppressed, 0);
	[[NSApplication sharedApplication] addObserver:[MenuBarHider sharedInstance]
										forKeyPath:@"currentSystemPresentationOptions"
										   options:(NSKeyValueObservingOptionNew
													| NSKeyValueObservingOptionOld)
										   context:NULL];
        
    [NSScreen jr_swizzleMethod:@selector(visibleFrame) withMethod:@selector(myVisibleFrame) error:NULL];
}

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		sharedInstance = [[MenuBarHider alloc] init];
		initialized = YES;
	}
}

+ (MenuBarHider *)sharedInstance
{
	return sharedInstance;
}

- (id)init
{
	if (sharedInstance)
	{
		[self dealloc];
		return sharedInstance;
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if ([[NSApplication sharedApplication] isActive]
		&&[[change objectForKey:@"new"] integerValue] == 0)
	{
#ifdef DEBUG
		NSLog(@"We need to change SystemUIMode back to auto-hide the menu bar.");
#endif
		SetSystemUIMode(kUIModeAllSuppressed, 0);
	}
}



@end
