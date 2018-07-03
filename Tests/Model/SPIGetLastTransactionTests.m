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
    XCTAssertNotNil(response.getPosRefId);
}

- (void)testGlt_response_can_be_populated {
    NSString *jsonStr = @"{\"data\":{\"account_type\":\"CREDIT\",\"auth_code\":\"328885\",\"bank_date\":\"18062018\",\"bank_noncash_amount\":1000,\"bank_settlement_date\":\"18062018\",\"bank_time\":\"000145\",\"card_entry\":\"EMV_CTLS\",\"currency\":\"AUD\",\"customer_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 18JUN18   00:01\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180618000149\\r\\nMasterCard      \\r\\nMastercard(C)     CR\\r\\nCARD............2797\\r\\nAID   A0000000041010\\r\\nTVR       0000000000\\r\\nAUTH          328885\\r\\n\\r\\nPURCHASE    AUD10.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n*DUPLICATE  RECEIPT*\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"customer_receipt_printed\":false,\"emv_actioncode\":\"ARP\",\"emv_actioncode_values\":\"688E386C083F4E690012\",\"emv_pix\":\"1010\",\"emv_rid\":\"A000000004\",\"emv_tsi\":\"E800\",\"emv_tvr\":\"0000000000\",\"expiry_date\":\"0722\",\"host_response_code\":\"000\",\"host_response_text\":\"APPROVED\",\"informative_text\":\"                \",\"masked_pan\":\"............2797\",\"merchant_acquirer\":\"EFTPOS FROM WESTPAC\",\"merchant_addr\":\"213 Miller Street\",\"merchant_city\":\"Sydney\",\"merchant_country\":\"Australia\",\"merchant_id\":\"22341845\",\"merchant_name\":\"Merchant4\",\"merchant_postcode\":\"2060\",\"merchant_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 18JUN18   00:01\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180618000149\\r\\nMasterCard      \\r\\nMastercard(C)     CR\\r\\nCARD............2797\\r\\nAID   A0000000041010\\r\\nTVR       0000000000\\r\\nAUTH          328885\\r\\n\\r\\nPURCHASE    AUD10.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n*DUPLICATE  RECEIPT*\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"merchant_receipt_printed\":false,\"online_indicator\":\"Y\",\"pos_ref_id\":\"kebab-18-06-2018-00-01-45\",\"purchase_amount\":1000,\"rrn\":\"180618000149\",\"scheme_app_name\":\"MasterCard\",\"scheme_name\":\"MasterCard\",\"stan\":\"000149\",\"success\":true,\"terminal_id\":\"100312348845\",\"terminal_ref_id\":\"12348845_18062018003735\",\"tip_amount\":0,\"transaction_type\":\"PURCHASE\"},\"datetime\":\"2018-06-18T00:37:35.023\",\"event\":\"last_transaction\",\"id\":\"glt17\"}";
    
    NSDictionary *jsonObject = [NSJSONSerialization
                                JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                options:0
                                error:nil];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPIGetLastTransactionResponse *response = [[SPIGetLastTransactionResponse alloc] initWithMessage:msg];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    XCTAssertTrue([[response getRRN] isEqualToString:@"180618000149"]);
    XCTAssertTrue([response wasRetrievedSuccessfully]);
    XCTAssertFalse([response wasOperationInProgressError]);
    XCTAssertFalse([response isWaitingForSignatureResponse]);
    XCTAssertFalse([response isWaitingForAuthCode]);
    XCTAssertFalse([response isStillInProgress:@"kebab-18-06-2018-00-01-45"]);
    XCTAssertTrue([response wasSuccessfulTx]);
    XCTAssertEqual([response getSuccessState], SPIMessageSuccessStateSuccess);
    XCTAssertTrue([[response getTxType] isEqualToString:@"PURCHASE"]);
    XCTAssertTrue([[response getPosRefId] isEqualToString:@"kebab-18-06-2018-00-01-45"]);
    XCTAssertTrue([[response getSchemeApp] isEqualToString:@"MasterCard"]);
    XCTAssertTrue([[response getSchemeName] isEqualToString:@"MasterCard"]);
    XCTAssertEqual([response getAmount], 1000);
    XCTAssertEqual([response getTransactionAmount], 0);
    XCTAssertTrue([[response getBankDateTimeString] isEqualToString:@"18062018000145"]);
    XCTAssertTrue([[response getResponseText] isEqualToString:@"APPROVED"]);
    XCTAssertTrue([[response getResponseCode] isEqualToString:@"000"]);
#pragma clang diagnostic pop
}

@end
