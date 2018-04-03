//
//  SPIGetLastTransactionResponseTest.m
//  SPIClient-iOSTests
//
//  Created by Yoo-Jin Lee on 2018-02-05.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIPurchase.h"
#import "SPIMessage.h"

@interface SPIGetLastTransactionResponseTest : XCTestCase

@end

@implementation SPIGetLastTransactionResponseTest

- (void)testSPIGetLastTransactionResponse {
    SPIMessage *message  = [[SPIMessage alloc] initWithMessageId:@"pur" eventName:SPIPurchaseResponseKey data:@{@"account_type":@"CREDIT", @"amount_purchase":@123, @"amount_transaction_type":@"123", @"auth_code":@"653230", @"bank_date":@"07092017", @"bank_time":@"152137", @"bank_settlement_date":@"21102017", @"card_entry":@"EMV_INSERT", @"currency":@"AUD", @"emv_actioncode":@"TC", @"emv_actioncode_values":@"DE4253B339CC9253", @"emv_pix":@"1010", @"emv_rid":@"A000000003", @"emv_tsi":@"F800", @"emv_tvr":@"0080008000", @"expiry_date":@"1117", @"host_response_code":@"000", @"host_response_text":@"SPIPROVED", @"informative_text":@"                ", @"masked_pan":@"............0794", @"merchant_acquirer":@"EFTPOS FROM BANK", @"merchant_addr":@"275 Kent St", @"merchant_city":@"Sydney", @"merchant_country":@"Australia", @"merchant_id":@"02447508", @"merchant_name":@"VAAS Product 4", @"merchant_postcode":@"2000", @"online_indicator":@"Y", @"scheme_app_name":@"Visa Credit", @"scheme_name":@"Visa", @"stan":@"000212", @"rrn":@"1517826749", @"success":@YES, @"terminal_id":@"100381990118", @"transaction_type":@"PURCHASE", @"customer_receipt":@"EFTPOS FROM BANK\r\nVAAS Product"} needsEncryption:YES];
    SPIGetLastTransactionResponse *response = [[SPIGetLastTransactionResponse alloc] initWithMessage:message];
    XCTAssertNotNil(response.bankDate);
}

@end
