//
//  SPIPurchaseTest.m
//  Tests
//
//  Created by Amir Kamali on 13/6/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPITransaction.h"
#import "SPIPurchaseHelper.h"
#import "NSDate+Util.h"
#import "SPIClient.h"
#import "SPIClient+Internal.h"
#import "SPITestUtils.h"

@interface SPITransactionTests : XCTestCase

@end

@implementation SPITransactionTests

- (void)testPopulatePurchaseRequest_short {
    NSString *posRefId = @"test";
    int amountCents = 10;
    
    SPIPurchaseRequest *request = [SPIPurchaseHelper createPurchaseRequest:amountCents purchaseId:posRefId];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"], posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"purchase_amount"], amountCents);
}

- (void)testPopulatePurchaseRequest_full {
    NSString *posRefId = @"test";
    int amountCents = 10;
    int tipamount = 10;
    int cashamount = 10;
    BOOL promptForCash = true;
    
    SPIPurchaseRequest *request = [SPIPurchaseHelper createPurchaseRequest:posRefId purchaseAmount:amountCents tipAmount:tipamount cashAmount:cashamount promptForCashout:promptForCash];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"],posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"purchase_amount"],amountCents );
    XCTAssertEqual([msg getDataIntegerValue:@"tip_amount"], tipamount);
    XCTAssertEqual([msg getDataBoolValue:@"prompt_for_cashout" defaultIfNotFound:false],promptForCash);
    XCTAssertNotNil([request amountSummary]);
}

- (void)testPopulatePurchaseRequestWithOptions_present {
    NSString *merchantReceiptHeader = @"";
    NSString *merchantReceiptFooter = @"merchrecfoot";
    NSString *customerReceiptHeader = @"custrechead";
    NSString *customerReceiptFooter = @"";
    
    SPITransactionOptions *options = [[SPITransactionOptions alloc] init];
    options.merchantReceiptFooter = merchantReceiptFooter;
    options.customerReceiptHeader = customerReceiptHeader;
    
    SPIPurchaseRequest *request = [SPIPurchaseHelper createPurchaseRequest:@"test"
                                                            purchaseAmount:10
                                                                 tipAmount:10
                                                                cashAmount:10
                                                          promptForCashout:false];
    request.options = options;
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertTrue([[msg getDataStringValue:@"merchant_receipt_header"] isEqualToString:merchantReceiptHeader]);
    XCTAssertTrue([[msg getDataStringValue:@"merchant_receipt_footer"] isEqualToString:merchantReceiptFooter]);
    XCTAssertTrue([[msg getDataStringValue:@"customer_receipt_header"] isEqualToString:customerReceiptHeader]);
    XCTAssertTrue([[msg getDataStringValue:@"customer_receipt_footer"] isEqualToString:customerReceiptFooter]);
}

- (void)testPopulatePurchaseRequestWithOptions_none {
    SPIPurchaseRequest *request = [SPIPurchaseHelper createPurchaseRequest:@"test"
                                                            purchaseAmount:10
                                                                 tipAmount:10
                                                                cashAmount:10
                                                          promptForCashout:false];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertNil(msg.data[@"merchant_receipt_header"]);
    XCTAssertNil(msg.data[@"merchant_receipt_footer"]);
    XCTAssertNil(msg.data[@"customer_receipt_header"]);
    XCTAssertNil(msg.data[@"customer_receipt_footer"]);
    XCTAssertTrue([[msg getDataStringValue:@"merchant_receipt_header"] isEqualToString:@""]);
    XCTAssertTrue([[msg getDataStringValue:@"merchant_receipt_footer"] isEqualToString:@""]);
    XCTAssertTrue([[msg getDataStringValue:@"customer_receipt_header"] isEqualToString:@""]);
    XCTAssertTrue([[msg getDataStringValue:@"customer_receipt_footer"] isEqualToString:@""]);
}

