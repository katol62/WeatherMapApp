
#import "CCommunicator.h"


static CCommunicator *_inst = nil;

@implementation CCommunicator

@synthesize receivedData;

+(CCommunicator *) shared
{
    if(_inst == nil)
        _inst = [[CCommunicator alloc] init];
    return _inst;
}

-(void)request:(NSString *)url WithDataString:(NSString *)dataString Method:(NSString *)method
{
	
	// Create the request.
	NSMutableURLRequest *theRequest;

	dataString = [self urlEncodeValue:dataString];
	
	if (dataString != nil) {
		if ([method isEqualToString:@"POST"]) {
			
			theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
												timeoutInterval:10.0];
			
			NSData *postData = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
			//NSData *postData = [ NSData dataWithBytes: [ dataString UTF8String ] length: [ dataString length ] ];
			
			//NSData *postData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
			NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
			
			[theRequest setHTTPMethod:method];
			[theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
			[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			//[theRequest setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
			
			//[theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
			[theRequest setHTTPBody:postData]; 
		}
		else {
			
			url = [url stringByAppendingFormat:@"/?%@", dataString];
			
			theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
																	  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
																  timeoutInterval:10.0];
			[theRequest setHTTPMethod:method];
			
		}
	}
	else {
		theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:10.0];
		[theRequest setHTTPMethod:method];
	}

	// create the connection with the request
	// and start loading the data
	// note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		//self.receivedData = [[NSMutableData data] retain];
		self.receivedData = [NSMutableData data];
		
	} else {
		
		// Inform the user that the connection failed.
		
		UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[connectFailMessage show];
		//[connectFailMessage release];
	}
	 
}


-(void)request:(NSString *)url WithData:(NSDictionary *)dict Method:(NSString *)method
{

	// Create the request.
	if ([method isEqualToString:@"GET"]) {
		if (dict != nil) {
			NSMutableArray *array = [NSMutableArray array];
			NSString *add = [NSString stringWithString:@"?"];
			NSEnumerator *keyEnum = [dict keyEnumerator];
			id key;
			
			while ((key = [keyEnum nextObject]))
			{
				id value = [dict objectForKey:key];
				NSString *val = [NSString stringWithFormat:@"%@=%@", key, value];
				//val = [self urlEncodeValue:val];
				[array addObject:val];
			}
			
			NSString *joinedString = [array componentsJoinedByString:@"&"];
			add = [add stringByAppendingString:joinedString];
			//add = [self urlEncodeValue:add];
			url = [url stringByAppendingString:add];
		}
	}
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
					cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
					timeoutInterval:10.0];

	[theRequest setHTTPMethod:method];
	if (dict != nil) {
		if ([method isEqualToString:@"POST"]) {
			NSError *error = nil;
			//NSData *jsonData = [[CJSONSerializer serializer] serializeDictionary:dict error:&error];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options: kNilOptions error:&error];
			NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			//[theRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
			NSString *finalString = [NSString stringWithFormat:@"args=%@", jsonString];
			//finalString = [self urlEncodeValue:finalString];
			[theRequest setHTTPBody:[finalString dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	// create the connection with the request
	// and start loading the data
	// note that the delegate for the NSURLConnection is self, so delegate methods must be defined in this file
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if (theConnection) {
	
		// Create the NSMutableData to hold the received data.
		// receivedData is an instance variable declared elsewhere.
		//self.receivedData = [[NSMutableData data] retain];
		self.receivedData = [NSMutableData data];
	
	} else {
	
		// Inform the user that the connection failed.
	
		UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[connectFailMessage show];
		//[connectFailMessage release];
	}
}


#pragma mark NSURLConnection methods
 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	 // This method is called when the server has determined that it
	 // has enough information to create the NSURLResponse.
	 // It can be called multiple times, for example in the case of a
	 // redirect, so each time we reset the data.
	 // receivedData is an instance variable declared elsewhere.
	[receivedData setLength:0];
}
 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	// Append the new data to receivedData.
	// receivedData is an instance variable declared elsewhere.
 
	[self.receivedData appendData:data];
}
 
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// release the connection, and the data object
	// receivedData is declared as a method instance elsewhere
 
	//[connection release];
	//[receivedData release];
 
	// inform the user
	UIAlertView *didFailWithErrorMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message: @"didFailWithError"  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[didFailWithErrorMessage show];
	//[didFailWithErrorMessage release];
 
	//inform the user
	//NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// do something with the data
	// receivedData is declared as an instance variable elsewhere
	// in this example, convert data (from plist) to a string and then to a dictionary
	NSString *dataString = [[NSString alloc] initWithData: receivedData  encoding: NSUTF8StringEncoding];
	//NSString *dataString = [[NSString alloc] initWithData: receivedData  encoding: NSASCIIStringEncoding];
	
	NSError *error = nil;
	//NSDictionary *items = [[CJSONDeserializer deserializer] deserializeAsDictionary:receivedData error:&error];
	
    NSDictionary *items = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
	NSLog(@"total items: %d", [items count]);
	//NSLog(@"message=%@", [items objectForKey:@"message"]);
	NSLog(@"error: %@", [error localizedDescription]);
	
	//NSString *dataString = [[NSString alloc] initWithData: receivedData  encoding: NSUTF8StringEncoding];
	//NSMutableDictionary *dictionary = [dataString propertyList];
	//[dataString release];
 
	//store data in singleton class for use by other parts of the program
	//SingletonObject *mySharedObject = [SingletonObject sharedSingleton];
	//mySharedObject.aDictionary = dictionary;
 
	//alert the user
	//alert the user
	NSString *message = [[NSString alloc] initWithFormat:@"Succeeded! Received %d bytes of data",[receivedData length]];
	NSLog(@"%@", message);
	NSLog(@"Dictionary:\n%@",items);
	/*
	UIAlertView *finishedLoadingMessage = [[UIAlertView alloc] initWithTitle: @"NSURLConnection " message:message  delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
	[finishedLoadingMessage show];
	[finishedLoadingMessage release];
	[message release];
	 */
	// release the connection, and the data object
	//[connection release];
	//[receivedData release];
	
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
						  //[CGlobals shared].current_request, @"type",
						  items, @"data",
						  nil
						  ];
	[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DATA_PARSED object:nil userInfo:info];	

}

#pragma mark custom 

/*
- (NSString *)urlEncodeValue:(NSString *)str
{
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
	//return [result autorelease];
	return [result];
}
*/
- (NSString *)urlEncodeValue:(NSString *)str
{
    
    //            NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&()*+,;="), kCFStringEncodingUTF8);
    //            return [result autorelease];
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


 
@end
