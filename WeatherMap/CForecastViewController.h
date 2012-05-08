
#import <UIKit/UIKit.h>

@interface CForecastViewController : UIViewController
{
    NSMutableArray *forecastData;
}

@property (retain) NSMutableArray *forecastData;

-(id) initWithData:(NSMutableArray *)data;


@end
