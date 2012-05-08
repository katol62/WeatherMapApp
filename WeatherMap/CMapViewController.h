
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CCommunicator.h"
#import "CForecastViewController.h"
#import "CAnnotation.h"
#import "CForecastView.h"

@interface CMapViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView *mapView;
    UIToolbar *toolBar;
    CLLocationCoordinate2D location;
    CForecastView *forecastView;
    BOOL zoom;
    BOOL first_run;
}

@property (nonatomic, retain) MKMapView *mapView;
@property CLLocationCoordinate2D location;
@property (retain) CForecastView *forecastView;

-(void) get_request;

@end
