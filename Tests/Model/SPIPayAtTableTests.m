//
//  SPIPayAtTableTests.m
//  Tests
//
//  Created by Metin Avci on 27/5/19.
//  Copyright © 2019 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPayAtTable.h"
#import "SPITestUtils.h"

@interface SPIPayAtTableTests : XCTestCase

@end

@implementation SPIPayAtTableTests

- (void)testBillStatusResponse_OnValidResponse_ReturnObjects {
    // arrange
    SPIBillStatusResponse *billStatusResponse = [[SPIBillStatusResponse alloc] init];
    billStatusResponse.billId = @"1";
    billStatusResponse.operatorId = @"12";
    billStatusResponse.tableId = @"2";
    billStatusResponse.outstandingAmount = 10000;
    billStatusResponse.totalAmount = 20000;
    billStatusResponse.billData = @"Ww0KICAgICAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgICAgICAgInBheW1lbnRfdHlwZSI6ImNhc2giLCAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICJwYXltZW50X3N1bW1hcnkiOnsgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICJiYW5rX2RhdGUiOiIxMjAzMjAxOCIsICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAgICAiYmFua190aW1lIjoiMDc1NDAzIiwgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgInB1cmNoYXNlX2Ftb3VudCI6MTIzNCwgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgInRlcm1pbmFsX2lkIjoiUDIwMTUwNzEiLCAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAgICAidGVybWluYWxfcmVmX2lkIjoic29tZSBzdHJpbmciLCAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgInRpcF9hbW91bnQiOjAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICB9LA0KICAgICAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgICAgICAgInBheW1lbnRfdHlwZSI6ImNhcmQiLCAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICJwYXltZW50X3N1bW1hcnkiOnsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgImFjY291bnRfdHlwZSI6IkNIRVFVRSIsICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICJhdXRoX2NvZGUiOiIwOTQyMjQiLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICJiYW5rX2RhdGUiOiIxMjAzMjAxOCIsICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICJiYW5rX3RpbWUiOiIwNzU0NDciLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiaG9zdF9yZXNwb25zZV9jb2RlIjoiMDAwIiwgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgImhvc3RfcmVzcG9uc2VfdGV4dCI6IkFQUFJPVkVEIiwgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgIm1hc2tlZF9wYW4iOiIuLi4uLi4uLi4uLi40MzUxIiwgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAgICAicHVyY2hhc2VfYW1vdW50IjoxMjM0LCAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICJycm4iOiIxODAzMTIwMDAzNzkiLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICJzY2hlbWVfbmFtZSI6IkFtZXgiLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgInRlcm1pbmFsX2lkIjoiMTAwNFAyMDE1MDcxIiwgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgInRlcm1pbmFsX3JlZl9pZCI6InNvbWUgc3RyaW5nIiwgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgInRpcF9hbW91bnQiOjEyMzQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICBd";
    
    // act
    SPIMessage *msg = [billStatusResponse toMessage:@"d"];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString: @"bill_details"]);
    XCTAssertEqual(billStatusResponse.billId, [msg getDataStringValue: @"bill_id"]);
    XCTAssertEqual(billStatusResponse.tableId, [msg getDataStringValue: @"table_id"]);
    XCTAssertEqual(billStatusResponse.outstandingAmount, [msg getDataIntegerValue:@"bill_outstanding_amount"]);
    XCTAssertEqual(billStatusResponse.totalAmount, [msg getDataIntegerValue: @"bill_total_amount"]);
    XCTAssertTrue([[billStatusResponse getBillPaymentHistory][0].getTerminalRefId isEqualToString: @"some string"]);
}

- (void)testGetOpenTablesResponse_OnValidResponse_ReturnObjects {
    // arrange
    SPIOpenTablesEntry *openTablesEntry = [[SPIOpenTablesEntry alloc] init];
    openTablesEntry.tableId = @"1";
    openTablesEntry.label = @"1";
    openTablesEntry.outstandingAmount = 2000;
    SPIOpenTablesEntry *openTablesEntry2 = [[SPIOpenTablesEntry alloc] init];
    openTablesEntry2.tableId = @"2";
    openTablesEntry2.label = @"2";
    openTablesEntry2.outstandingAmount = 2500;
    NSMutableArray<SPIOpenTablesEntry *> *openTablesEntries = [NSMutableArray arrayWithObjects:openTablesEntry, openTablesEntry2, nil];
    
    // act
    SPIGetOpenTablesResponse *getOpenTablesResponse = [[SPIGetOpenTablesResponse alloc] init];
    getOpenTablesResponse.openTablesEntries = openTablesEntries;
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [getOpenTablesResponse toMessage:@"111"];
    NSMutableArray *openTablesEntriesJSON = [[NSMutableArray alloc] init];
    for (NSDictionary *item in [msg getDataArrayValue:@"tables"]) {
        SPIOpenTablesEntry *openTablesEntry = [[SPIOpenTablesEntry alloc] initWithDictionary:item];
        [openTablesEntriesJSON addObject:openTablesEntry];
    }
    
    // assert
    XCTAssertEqual(openTablesEntriesJSON.count, getOpenTablesResponse.openTablesEntries.count);
    
    for (NSInteger i = 0; i < 2; i++) {
        SPIOpenTablesEntry *item = getOpenTablesResponse.openTablesEntries[i];
        SPIOpenTablesEntry *item2 = openTablesEntriesJSON[i];
        XCTAssertEqual(item.tableId, item2.tableId);
        XCTAssertEqual(item.label, item2.label);
        XCTAssertEqual(item.outstandingAmount, item2.outstandingAmount);
    }
}

