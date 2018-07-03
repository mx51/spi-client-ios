//
//  SPIPosInfoTests.m
//  Tests
//
//  Created by Mike Gouline on 4/7/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPosInfo.h"
#import "SPIClient.h"
#import "SPIClient+Internal.h"
#import "SPITestUtils.h"

@interface SPIPosInfoTests : XCTestCase

@end

@implementation SPIPosInfoTests

- (void)testPopulateSetPosInfoRequest {
    NSString *version = @"1.5.7";
    NSString *vendorId = @"acmecorp";
    NSString *libraryLanguage = @"ios-objc";
    NSString *libraryVersion = @"2.3.0";
    NSString *otherSystemName = @"iOS";
    NSString *otherSystemVersion = @"10.0";
    
    SPISetPosInfoRequest *request = [[SPISetPosInfoRequest alloc] initWithVersion:version
                                                                         vendorId:vendorId
                                                                  libraryLanguage:libraryLanguage
                                                                   libraryVersion:libraryVersion
                                                                        otherInfo:@{
                                                                                    @"system_name": otherSystemName,
                                                                                    @"system_version": otherSystemVersion
                                                                                    }];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertTrue([version isEqualToString:[msg getDataStringValue:@"pos_version"]]);
    XCTAssertTrue([vendorId isEqualToString:[msg getDataStringValue:@"pos_vendor_id"]]);
    XCTAssertTrue([libraryLanguage isEqualToString:[msg getDataStringValue:@"library_language"]]);
    XCTAssertTrue([libraryVersion isEqualToString:[msg getDataStringValue:@"library_version"]]);
    XCTAssertTrue([otherSystemName isEqualToString:[msg getDataDictionaryValue:@"other_info"][@"system_name"]]);
    XCTAssertTrue([otherSystemVersion isEqualToString:[msg getDataDictionaryValue:@"other_info"][@"system_version"]]);
}

- (void)testPopulateSetPosInfoResponse {
    NSString *jsonStr = @"{\"data\":{\"success\":true,\"error_reason\":\"reason1\",\"error_detail\":\"detail2\"}}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPISetPosInfoResponse *response  = [[SPISetPosInfoResponse alloc] initWithMessage:msg];
    XCTAssertTrue(response.isSuccess);
    XCTAssertTrue([@"reason1" isEqualToString:[response getErrorReason]]);
    XCTAssertTrue([@"detail2" isEqualToString:[response getErrorDetail]]);
}

- (void)testHandleSetPosInfoResponse {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    SPISecrets *secrets = client.secrets;
    SPIMessageStamp *stamp = [[SPIMessageStamp alloc] initWithPosId:@"POS" secrets:secrets serverTimeDelta:0];
    
    client.state.status = SPIStatusPairedConnected;

    XCTAssertTrue(!client.hasSetPosInfo);
    
    [SPITestUtils waitForAsync:1];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:@{
                                                         @"event": @"set_pos_info_response",
                                                         @"id": @"1",
                                                         @"datetime": @"2017-11-20T02:32:11.699",
                                                         @"data": @{
                                                                 @"success": @NO,
                                                                 @"error_reason": @"",
                                                                 @"error_detail": @""
                                                                 }
                                                         }];
    [client onSpiMessageReceived:[msg toJson:stamp]];
    
    [SPITestUtils waitForAsync:1];
    
    XCTAssertTrue(!client.hasSetPosInfo);
    
    msg = [[SPIMessage alloc] initWithDict:@{
                                             @"event": @"set_pos_info_response",
                                             @"id": @"2",
                                             @"datetime": @"2017-11-20T02:33:11.699",
                                             @"data": @{
                                                     @"success": @YES,
                                                     @"error_reason": @"",
                                                     @"error_detail": @""
                                                     }
                                             }];
    [client onSpiMessageReceived:[msg toJson:stamp]];
    
    [SPITestUtils waitForAsync:1];
    
    XCTAssertTrue(client.hasSetPosInfo);
}

@end
