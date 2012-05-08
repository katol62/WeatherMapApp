
#import <Foundation/Foundation.h>

@interface CCommunicator : NSObject {
	NSMutableData *receivedData;
}

@property(nonatomic,retain) NSMutableData *receivedData;

+(CCommunicator *) shared;
-(void)request:(NSString *)url WithData:(NSDictionary *)data Method:(NSString *)method;
-(void)request:(NSString *)url WithDataString:(NSString *)dataString Method:(NSString *)method;
- (NSString *)urlEncodeValue:(NSString *)str;

@end