- (void)testPopulatePurchaseRequestWithSurchargeAmount_full {
    NSString *posRefId = @"test";
    int amountCents = 10;
    int tipamount = 10;
    int cashamount = 10;
    BOOL promptForCash = true;
    int surchargeAmount = 1;
    
    SPIPurchaseRequest *request = [SPIPurchaseHelper createPurchaseRequest:posRefId
                                                            purchaseAmount:amountCents
                                                                 tipAmount:tipamount
                                                                cashAmount:cashamount
                                                          promptForCashout:promptForCash
                                                           surchargeAmount:surchargeAmount];
    
    SPIMessage *msg = [request toMessage];
    
    XCTAssertEqual([msg getDataStringValue:@"pos_ref_id"],posRefId);
    XCTAssertEqual([msg getDataIntegerValue:@"purchase_amount"],amountCents );
    XCTAssertEqual([msg getDataIntegerValue:@"tip_amount"], tipamount);
    XCTAssertEqual([msg getDataBoolValue:@"prompt_for_cashout" defaultIfNotFound:false],promptForCash);
    XCTAssertEqual([msg getDataBoolValue:@"surcharge_amount" defaultIfNotFound:false],surchargeAmount);
    XCTAssertNotNil([request amountSummary]);
}

- (void)testPopulatePurchaseResponse {
    NSString *jsonStr = @"{\"data\":{\"account_type\":\"CREDIT\",\"auth_code\":\"328885\",\"bank_date\":\"18062018\",\"bank_noncash_amount\":1000,\"bank_settlement_date\":\"18062018\",\"bank_time\":\"000145\",\"card_entry\":\"EMV_CTLS\",\"currency\":\"AUD\",\"customer_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 18JUN18   00:01\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180618000149\\r\\nMasterCard      \\r\\nMastercard(C)     CR\\r\\nCARD............2797\\r\\nAID   A0000000041010\\r\\nTVR       0000000000\\r\\nAUTH          328885\\r\\n\\r\\nPURCHASE    AUD10.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n  *CUSTOMER COPY*\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"customer_receipt_printed\":true,\"emv_actioncode\":\"ARP\",\"emv_actioncode_values\":\"688E386C083F4E690012\",\"emv_pix\":\"1010\",\"emv_rid\":\"A000000004\",\"emv_tsi\":\"E800\",\"emv_tvr\":\"0000000000\",\"expiry_date\":\"0722\",\"host_response_code\":\"000\",\"host_response_text\":\"APPROVED\",\"informative_text\":\"                \",\"masked_pan\":\"............2797\",\"merchant_acquirer\":\"EFTPOS FROM WESTPAC\",\"merchant_addr\":\"213 Miller Street\",\"merchant_city\":\"Sydney\",\"merchant_country\":\"Australia\",\"merchant_id\":\"22341845\",\"merchant_name\":\"Merchant4\",\"merchant_postcode\":\"2060\",\"merchant_receipt\":\"EFTPOS FROM WESTPAC\\r\\nMerchant4\\r\\n213 Miller Street\\r\\nSydney 2060\\r\\nAustralia\\r\\n\\r\\nTIME 18JUN18   00:01\\r\\nMID         22341845\\r\\nTSP     100312348845\\r\\nRRN     180618000149\\r\\nMasterCard      \\r\\nMastercard(C)     CR\\r\\nCARD............2797\\r\\nAID   A0000000041010\\r\\nTVR       0000000000\\r\\nAUTH          328885\\r\\n\\r\\nPURCHASE    AUD10.00\\r\\n\\r\\n   (000) APPROVED\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\\r\\n\",\"merchant_receipt_printed\":true,\"online_indicator\":\"Y\",\"pos_ref_id\":\"kebab-18-06-2018-00-01-45\",\"purchase_amount\":1000,\"rrn\":\"180618000149\",\"scheme_app_name\":\"MasterCard\",\"scheme_name\":\"MasterCard\",\"stan\":\"000149\",\"success\":true,\"terminal_id\":\"100312348845\",\"terminal_ref_id\":\"12348845_18062018000208\",\"tip_amount\":0,\"transaction_type\":\"PURCHASE\"},\"datetime\":\"2018-06-18T00:02:08.107\",\"event\":\"purchase_response\",\"id\":\"prchs4\"}";
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:jsonObject];
    SPIPurchaseResponse *response  = [[SPIPurchaseResponse alloc] initWithMessage:msg];
    XCTAssertTrue([[response getRRN] isEqualToString:@"180618000149"]);
    XCTAssertEqual([response getPurchaseAmount],1000);
    XCTAssertEqual([response getTipAmount] ,0);
    XCTAssertEqual([response getCashoutAmount], 0);
    XCTAssertEqual([response getBankNonCashAmount], 1000);
    XCTAssertEqual([response getBankCashAmount] ,0);
    XCTAssertNotNil([response getCustomerReceipt]);
    XCTAssertTrue([[response getResponseText] isEqualToString:@"APPROVED"]);
    XCTAssertNotNil([response toPaymentSummary]);
    XCTAssertTrue([[[response getSettlementDate] toString] isEqualToString:@"2018-06-18T00:00:00.000"]);
    XCTAssertTrue([[response getResponseCode] isEqualToString:@"000"]);
    XCTAssertTrue([[response getTerminalReferenceId] isEqualToString:@"12348845_18062018000208"]);
    XCTAssertTrue([[response getCardEntry] isEqualToString:@"EMV_CTLS"]);
    XCTAssertTrue([[response getAccountType] isEqualToString:@"CREDIT"]);
    XCTAssertTrue([[response getBankDate] isEqualToString:@"18062018"]);
    XCTAssertNotNil([response getMerchantReceipt]);
    XCTAssertTrue([[response getBankTime] isEqualToString:@"000145"]);
    XCTAssertTrue([[response getMaskedPan] isEqualToString:@"............2797"]);
    XCTAssertTrue([[response getTerminalId] isEqualToString:@"100312348845"]);
    XCTAssertEqual([response wasCustomerReceiptPrinted], true);
    XCTAssertEqual([response wasMerchantReceiptPrinted], true);
}

