//
//  SPICashoutOnlyTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPITransaction.h"
#import "SPIPurchaseHelper.h"
#import "NSString+Util.h"
#import "SPICashout.h"

@interface SPICashoutOnlyTests : XCTestCase

@end

@implementation SPICashoutOnlyTests

- (void)testCashoutOnlyRequest_OnValidRequestWithTransactionsOptions_ReturnObjects {
    // arrange
    static NSString *posRefId =@"test";
    static NSUInteger amountCents = 1000;
    static NSUInteger surchargeAmount = 100;
    static NSString *receiptHeader =@"test";
    static NSString *receiptFooter =@"test";
    
    SPIConfig *config = [[SPIConfig alloc] init];
    [config setPrintMerchantCopy:true];
    [config setPromptForCustomerCopyOnEftpos:false];
    [config setSignatureFlowOnEftpos:true];
    
    SPITransactionOptions *options = [[SPITransactionOptions alloc] init];
    [options setCustomerReceiptHeader:receiptHeader];
    [options setCustomerReceiptFooter:receiptFooter];
    [options setMerchantReceiptHeader:receiptHeader];
    [options setMerchantReceiptFooter:receiptFooter];
    
    SPICashoutOnlyRequest *request = [[SPICashoutOnlyRequest alloc] initWithAmountCents:amountCents posRefId:posRefId];
    [request setSurchargeAmount:surchargeAmount];
    [request setConfig:config];
    [request setOptions:options];
    
    // act
    SPIMessage *msg = [request toMessage];
    
    // assert
    XCTAssertTrue([request.posRefId isEqualToString:posRefId]);
    XCTAssertEqual(amountCents, request.cashoutAmount);
    XCTAssertTrue([msg getDataBoolValue:@"print_merchant_copy" defaultIfNotFound:false]);
    XCTAssertFalse([msg getDataBoolValue:@"prompt_for_customer_copy" defaultIfNotFound:false]);
    XCTAssertTrue([msg getDataBoolValue:@"print_for_signature_required_transactions" defaultIfNotFound:false]);
    XCTAssertTrue([[msg getDataStringValue:@"customer_receipt_header"] isEqualToString:receiptHeader]);
    XCTAssertTrue([[msg getDataStringValue:@"customer_receipt_footer"] isEqualToString:receiptFooter]);
    XCTAssertTrue([[msg getDataStringValue:@"merchant_receipt_header"] isEqualToString:receiptHeader]);
    XCTAssertTrue([[msg getDataStringValue:@"merchant_receipt_footer"] isEqualToString:receiptFooter]);
}

- (void)testCashoutOnlyResponse_OnValidResponse_ReturnObjects {
    // arrange
    static NSString *jsonStr = @"{\"data\":{\"account_type\":\"SAVINGS\",\"auth_code\":\"265035\",\"bank_cash_amount\":1200,\"bank_date\":\"17062018\",\"bank_settlement_date\":\"18062018\",\"bank_time\":\"170950\",\"card_entry\":\"EMV_INSERT\",\"cash_amount\":1200,\"currency\":\"AUD\",\"customer_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 17JUN18   17:09\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180617000151\\r\\nDebit(I)         SAV\\r\\nCARD............2797\\r\\nAUTH          265035\\r\\n\\r\\nCASH        AUD10.00\\r\\nSURCHARGE    AUD2.00\\r\\nTOTAL       AUD12.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n  *CUSTOMER COPY*\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"customer_receipt_printed\":true,\"expiry_date\":\"0722\",\"host_response_code\":\"000\",\"host_response_text\":\"APPROVED\",\"informative_text\":\"                \",\"masked_pan\":\"............2797\",\"merchant_acquirer\":\"EFTPOS FROM WESTPAC\",\"merchant_addr\":\"213 Miller Street\",\"merchant_city\":\"Sydney\",\"merchant_country\":\"Australia\",\"merchant_id\":\"22341845\",\"merchant_name\":\"Merchant4\",\"merchant_postcode\":\"2060\",\"merchant_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 17JUN18   17:09\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180617000151\\r\\nDebit(I)         SAV\\r\\nCARD............2797\\r\\nAUTH          265035\\r\\n\\r\\nCASH        AUD10.00\\r\\nSURCHARGE    AUD2.00\\r\\nTOTAL       AUD12.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"merchant_receipt_printed\":true,\"online_indicator\":\"Y\",\"pos_ref_id\":\"launder-18-06-2018-03-09-17\",\"rrn\":\"180617000151\",\"scheme_name\":\"Debit\",\"stan\":\"000151\",\"success\":true,\"surcharge_amount\":200,\"terminal_id\":\"100312348845\",\"terminal_ref_id\":\"12348845_18062018031010\",\"transaction_type\":\"CASH\"},\"datetime\":\"2018-06-18T03:10:10.580\",\"event\":\"cash_response\",\"id\":\"cshout4\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    
    // act
    SPICashoutOnlyResponse *response  = [[SPICashoutOnlyResponse alloc] initWithMessage:msg];
    
    // assert
    XCTAssertTrue([[response getRRN] isEqualToString:@"180617000151"]);
    XCTAssertEqual(1200, [response getCashoutAmount]);
    XCTAssertEqual(0, [response getBankNonCashAmount]);
    XCTAssertEqual(1200, [response getBankCashAmount]);
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
    XCTAssertTrue([response wasCustomerReceiptPrinted]);
    XCTAssertTrue([response wasMerchantReceiptPrinted]);
}

@end
