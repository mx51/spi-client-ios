//
//  SPIRefundTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPITransaction.h"
#import "SPIPurchaseHelper.h"
#import "NSDate+Util.h"
#import "SPIClient.h"

@interface SPIRefundTests : XCTestCase

@end

@implementation SPIRefundTests

- (void)testPopulateRefundRequest {
    NSString *posRefId = @"test";
    int amountCents = 10;
    SPIRefundRequest *request = [SPIPurchaseHelper createRefundRequest:amountCents purchaseId:posRefId];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"],posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"refund_amount"],amountCents);
}

- (void)testPopulateRefundRequestWithSuppressMerchantPassword {
    NSString *posRefId = @"test";
    int amountCents = 10;
    BOOL isSuppressMerchantPassword = true;
    SPIRefundRequest *request = [SPIPurchaseHelper createRefundRequest:amountCents purchaseId:posRefId suppressMerchantPassword:suppressMerchantPassword];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"],posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"refund_amount"],amountCents);
    XCTAssertEqual([msg getDataIntegerValue:@"suppress_merchant_password"],isSuppressMerchantPassword);
}

- (void)testPopulateRefundResponse {
    NSString *jsonStr = @"{\"data\":{\"account_type\":\"SAVINGS\",\"auth_code\":\"856550\",\"bank_date\":\"17062018\",\"bank_noncash_amount\":1000,\"bank_settlement_date\":\"18062018\",\"bank_time\":\"204249\",\"card_entry\":\"EMV_INSERT\",\"currency\":\"AUD\",\"customer_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 17JUN18   20:42\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180617000148\\r\\nDebit(I)         SAV\\r\\nCARD............2797\\r\\nAUTH          856550\\r\\n\\r\\nREFUND      AUD10.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n  *CUSTOMER COPY*\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"customer_receipt_printed\":true,\"expiry_date\":\"0722\",\"host_response_code\":\"000\",\"host_response_text\":\"APPROVED\",\"informative_text\":\"                \",\"masked_pan\":\"............2797\",\"merchant_acquirer\":\"EFTPOS FROM WESTPAC\",\"merchant_addr\":\"213 Miller Street\",\"merchant_city\":\"Sydney\",\"merchant_country\":\"Australia\",\"merchant_id\":\"22341845\",\"merchant_name\":\"Merchant4\",\"merchant_postcode\":\"2060\",\"merchant_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 17JUN18   20:42\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180617000148\\r\\nDebit(I)         SAV\\r\\nCARD............2797\\r\\nAUTH          856550\\r\\n\\r\\nREFUND      AUD10.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"merchant_receipt_printed\":true,\"online_indicator\":\"Y\",\"pos_ref_id\":\"yuck-17-06-2018-20-42-51\",\"refund_amount\":1000,\"rrn\":\"180617000148\",\"scheme_name\":\"Debit\",\"stan\":\"000148\",\"success\":true,\"terminal_id\":\"100312348845\",\"terminal_ref_id\":\"12348845_17062018204324\",\"transaction_type\":\"REFUND\"},\"datetime\":\"2018-06-17T20:43:24.145\",\"event\":\"refund_response\",\"id\":\"refund3\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPIRefundResponse *response  = [[SPIRefundResponse alloc] initWithMessage:msg];
    XCTAssertTrue([[response getRRN] isEqualToString:@"180617000148"]);
    XCTAssertEqual([response getRefundAmount],1000);
    XCTAssertNotNil([response getCustomerReceipt]);
    XCTAssertTrue([[response getResponseText] isEqualToString:@"APPROVED"]);
    XCTAssertTrue([[[response getSettlementDate] toString] isEqualToString:@"2018-06-18T00:00:00.000"]);
    XCTAssertTrue([[response getResponseCode] isEqualToString:@"000"]);
    XCTAssertTrue([[response getTerminalReferenceId] isEqualToString:@"12348845_17062018204324"]);
    XCTAssertTrue([[response getCardEntry] isEqualToString:@"EMV_INSERT"]);
    XCTAssertTrue([[response getAccountType] isEqualToString:@"SAVINGS"]);
    XCTAssertTrue([[response getBankDate] isEqualToString:@"17062018"]);
    XCTAssertTrue([[response getBankTime] isEqualToString:@"204249"]);
    XCTAssertNotNil([response getMerchantReceipt]);
    XCTAssertTrue([[response getMaskedPan] isEqualToString:@"............2797"]);
    XCTAssertTrue([[response getTerminalId] isEqualToString:@"100312348845"]);
    XCTAssertEqual([response wasCustomerReceiptPrinted], true);
    XCTAssertEqual([response wasMerchantReceiptPrinted], true);
}

@end
