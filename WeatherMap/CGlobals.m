
#import "CGlobals.h"

static CGlobals *__instance = nil;

@implementation CGlobals

+ (CGlobals *) shared
{
    @synchronized(self) {
		if (nil == __instance) {
			__instance  = [[self alloc] init];
            
		}
	}
	// return the instance of this class
	return __instance;
    
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		
		if (__instance == nil) {
			
			__instance = [super allocWithZone:zone];
			return __instance;  // assignment and return on first allocation
		}
	}
	
	return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}


@end