- (void)testGetOpenTables_OnValidResponse_IsSet {
    // arrange
    SPIOpenTablesEntry *openTablesEntry = [[SPIOpenTablesEntry alloc] init];
    openTablesEntry.tableId = @"1";
    openTablesEntry.label = @"1";
    openTablesEntry.outstandingAmount = 2000;
    NSMutableArray<SPIOpenTablesEntry *> *openTablesEntries = [NSMutableArray arrayWithObjects:openTablesEntry, nil];
    
    // act
    SPIGetOpenTablesResponse *getOpenTablesResponse = [[SPIGetOpenTablesResponse alloc] init];
    getOpenTablesResponse.openTablesEntries = openTablesEntries;
    NSMutableArray *openTablesEntriesResponse = [getOpenTablesResponse getOpenTables];
    
    // assert
    XCTAssertEqual(openTablesEntries.count, openTablesEntriesResponse.count);
}

- (void)testGetOpenTables_OnValidResponseNull_IsSet {
    // arrange
    SPIGetOpenTablesResponse *getOpenTablesResponse = [[SPIGetOpenTablesResponse alloc] init];
    
    // act
    NSMutableArray *openTablesEntriesResponse = [getOpenTablesResponse getOpenTables];
    
    // assert
    XCTAssertNotNil(openTablesEntriesResponse);
    XCTAssertNil([getOpenTablesResponse openTablesEntries]);
}

- (void)testBillPaymentFlowEndedResponse_OnValidResponse_ReturnObjects {
    // arrange
    SPISecrets *secrets = [SPITestUtils setTestSecrets:@"" hmacKey:@""];
    NSString *jsonStr = @"{\"message\":{\"data\":{\"bill_id\":\"1554246591041.23\",\"bill_outstanding_amount\":1000,\"bill_total_amount\":1000,\"card_total_amount\":0,\"card_total_count\":0,\"cash_total_amount\":0,\"cash_total_count\":0,\"operator_id\":\"1\",\"table_id\":\"1\"},\"datetime\":\"2019-04-03T10:11:21.328\",\"event\":\"bill_payment_flow_ended\",\"id\":\"C12.4\"}}";
    
    // act
    SPIMessage *msg = [SPIMessage fromJson:jsonStr secrets:secrets];
    SPIBillPaymentFlowEndedResponse *response = [[SPIBillPaymentFlowEndedResponse alloc] initWithMessage:msg];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"bill_payment_flow_ended"]);
    XCTAssertEqual(1000, response.billOutstandingAmount);
    XCTAssertEqual(1000, response.billTotalAmount);
    XCTAssertTrue([response.tableId isEqualToString:@"1"]);
    XCTAssertTrue([response.operatorId isEqualToString:@"1"]);
    XCTAssertEqual(0, response.cardTotalCount);
    XCTAssertEqual(0, response.cardTotalAmount);
    XCTAssertEqual(0, response.cashTotalCount);
    XCTAssertEqual(0, response.cashTotalAmount);
    
    // act
    response = [[SPIBillPaymentFlowEndedResponse alloc] init];
    
    // assert
    XCTAssertNil(response.billId);
    XCTAssertEqual(0, response.billOutstandingAmount);
}

- (void)testSpiPayAtTable_OnValidRequest_ReturnStatus {
    // arrange
    SPIClient *client = [[SPIClient alloc] init];
    
    // act
    SPIPayAtTable *pat = [[SPIPayAtTable alloc] initWithClient:client];
    
    // assert
    XCTAssertNotNil(pat.config);
    
    // act
    pat = [[SPIPayAtTable alloc] init];
    
    // assert
    XCTAssertNil(pat.config);
}

@end
