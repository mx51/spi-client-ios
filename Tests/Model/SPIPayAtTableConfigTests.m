//
//  SPIPayAtTableConfigTests.m
//  Tests
//
//  Created by Metin Avci on 14/5/19.
//  Copyright © 2019 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPayAtTable.h"

@interface SPIPayAtTableConfigTests : XCTestCase

@end

@implementation SPIPayAtTableConfigTests

- (void)testPayAtTableEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.payAtTableEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // arrange
    XCTAssertEqual(config.payAtTableEnabled, [msg getDataBoolValue:@"pay_at_table_enabled" defaultIfNotFound:false]);
}

- (void)testOperatorIdEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.operatorIdEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertEqual(config.operatorIdEnabled, [msg getDataBoolValue:@"operator_id_enabled" defaultIfNotFound:false]);
}

- (void)testSplitByAmountEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.splitByAmountEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertEqual(config.splitByAmountEnabled, [msg getDataBoolValue:@"split_by_amount_enabled" defaultIfNotFound:false]);
}

- (void)testEqualSplitEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.equalSplitEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertEqual(config.equalSplitEnabled, [msg getDataBoolValue:@"equal_split_enabled" defaultIfNotFound:false]);
}

- (void)testTippingEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.tippingEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertEqual(config.tippingEnabled, [msg getDataBoolValue:@"tipping_enabled" defaultIfNotFound:false]);
}

- (void)testSummaryReportEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.summaryReportEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertEqual(config.summaryReportEnabled, [msg getDataBoolValue:@"summary_report_enabled" defaultIfNotFound:false]);
}

- (void)testLabelPayButton_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.labelPayButton = @"PAT";
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertTrue([config.labelPayButton isEqualToString:[msg getDataStringValue:@"pay_button_label"]]);
}

- (void)testLabelOperatorId_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.labelOperatorId = @"12";
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertTrue([config.labelOperatorId isEqualToString:[msg getDataStringValue:@"operator_id_label"]]);
}

- (void)testLabelTableId_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.labelTableId = @"12";
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertTrue([config.labelTableId isEqualToString:[msg getDataStringValue:@"table_id_label"]]);
}

- (void)testAllowedOperatorIds_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    NSArray<NSString *> *allowedOperatorIds = [NSArray arrayWithObjects:@"1", @"2", nil];
    config.allowedOperatorIds = allowedOperatorIds;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // assert
    XCTAssertEqual(config.allowedOperatorIds, [msg getDataArrayValue:@"operator_id_list"]);
    XCTAssertEqual(config.allowedOperatorIds.count, 2);
}

- (void)testTableRetrievalEnabled_OnValidRequest_IsSet {
    // arrange
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.tableRetrievalEnabled = true;
    SPIMessage *msg = [[SPIMessage alloc] init];
    
    // act
    msg = [config toMessage:@"111"];
    
    // asserty
    XCTAssertEqual(config.tableRetrievalEnabled, [msg getDataBoolValue:@"table_retrieval_enabled" defaultIfNotFound:false]);
}

@end
