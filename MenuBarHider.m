#import "MenuBarHider.h"

#import <Carbon/Carbon.h>

@implementation MenuBarHider

+ (void)load
{
	SetSystemUIMode(kUIModeAllSuppressed, 0);
}

@end
