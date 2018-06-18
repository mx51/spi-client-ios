//
//  PongHelperTest.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPingHelper.h"
#import "SPIMessage.h"
@interface PongHelperTest : XCTestCase

@end

@implementation PongHelperTest

- (void)testGeneratePongRequest {
    NSString *testMessageId = @"testId";
    SPIMessage *testMessage = [[SPIMessage alloc] initWithMessageId:testMessageId eventName:@"test" data:nil needsEncryption:false];
    
    SPIMessage *pongMsg = [SPIPongHelper generatePongRequest:testMessage];
    XCTAssertTrue([pongMsg.mid isEqualToString:testMessageId]);
    XCTAssertTrue([pongMsg.eventName isEqualToString:SPIPongKey]);

}
- (void)testGeneratePingRequest {
    SPIMessage *pingMessage = [SPIPingHelper generatePingRequest];

    XCTAssertNotNil(pingMessage.mid);
    XCTAssertTrue([pingMessage.eventName isEqualToString:SPIPingKey]);
}


@end
