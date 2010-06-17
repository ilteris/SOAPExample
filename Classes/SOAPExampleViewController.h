//
//  SOAPExampleViewController.h
//  SOAPExample
//
//  Created by freelancer on 6/15/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOAPExampleViewController : UIViewController 
{

	NSXMLParser *xmlParser;
	NSMutableData *webData;
	NSMutableString *soapResults;
	BOOL recordResults;
}

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSMutableString *soapResults;

-(IBAction)buttonClick:(id)sender;

@end

