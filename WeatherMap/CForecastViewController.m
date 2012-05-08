
#import "CForecastViewController.h"

@interface CForecastViewController ()

@end

@implementation CForecastViewController

@synthesize forecastData;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

-(id) initWithData:(NSMutableArray *)data
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.forecastData = data;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [[self navigationController].navigationBar setHidden:NO];
    //float tabheight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
	
	self.navigationItem.leftBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Back"
									 style:UIBarButtonItemStyleBordered
									target:self
									action:@selector(handleBack:)];
    
    float startX = 5.0f;
    float startY = 5.0f;
    
    for (int i=0; i<[self.forecastData count]; i++) {
        NSMutableDictionary *day = [self.forecastData objectAtIndex:i];
        
        NSMutableArray *weatherIconUrl = [day objectForKey:@"weatherIconUrl"];
        NSMutableDictionary *urlDic = [weatherIconUrl objectAtIndex:0];
        NSString *MyURL = [urlDic objectForKey:@"value"];
        //UIImage *image = [UIImage imageWithContentsOfFile:url];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:image];
        icon.frame = CGRectMake(startX, startY, image.size.width, image.size.height);
        [self.view addSubview:icon];
        
        
        UILabel *label = [ [UILabel alloc ] initWithFrame:CGRectMake(startX+image.size.width+5, startY, screenRect.size.width - startX+image.size.width - 5, 20.0) ];
        label.textAlignment =  UITextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.lineBreakMode = UILineBreakModeWordWrap;
        //label.numberOfLines = 3;
        //[label setTag:100];
        label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];//[UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(16.0)];
        label.text = [NSString stringWithString: [day objectForKey:@"date"]];
        [self.view addSubview:label];
        
        startY += 20;
        
        label = [ [UILabel alloc ] initWithFrame:CGRectMake(startX+image.size.width+5, startY, screenRect.size.width - startX, 20.0) ];
        label.textAlignment =  UITextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.lineBreakMode = UILineBreakModeWordWrap;
        //label.numberOfLines = 3;
        //[label setTag:100];
        label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];//[UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial" size:(12.0)];
        NSString *temper = [NSString stringWithFormat:@"Temperature (C): %@-%@", [day objectForKey:@"tempMinC"], [day objectForKey:@"tempMaxC"]];
        label.text = [NSString stringWithString: temper];
        [self.view addSubview:label];
        
        startY += 20;
        
        label = [ [UILabel alloc ] initWithFrame:CGRectMake(startX+image.size.width+5, startY, screenRect.size.width - startX, 20.0) ];
        label.textAlignment =  UITextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.lineBreakMode = UILineBreakModeWordWrap;
        //label.numberOfLines = 3;
        //[label setTag:100];
        label.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];//[UIColor blackColor];
        label.font = [UIFont fontWithName:@"Arial" size:(12.0)];
        NSString *wind = [NSString stringWithFormat:@"Wind: %@, %@ kph", [day objectForKey:@"winddirection"], [day objectForKey:@"windspeedKmph"]];
        label.text = [NSString stringWithString: wind];
        [self.view addSubview:label];
        
        startY = icon.frame.origin.y + icon.frame.size.height+10;
        
    }

    
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

#pragma custom

-(IBAction)handleBack:(id)sender
{
    [[self navigationController].navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