- (void)testInitiatePurchaseRequest {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiatePurchaseTx:@"test" purchaseAmount:10 tipAmount:0 cashoutAmount:0 promptForCashout:false completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateMotoPurchaseRequest {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateMotoPurchaseTx:@"test" amountCents:19 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateMotoPurchaseRequestWithSurchargeAmount {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateMotoPurchaseTx:@"test" amountCents:19 surchargeAmount:1 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCashOutOnlyRequest {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateCashoutOnlyTx:@"test" amountCents:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCashOutOnlyRequestWithSurcharge {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateCashoutOnlyTx:@"test" amountCents:10 surchargeAmount:1 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateSettleEnquiryRequest {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateSettlementEnquiry:@"test" completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateSettlementRequest {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateSettleTx:@"test" completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateRecoveryRequest {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateRecovery:@"test" transactionType:SPITransactionTypePurchase completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCancelTransaction {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    [client initiateRefundTx:@"test" amountCents:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testHandleCancelResponse_success {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    SPISecrets *secrets = client.secrets;
    SPIMessageStamp *stamp = [[SPIMessageStamp alloc] initWithPosId:@"POS" secrets:secrets serverTimeDelta:0];
    
    client.state.status = SPIStatusPairedConnected;
    
    NSString *posRefId = @"kebab-18-06-2018-03-44-05";
    
    [client initiatePurchaseTx:posRefId
                purchaseAmount:10
                     tipAmount:0
                 cashoutAmount:0
              promptForCashout:false
                    completion:^(SPIInitiateTxResult *result) {}];
    
    [SPITestUtils waitForAsync:1];
    
    client.state.txFlowState.isAttemptingToCancel = YES;
    
    [SPITestUtils waitForAsync:1];
    
    XCTAssertTrue(client.state.txFlowState.isAttemptingToCancel);
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:@{
                                                         @"event": @"cancel_response",
                                                         @"id": @"0",
                                                         @"datetime": @"2018-02-06T15:16:44.094",
                                                         @"data": @{
                                                                 @"pos_ref_id": posRefId,
                                                                 @"success": @YES,
                                                                 @"error_reason": @"",
                                                                 @"error_detail": @""
                                                                 }
                                                         }];
    [client onSpiMessageReceived:[msg toJson:stamp]];
    
    [SPITestUtils waitForAsync:1];
    
    XCTAssertTrue(client.state.txFlowState.isAttemptingToCancel);
}

- (void)testHandleCancelResponse_failure {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    SPISecrets *secrets = client.secrets;
    SPIMessageStamp *stamp = [[SPIMessageStamp alloc] initWithPosId:@"POS" secrets:secrets serverTimeDelta:0];
    
    client.state.status = SPIStatusPairedConnected;
    
    NSString *posRefId = @"kebab-18-06-2018-03-44-05";
    
    [client initiatePurchaseTx:posRefId
                purchaseAmount:10
                     tipAmount:0
                 cashoutAmount:0
              promptForCashout:false
                    completion:^(SPIInitiateTxResult *result) {}];
    
    [SPITestUtils waitForAsync:1];
    
    client.state.txFlowState.isAttemptingToCancel = YES;
    
    [SPITestUtils waitForAsync:1];
    
    XCTAssertEqual(YES, client.state.txFlowState.isAttemptingToCancel);
    
    SPIMessage *msg = [[SPIMessage alloc] initWithDict:@{
                                                         @"event": @"cancel_response",
                                                         @"id": @"0",
                                                         @"datetime": @"2018-02-06T15:16:44.094",
                                                         @"data": @{
                                                                 @"pos_ref_id": posRefId,
                                                                 @"success": @NO,
                                                                 @"error_reason": @"txn_past_point_of_no_return",
                                                                 @"error_detail": @"Too late to cancel transaction"
                                                                 }
                                                         }];
    [client onSpiMessageReceived:[msg toJson:stamp]];
    
    [SPITestUtils waitForAsync:1];
    
    NSString *displayMessage = client.state.txFlowState.displayMessage;
    XCTAssertTrue([displayMessage isEqualToString:@"Failed to cancel transaction: Too late to cancel transaction. Check EFTPOS."],
                  @"Unexpected display message: '%@'", displayMessage);
    
    XCTAssertTrue(!client.state.txFlowState.isAttemptingToCancel);
}

- (void)testHandlePurchaseResponse {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    // Initiate request
    client.state.status = SPIStatusPairedConnected;
    [client initiatePurchaseTx:@"kebab-18-06-2018-03-44-05"
                purchaseAmount:10
                     tipAmount:0
                 cashoutAmount:0
              promptForCashout:false
                    completion:^(SPIInitiateTxResult *result) {}];
    
    NSString *jsonStr = @"{\"enc\":\"71EF1DB91443BE9E3D8DE270E603F8CB680D892EF29FA985079020EC58B694D84802EBCC6FFF3CD6F8FEDBFD76399366AFE92B2C462B170F9D7D3A8AB2D8A41366AA2996FB6400A9F198F499D43D641DB5E1541881DE04FE15E924CB65FAB023EAFA7BB1733DD9B8A09AC8B8481BB38920C5D091787323BA2AFC2F70AE6E19C967F1572245E99616D3812DB01746BE55C248E34012CE8112DD36A17410D233790F461EBB4F260FC4CD4FB9173C18A1E672A4FDB91B8CD10E23BA3BFE44EDB2432D7401C00DC7C2DF02C02E6267522389D7DBA74C7EA4DE6CABF2272C17CAFE821F789B8339459322CDBAF214690A65C11B1F92E8C3F0695CE0F0529DED4A922050679EDDD92513D10BBF024688C415462B5B4AD24D7BE8BB2C125F3A0512E912A3AC031C5711571AAC75BB65AB31E9D8BBCD6236FF0643BE13CDBDA8EBFEB61FF962AFC416E77B4125C0FB26C104D1D7DF4EB3AC34FFBFFED0520A27D462E1F1183F4CF8709C28A903D56566AB24D5640B7EF880ED479DB10081C414E0EB057A5C0B28ACBB4B8BFA2D6C8F764FC8D64B5DADBB206A0CB80179482EF9CE62EED53045C9B6EAF026D237D885EB765811043090168CCAC0DCCC5F5C8CB9AF7382CD74B61D74315CC1E9F62CACEF79FE62E39BA850A812A5B1CF6DDDD59ACBB2E9EDE14FA2BC53F1F2BDF64565EDA56D7FFA1668BCA6C63AFD9A820B6C6650D09526F2E7E48548CAB70E94BD355FCA2CA9801464A120CF37F08E8577CD23BD241078D1B32393CCD9B1E1D253F5C017A6D88438E0F8FDE292980D6B82285A4F87B3A75E120A1E2490C7ADC22A3B2F6A712F6B3E876790AF2DBCD862149ED46734CC6D5A1E20DFC4EFD43E7562D94D69A309EC458AB257B6D92ECB8265BF153ED425D29BBD149C9A279FD7C77906F8EEA6712F2578A386888A3937393E035DB9A56C3EE7BAA17771C5D0643FC358D7C13A7F92E4006064ADC334DF01911AF0C98DD96779A93205D762306F5CD91247E568D6F05DD4C179F7BB68096B3AF1AE512A42BC9399F625E4656DEA6438A4D00986346DAA15123C03621A5E5A7AD5DE86FDB0139096DE295CEDEDBC27801643D38BB0626E95CE5EA99095C4AEEB846083E95E4B272FB1A282C834BE572A8CCBC4C9E3E43EE177CBDFC543B972D55675E8B01EE228197ACA193DD947F99EFE4220FB818DC32FDCC613FC109BD5B9520C1D14623F79548A147012F0C389A8F1156BDE2BF63980166FF705801409A710FF49108E9EEBD0C0150A7D2080F7CCB3720DA8195D4E47103C97DA4D0AB21265509C4643135FC0967322BFCF5DCE31B044B04BB7564746919688D5D2D9E210E86DB4DAFF1656FA770F1D82366E08AB212346EB3AFA9CCFFB41A105AEB4960AF553EA0BE5AC35E3E0B03DE25CFD060B6F057CC07D0AF1FCABD3D1906A690B3013EBF90FCE085DD6C35CE7713E13C8951A05DFF981123E04DED4FE8740C03F39314FB10479385C40CDBAB9270E3EF69B2758529D6EB7CC7AF3EBCAD1C2CCF43DAE55D4E4C836873BDA6D70DA0285A2584522BE207D1169C2E35C3EA23AA3BFDA4CDBBF20B8532E77BA856243DCB92EFF1A16054B6852545FF4184FA9D267E4FC151B810568BF052A81EE0E473862498A903C11FD61CE134AFDC9B0544DDEE58D2752A6793BE0F84BF557D1F3752182BDA8CBB728B42D8568870FF78AD09C5ACB56575AE03D5E9844396725B6565DBB141D97E206BEF96539D57EFA28AAC7E7878885D577ABC0468A5A84B47A0FA4A36EFDBFA41AD24F6A35A87C195C72878CBE001829371AB583F764E7C5B96B0F39EFA489945CDD727CF7E087E94D8E5233F091DFC2738423616EC88FE6C587B9EBDCA33E9D30C7525A5C2AE102F78EDDAEA8F78498A558546ACAB6F77BAA43F362ED092F3B5B32F3227F279DFB4A6154783A410759CA019C891F505740E9F264CC0CC7E62E9509F1DF46B555B94CFA204C2B6C7A0300ACD50295F2D1E5A8CA318740EB02164FF6EF12D36ADC4B71D053180A9D70FA7562FF7E62CA506D636EB80BF240A686E071AB7B8179FA23F29D669CF79D55EFFBD6EA19D03AA28E2F52692CF221981AF309E1B565387F442798700C8F729848136DEAB788C84157940165305ABFCCBD10BE27D5AF2D4D5A7E20C1189DF63B97026813CE0498AC9C0DB36129719C036B1A7F118428D83D61B0DD91B77E99D107C8D5763F9119887E5855180607CFA65D98F1AA7E69781525F842CFDC32C6B55C9A7A327F1D54DC3548DFCF33302102EA59F9F8828A762F03AFDD0456E558A5FFF1D9422C46662B1AF4E31AB75FF248EB3B4775047B436016264F5366D53F5AF0E682A557D8A0AACB9B1643D7223A6B8FAFB97F7FF432243CE067617B979B3A48990BA42CDE53D90E3DD1E9E6F596595369E65B92296386EF954C8A4C687A524CD61C8BE2A3100B8CB257E4AD694ACFBC517E3B13C20A0F0641808315BB45EE63868EC63D505434A62CF7758EE49A47F7AD728DDE3D4529D241870F0E6C157EEA15AF0DA312D1389C1A5902BEBB23D8654EB615040E67863A657EE4762722D3A8C013F5CCEC802A8FD760F2DBDF3FFD69B77F26F8AB695ECAF16EC3C7929EC4E279FF46CA732FADF265338D920B0B7CE5447B448004322F8F2EAB10B14BE912A8A50F3F84AA861312A828F9418DC3E65E83548D9553D4135406944731FD02631BF7BFEE7E0A247D39A61D6087E9F1C8F6DDDD1C145CC15557BF66B368200BB174EC8CA8F6967C9E0F02E6C477CBAEAFC12CE78FAB24E429E5D95D79F11E4CD5ECB7A7677F7D78172B36429BDB3565C875D544171A2ADB0B9E32E54010C2F0775C9A6FD903ECE00A2924C424A1E4A6798846126552AAE7F818A523CFF2B7D7EA4FD813B5256AFB75BA5EFFA7C254BC7F3494AA850A2EE46FD0B0C08C11B3271F15CDA6AE\",\"hmac\":\"441F1D213C72B1775BA0F67722240E06472AA7BF544BE0685C1D31F2C1E1970B\"}";
    [client onSpiMessageReceived:jsonStr];
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void) [XCTWaiter waitForExpectations:@[expectation] timeout:1];
    
    NSString *displayMessage = client.state.txFlowState.displayMessage;
    XCTAssertTrue([displayMessage isEqualToString:@"Purchase transaction ended"],
                  @"Unexpected display message: '%@'", displayMessage);
}

@end
