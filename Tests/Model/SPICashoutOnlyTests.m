//
//  SPICashoutOnlyTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPITransaction.h"
#import "SPIPurchaseHelper.h"
#import "NSString+Util.h"
#import "SPICashout.h"

@interface SPICashoutOnlyTests : XCTestCase

@end

@implementation SPICashoutOnlyTests

- (void)testPurchaseRequestV1_adds_all_fields_to_dataDictionary {
    NSString *posRefId = @"test";
    int amountCents = 10;
    
    SPIPurchaseRequest *request =
    [SPIPurchaseHelper createPurchaseRequest:amountCents
                                  purchaseId:posRefId];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"], posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"purchase_amount"], amountCents);
}

- (void)testRequestPurchase_adds_all_fields_to_dataDictionary {
    NSString *posRefId = @"test";
    int amountCents = 10;
    int tipamount = 10;
    int cashamount = 10;
    BOOL promptForCash = true;
    SPIPurchaseRequest *request =
    [SPIPurchaseHelper createPurchaseRequest:posRefId
                              purchaseAmount:amountCents
                                   tipAmount:tipamount
                                  cashAmount:cashamount
                            promptForCashout:promptForCash];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"], posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"purchase_amount"], amountCents);
    XCTAssertEqual([msg getDataIntegerValue:@"tip_amount"], tipamount);
    XCTAssertEqual(
                   [msg getDataBoolValue:@"prompt_for_cashout" defaultIfNotFound:false],
                   promptForCash);
    XCTAssertNotNil([request amountSummary]);
}

- (void)testCashOut_response_can_be_populated {
    NSString *jsonStr = @"{\"data\":{\"account_type\":\"SAVINGS\",\"auth_code\":\"265035\",\"bank_cash_amount\":1200,\"bank_date\":\"17062018\",\"bank_settlement_date\":\"18062018\",\"bank_time\":\"170950\",\"card_entry\":\"EMV_INSERT\",\"cash_amount\":1200,\"currency\":\"AUD\",\"customer_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 17JUN18   17:09\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180617000151\\r\\nDebit(I)         SAV\\r\\nCARD............2797\\r\\nAUTH          265035\\r\\n\\r\\nCASH        AUD10.00\\r\\nSURCHARGE    AUD2.00\\r\\nTOTAL       AUD12.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n  *CUSTOMER COPY*\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"customer_receipt_printed\":true,\"expiry_date\":\"0722\",\"host_response_code\":\"000\",\"host_response_text\":\"APPROVED\",\"informative_text\":\"                \",\"masked_pan\":\"............2797\",\"merchant_acquirer\":\"EFTPOS FROM WESTPAC\",\"merchant_addr\":\"213 Miller Street\",\"merchant_city\":\"Sydney\",\"merchant_country\":\"Australia\",\"merchant_id\":\"22341845\",\"merchant_name\":\"Merchant4\",\"merchant_postcode\":\"2060\",\"merchant_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 17JUN18   17:09\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180617000151\\r\\nDebit(I)         SAV\\r\\nCARD............2797\\r\\nAUTH          265035\\r\\n\\r\\nCASH        AUD10.00\\r\\nSURCHARGE    AUD2.00\\r\\nTOTAL       AUD12.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"merchant_receipt_printed\":true,\"online_indicator\":\"Y\",\"pos_ref_id\":\"launder-18-06-2018-03-09-17\",\"rrn\":\"180617000151\",\"scheme_name\":\"Debit\",\"stan\":\"000151\",\"success\":true,\"surcharge_amount\":200,\"terminal_id\":\"100312348845\",\"terminal_ref_id\":\"12348845_18062018031010\",\"transaction_type\":\"CASH\"},\"datetime\":\"2018-06-18T03:10:10.580\",\"event\":\"cash_response\",\"id\":\"cshout4\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPICashoutOnlyResponse *response  = [[SPICashoutOnlyResponse alloc] initWithMessage:msg];
    XCTAssertTrue([[response getRRN] isEqualToString:@"180617000151"]);
    XCTAssertEqual([response getCashoutAmount], 1200);
    XCTAssertEqual([response getBankNonCashAmount], 0);
    XCTAssertEqual([response getBankCashAmount] ,1200);
    XCTAssertNotNil([response getCustomerReceipt]);
    XCTAssertTrue([[response getResponseText] isEqualToString:@"APPROVED"]);
    XCTAssertTrue([[response getResponseCode] isEqualToString:@"000"]);
    XCTAssertTrue([[response getTerminalReferenceId] isEqualToString:@"12348845_18062018031010"]);
    XCTAssertTrue([[response getAccountType] isEqualToString:@"SAVINGS"]);
    XCTAssertTrue([[response getBankDate] isEqualToString:@"17062018"]);
    XCTAssertNotNil([response getMerchantReceipt]);
    XCTAssertTrue([[response getBankTime] isEqualToString:@"170950"]);
    XCTAssertTrue([[response getMaskedPan] isEqualToString:@"............2797"]);
    XCTAssertTrue([[response getTerminalId] isEqualToString:@"100312348845"]);
    XCTAssertTrue([[response getAuthCode] isEqualToString:@"265035"]);
    XCTAssertEqual([response wasCustomerReceiptPrinted], true);
    XCTAssertEqual([response wasMerchantReceiptPrinted], true);

}

@end
