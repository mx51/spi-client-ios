//
//  SPIPayAtTableConfigTests.m
//  Tests
//
//  Created by Metin Avci on 14/5/19.
//  Copyright © 2019 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPayAtTable.h"

@interface SPIPayAtTableConfigTests : XCTestCase

@end

@implementation SPIPayAtTableConfigTests

- (void)testSetPayAtTableEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.payAtTableEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.payAtTableEnabled, [msg getDataBoolValue:@"pay_at_table_enabled" defaultIfNotFound:false]);
}

- (void)testSetOperatorIdEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.operatorIdEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.operatorIdEnabled, [msg getDataBoolValue:@"operator_id_enabled" defaultIfNotFound:false]);
}

- (void)testSetSplitByAmountEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.splitByAmountEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.splitByAmountEnabled, [msg getDataBoolValue:@"split_by_amount_enabled" defaultIfNotFound:false]);
}

- (void)testSetEqualSplitEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.equalSplitEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.equalSplitEnabled, [msg getDataBoolValue:@"equal_split_enabled" defaultIfNotFound:false]);
}

- (void)testSetTippingEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.tippingEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.tippingEnabled, [msg getDataBoolValue:@"tipping_enabled" defaultIfNotFound:false]);
}

- (void)testSetSummaryReportEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.summaryReportEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.summaryReportEnabled, [msg getDataBoolValue:@"summary_report_enabled" defaultIfNotFound:false]);
}

- (void)testSetLabelPayButton {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.labelPayButton = @"PAT";
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertTrue([config.labelPayButton isEqualToString:[msg getDataStringValue:@"pay_button_label"]]);
}

- (void)testSetLabelOperatorId {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.labelOperatorId = @"12";
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertTrue([config.labelOperatorId isEqualToString:[msg getDataStringValue:@"operator_id_label"]]);
}

- (void)testSetLabelTableId {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.labelTableId = @"12";
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertTrue([config.labelTableId isEqualToString:[msg getDataStringValue:@"table_id_label"]]);
}

- (void)testSetAllowedOperatorIds {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    NSArray<NSString *> *allowedOperatorIds = [NSArray arrayWithObjects:@"1", @"2", nil];
    config.allowedOperatorIds = allowedOperatorIds;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.allowedOperatorIds, [msg getDataArrayValue:@"operator_id_list"]);
    XCTAssertEqual(config.allowedOperatorIds.count, 2);
}

- (void)testSetTableRetrievalEnabled {
    SPIPayAtTableConfig *config = [[SPIPayAtTableConfig alloc] init];
    config.tableRetrievalEnabled = true;
    
    SPIMessage *msg = [[SPIMessage alloc] init];
    msg = [config toMessage:@"111"];
    XCTAssertEqual(config.tableRetrievalEnabled, [msg getDataBoolValue:@"table_retrieval_enabled" defaultIfNotFound:false]);
}

@end
