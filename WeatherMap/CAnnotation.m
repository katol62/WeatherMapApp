
#import "CAnnotation.h"

@implementation CAnnotation

@synthesize coordinate;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location {
    self = [super init];
    if (self != nil) {
        coordinate = location;
    }
    return self;
}


@end
