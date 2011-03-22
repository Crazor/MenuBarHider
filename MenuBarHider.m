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
