
#import "CForecastView.h"

static int TAG_BG = 111;

@implementation CForecastView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *bg_image = [UIImage imageNamed:@"bg.png"];
        UIImageView *bg = [[UIImageView alloc] initWithImage:bg_image];
        bg.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        bg.tag = TAG_BG;
        
        [self addSubview:bg];
        
    }
    return self;
}

-(void)update_forecast:(NSMutableArray *)data
{
    int n = [self.subviews count];
    for (int i=n-1; i>=0; i--) {
        UIView *view = [self.subviews objectAtIndex:i];
        if (view.tag != TAG_BG) {
            [view removeFromSuperview];
        }
    }
    
    float startX = 10.0f;
    float startY = 35.0f;
    
    for (int i=0; i<[data count]; i++) {
        NSMutableDictionary *day = [data objectAtIndex:i];
        
        NSMutableArray *weatherIconUrl = [day objectForKey:@"weatherIconUrl"];
        NSMutableDictionary *urlDic = [weatherIconUrl objectAtIndex:0];
        NSString *MyURL = [urlDic objectForKey:@"value"];
        //UIImage *image = [UIImage imageWithContentsOfFile:url];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
        float scale_index = 30 / image.size.height;
        float new_width = image.size.width * scale_index;
        float new_height = image.size.height * scale_index;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:image];
        icon.frame = CGRectMake(startX, startY, new_width, new_height);
        [self addSubview:icon];
        
        startX += icon.frame.size.width + 3;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
