#import <Cocoa/Cocoa.h>

@interface MenuBarHider : NSObject {

}

+ (void)load;
+ (MenuBarHider *)sharedInstance;

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context;

@end
