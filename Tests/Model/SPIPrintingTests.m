//
//  SPIPrinting.m
//  Tests
//
//  Created by Metin Avci on 19/7/19.
//  Copyright © 2019 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPrinting.h"

@interface SPIPrintingTests : XCTestCase

@end

@implementation SPIPrintingTests

- (void)testPrintingRequest {
    SPIPrintingRequest *request = [[SPIPrintingRequest alloc] initWithKey:@"test" payload:@"test"];
    SPIMessage *msg = [request toMessage];
    
    XCTAssertTrue([msg.eventName isEqualToString:@"print"]);
    XCTAssertTrue([[msg getDataStringValue:@"key"] isEqualToString:@"test"]);
    XCTAssertTrue([[msg getDataStringValue:@"payload"] isEqualToString:@"test"]);
}

- (void)testPrintingResponse {
    NSString *jsonStr = @"{\"data\":{\"success\":true},\"datetime\":\"2019-06-14T18:51:00.948\",\"event\":\"print_response\",\"id\":\"C24.0\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPIPrintingResponse *response  = [[SPIPrintingResponse alloc] initWithMessage:msg];
    
    XCTAssertTrue([msg.eventName isEqualToString:@"print_response"]);
    XCTAssertTrue([response isSuccess]);
    XCTAssertTrue([msg.mid isEqualToString:@"C24.0"]);
    XCTAssertTrue([response.getErrorReason isEqualToString:@""]);
    XCTAssertTrue([response.getErrorDetail isEqualToString:@""]);
    XCTAssertTrue([[response getResponseValueWithAttribute:@"error_detail"] isEqualToString:@""]);
}

@end
