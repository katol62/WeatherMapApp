
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CAnnotation : MKAnnotationView <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithCoordinates:(CLLocationCoordinate2D)location;


@end
