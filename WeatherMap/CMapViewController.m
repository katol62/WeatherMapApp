
#import "CMapViewController.h"

@interface CMapViewController ()

@end

@implementation CMapViewController

@synthesize mapView, location, forecastView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    zoom = NO;
    first_run = NO;
    
	[[self navigationController].navigationBar setHidden:YES];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];  
    
    [self.view addSubview:mapView];
    
    mapView.showsUserLocation = YES;
    mapView.delegate = self; 
    
    forecastView = [[CForecastView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 70.0f)];
    [self.view addSubview:forecastView];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    /*
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenRect.size.height - 120, screenRect.size.width, 120)];
    [self.view addSubview:toolBar];
    
     
    UIBarButtonItem *forecstButton = 
    [[UIBarButtonItem alloc]
     initWithTitle: @"Get Weather Forecast"
     style:UIBarButtonItemStyleBordered
     target: self
     action:@selector(getWeathreForecast:)];
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:forecstButton, nil];
    
    toolBar.items = buttons;
    */
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(10, 2, 150, 30);
	button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(16.0)];
	[button setTitle:@"Update Weather" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(getWeathreForecast:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parseDataHandler:) name:EVENT_DATA_PARSED object:nil ];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma gesture recognizer

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //[self.mapView removeGestureRecognizer:sender];
    }
    else
    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        
        self.location = locCoord;
        
        CAnnotation *newannotation = [[CAnnotation alloc] initWithCoordinates:locCoord];
        [self.mapView addAnnotation:newannotation];
        
    }
}



#pragma MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    location = [[[self.mapView userLocation] location] coordinate];  
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    if (first_run == NO) {
        [self get_request];
    }

} 

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"tap");
    if ([view.annotation isKindOfClass:[CAnnotation class]]) {
        NSLog(@"tap custom coords");
        CAnnotation *an = (CAnnotation *)view;
        location = an.coordinate;
    }
    else if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        NSLog(@"tap user coords");
        location = self.mapView.userLocation.coordinate;
    }
    
}

#pragma custom

-(void) get_request
{
    NSString *url = [NSString stringWithFormat: @"http://free.worldweatheronline.com/feed/weather.ashx?q=%.2f,%.2f&format=json&num_of_days=5&key=86831188cf073406120705", location.latitude, location.longitude];
    
    MKCoordinateRegion region;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 5.5;
    span.longitudeDelta = 5.5;
    region.span = span;
    
    region.center = location;
    [mapView setRegion:region animated:YES];
    
    [[CCommunicator shared] request:url WithData:nil Method:@"GET"];
}

-(void)parseDataHandler: (NSNotification *) notification
{
	NSMutableDictionary *data = (NSMutableDictionary *)[notification userInfo];
	NSDictionary *response = [data objectForKey:@"data"];
    
    NSMutableDictionary *d = [response objectForKey:@"data"];
    
    NSMutableArray *weather = (NSMutableArray *)[d objectForKey:@"weather"];
    
    [forecastView update_forecast:weather];
    /*
    CForecastViewController *forecastcontroller = [[CForecastViewController alloc] initWithData:weather];
    [self.navigationController pushViewController:forecastcontroller animated:YES];
    */
}

-(IBAction)zoomIn:(id)sender
{
    MKCoordinateRegion newRegion; 
    //MKUserLocation* usrLocation = mapView.userLocation; 
    //newRegion.center.latitude = usrLocation.location.coordinate.latitude; 
    //newRegion.center.longitude = usrLocation.location.coordinate.longitude;
    newRegion.center.latitude = self.location.latitude; 
    newRegion.center.longitude = self.location.longitude;
    newRegion.span.latitudeDelta = 20.0;
    newRegion.span.longitudeDelta = 28.0; 
    [self.mapView setRegion:newRegion animated:YES];
    /*
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    [mapView setRegion:region animated:YES];
     */
}

-(IBAction)changeMapType:(id)sender
{
    if (mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeSatellite;
    else
        mapView.mapType = MKMapTypeStandard;

}

-(IBAction)getWeathreForecast:(id)sender
{
    [self get_request];
}

@end
