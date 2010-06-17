//
//  SOAPExampleViewController.m
//  SOAPExample
//
//  Created by freelancer on 6/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SOAPExampleViewController.h"

@implementation SOAPExampleViewController
@synthesize xmlParser, webData, soapResults;



-(IBAction)buttonClick:(id)sender
{
	NSString *username = [NSString stringWithFormat:@"xx"];
	NSString *password = [NSString stringWithFormat:@""];
	NSString *tracer = [NSString stringWithFormat:@""];
	NSString *symbols = [NSString stringWithFormat:@"aapl"];
	NSString *includeBits = [NSString stringWithFormat:@"true"];

	recordResults = NO;
	/*
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 
							 "<SOAP-ENV:Envelope\n"
							 
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 
												 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 
												 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 
												 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 
							 "<SOAP-ENV:Body>\n"
							 
							 "<GetRealQuote xmlns=\"http://www.xignite.com/services/\">\n"
							 
							 "<Exchange xsi:type=\"xsd:string\">INET</Exchange>\n"
							 
							 "<Symbol xsi:type=\"xsd:string\">AAPL</Symbol>\n"
							 
							 "<IncludeBidAsk xsi:type=\"xsd:boolean\">true</IncludeBidAsk>\n"
							 
							 "</GetRealQuote>\n"
							 
							 "</SOAP-ENV:Body>\n"
							 
							 "</SOAP-ENV:Envelope>\n"];
	
	*/
	
	NSString *soapMessage = [NSString stringWithFormat:
							  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope\n"
							 
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 
							 "<SOAP-ENV:Header>\n"
							 "<Header xmlns=\"http://www.xignite.com/services/\">\n"
							 "<Username xsi:type=\"xsd:string\">xx</Username>\n"
							 "<Password xsi:type=\"xsd:string\"></Password>\n"
							 "<Tracer xsi:type=\"xsd:string\"></Tracer>\n"
							 "</Header>\n"
							 "</SOAP-ENV:Header>\n"
							 
							 "<SOAP-ENV:Body>\n"
							 
							 "<GetRealQuote xmlns=\"http://www.xignite.com/services/\">\n"
							 
							 "<Exchange xsi:type=\"xsd:string\">INET</Exchange>\n"
							 
							 "<Symbol xsi:type=\"xsd:string\">AAPL</Symbol>\n"
							 
							 "<IncludeBidAsk xsi:type=\"xsd:boolean\">true</IncludeBidAsk>\n"
							 
							 "</GetRealQuote>\n"
							 
							 "</SOAP-ENV:Body>\n"
							 
							 "</SOAP-ENV:Envelope>\n"];

	
	NSLog(@"%@", soapMessage);

	
	NSURL *url = [NSURL URLWithString:@"http://www.xignite.com/xRealTime.asmx"];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue:@"http://www.xignite.com/services/GetRealQuote" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	

	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	
	if(theConnection)
	{
		webData = [[NSMutableData data] retain];

	}
	else 
	{
		NSLog(@"theConnection is null");
	}

}


-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	[webData setLength:0];
	 NSHTTPURLResponse * httpResponse;
	
	httpResponse = (NSHTTPURLResponse *) response;

	NSLog(@"HTTP error %zd", (ssize_t) httpResponse.statusCode);

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[webData appendData:data];
	//NSLog(@"webdata: %@", data);
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
	NSLog(@"error with the connection");
	[connection release];
	[webData release];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received bytes %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"xml %@",theXML);
	[theXML release];
	
	if(xmlParser)
	{
		[xmlParser release];
	}
	
	xmlParser = [[NSXMLParser alloc] initWithData:webData];
	[xmlParser setDelegate:self];
	[xmlParser setShouldResolveExternalEntities:YES];
	
	[xmlParser parse];


	[connection release];
	[webData release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{



	if([elementName isEqualToString:@"Symbol"] || [elementName isEqualToString:@"Last"] || [elementName isEqualToString:@"Time"] )
	{
			if(!soapResults)
		{
			soapResults = [[NSMutableString alloc]init];
		}
		recordResults = YES;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(recordResults)
	{
		[soapResults appendString:string];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"Symbol"] || [elementName isEqualToString:@"Last"] || [elementName isEqualToString:@"Time"] )
	{
		recordResults = NO;
		NSLog(@"%@", soapResults);
		[soapResults release];
		soapResults = nil;
	}
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[xmlParser release];
    [super dealloc];
}

@end
