//
//  SPIClientTests.m
//  Tests
//
//  Created by Amir Kamali on 18/6/18.
//  Copyright © 2018 mx51. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"
#import "SPITestUtils.h"

@interface SPIClient (Testing)

- (void)pairingConfirmCode;

- (void)handleReversalResponse:(SPIMessage *)m;

- (void)onSpiConnectionStatusChanged:(SPIConnectionState)newConnectionState;

- (void)handleGetTransactionResponse:(SPIMessage *)m;

@end


@interface SPIClientTests : XCTestCase

@end

@implementation SPIClientTests

- (void)testSetPosId_OnInvalidLength_IsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testStart_OnInvalidLengthForPosId_IsSet {
    // arrange
    static NSString *posId = @"12345678901234567";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.7";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];

    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testSetPosId_OnValidCharacters_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.posId = posId;
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)testStart_OnValidCharactersForPosId_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.7";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];
    
    // assert
    XCTAssertTrue([client.posId isEqualToString:posId]);
}

- (void)testSetPosId_OnInvalidCharacters_IsSet {
    // arrange
    static NSString *posId = @"RamenPos@";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.posId = posId;
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testStart_OnInvalidCharactersForPosId_IsSet {
    // arrange
    static NSString *posId = @"RamenPos@";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.7";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];
    
    // assert
    XCTAssertFalse([client.posId isEqualToString:posId]);
}

- (void)testSetEftposAddress_OnValidCharacters_IsSet {
    // arrange
    static NSString *eftposAddress = @"10.20.30.40";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.eftposAddress = eftposAddress;
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertTrue([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testStart_OnValidCharactersForEftposAddress_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30.40";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.7";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertTrue([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testEftposAddress_OnInvalidCharacters_IsSet {
    // arrange
    static NSString *eftposAddress = @"10.20.30";
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    client.eftposAddress = eftposAddress;
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertFalse([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testStart_OnInvalidCharactersForEftposAddress_IsSet {
    // arrange
    static NSString *posId = @"RamenPos";
    static NSString *eftposAddress = @"10.20.30";
    static NSString *posVendorId = @"mx51";
    static NSString *posVersion = @"2.6.7";
    SPIClient *client = [[SPIClient alloc] init];
    client.posId = posId;
    client.eftposAddress = eftposAddress;
    client.posVendorId = posVendorId;
    client.posVersion = posVersion;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    // act
    [client start];
    NSString *clientEftposAddress = [client.eftposAddress stringByReplacingOccurrencesOfString:@"ws://" withString:@""];
    
    // assert
    XCTAssertFalse([clientEftposAddress isEqualToString:eftposAddress]);
}

- (void)testUnpair_OnValid_IsSet {
    //Initiate Client and set status
    SPIClient *client = [[SPIClient alloc] init];
    [client setSecretEncKey:@"1" hmacKey:@"2"];
    client.state.status = SPIStatusPairedConnected;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    //Perform unpair
    [client unpair];
    
    //Wait & check
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:1];
    
    XCTAssertEqual(client.state.status, SPIStatusUnpaired);
}

- (void)testEnablePayAtTable {
    SPIClient *client = [[SPIClient alloc] init];
    SPIPayAtTable *pat = [client enablePayAtTable];
    XCTAssertNotNil(pat);
}

- (void)testPairingFlowStateChanged {
    SPIClient *client = [[SPIClient alloc] init];
    [client setEftposAddress:@"192.168.0.1"];
    [client setPosId:@"posID"];
    client.state.status = SPIStatusUnpaired;
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    //Perform unpair
    
    SPIPairingFlowState *before = client.state.pairingFlowState;

    [client pair];
    
    SPIPairingFlowState *after = client.state.pairingFlowState;
    
    XCTAssertNotEqual(before, after);
}

- (void)testAutoResolveEftposAddress {
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    [client setTenantCode:@"gko"];
    [client setEftposAddress:@"1.1.1.1"];
    [client setSerialNumber:@"555-555-002"];
    [client setDeviceApiKey:@"RamenPosDeviceAddressApiKey"];
    [client setPosId:@"posID"];
    [client setTestMode:YES];
    [client setTestMode:NO];

    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    delegate.deviceAddressChangedBlock = ^() {
        XCTAssertNotEqual(client.eftposAddress, @"1.1.1.1");
    
        [expectation fulfill];
    };
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
}

- (void)testInitiatePurchase {
    SPIClient *client = [[SPIClient alloc] init];
    SPIDummyDelegate *delegate = [SPIDummyDelegate new];
    client.delegate = delegate;
    [client setTenantCode:@"gko"];
    [client setEftposAddress:@"1.1.1.1"];
    [client setSerialNumber:@"555-555-002"];
    [client setDeviceApiKey:@"RamenPosDeviceAddressApiKey"];
    [client setPosId:@"posID"];
    [client setTestMode:NO];
    client.state.status = SPIStatusPairedConnected;
    
    [client initiatePurchaseTx:@"test_test" amountCents:1000 completion:^(SPIInitiateTxResult *result) {
        NSLog(@"%@", result.message);
    }];
    
}

- (void)testAcceptSignature_isAwaiting_accepted {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isAwaitingSignatureCheck = YES;
    client.state.txFlowState.isFinished = NO;
    
    [client acceptSignature:YES];
    NSLog(@"%@", client.state.txFlowState.displayMessage);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Accepting"]);
    XCTAssertFalse(client.state.txFlowState.isAwaitingSignatureCheck);
}

- (void)testAcceptSignature_isAwaiting_notAccepted {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isAwaitingSignatureCheck = YES;
    client.state.txFlowState.isFinished = NO;
    
    [client acceptSignature:NO];
    NSLog(@"%@", client.state.txFlowState.displayMessage);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Declining"]);
    XCTAssertFalse(client.state.txFlowState.isAwaitingSignatureCheck);
}

- (void)testAcceptSignature_isNotAwaiting {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isAwaitingSignatureCheck = NO;
    client.state.txFlowState.isFinished = NO;
    
    [client acceptSignature:YES];
    
    XCTAssertFalse([client.state.txFlowState.displayMessage containsString:@"Accepting"]);
}

- (void)testSubmitAuthCode_wasWaiting {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isAwaitingPhoneForAuth = YES;
    client.state.txFlowState.isFinished = NO;
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    [client submitAuthCode:@"111111" completion:^(SPISubmitAuthCodeResult *result) {
        XCTAssertTrue([result.message containsString:@"Valid"]);
        [expectation fulfill];
    }];
    
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Submitting"]);
}

- (void)testSubmitAuthCode_wasNotWaiting {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isFinished = NO;
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    [client submitAuthCode:@"111111" completion:^(SPISubmitAuthCodeResult *result) {
        XCTAssertTrue([result.message containsString:@"not waiting"]);
        [expectation fulfill];
    }];
    
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
}

- (void)testCancelTransaction_requestSent {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.isRequestSent = YES;
    
    [client cancelTransaction];
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Attempting"]);
}

- (void)testCancelTransaction_requestNotSent {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.isRequestSent = NO;
    
    [client cancelTransaction];
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"cancelled"]);
}

- (void)testInitiateGetTx {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowIdle;
    client.state.status = SPIStatusPairedConnected;
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    [client initiateGetTxWithPosRefID:@"test_test" completion:^(SPIInitiateTxResult *result) {
        XCTAssertTrue([result.message containsString:@"initiated"]);
        [expectation fulfill];
    }];
    
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
}

- (void)testInitiateGetLastTx {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowIdle;
    client.state.status = SPIStatusPairedConnected;
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    [client initiateGetLastTxWithCompletion:^(SPIInitiateTxResult *result) {
        XCTAssertTrue([result.message containsString:@"initiated"]);
        [expectation fulfill];
    }];
    
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
}

- (void)testInitiateReversal {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowIdle;
    client.state.status = SPIStatusPairedConnected;
    
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"test expectation"];
    
    [client initiateReversal:@"test_test" completion:^(SPIInitiateTxResult *result) {
        XCTAssertTrue([result.message containsString:@"initiated"]);
        [expectation fulfill];
    }];
    
    (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:2];
}

- (void)testHandleReversalResponse {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.posRefId = @"rev";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"conn_id\": \"A\",\r\n    \"data\": {\r\n      \"pos_ref_id\": \"rev\",\r\n      \"success\": true\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"reverse_transaction_response\",\r\n    \"id\": \"rev\"\r\n  }\r\n}" secrets:nil];
    
    [client handleReversalResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"completed"]);
}

- (void)testOnSpiConnectionStatusChanged_connected {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.pairingFlowState = [SPIPairingFlowState new];
    client.state.flow = SPIFlowPairing;
    client.state.status = SPIStatusUnpaired;
    
    [client onSpiConnectionStatusChanged: SPIConnectionStateConnected];
    
    sleep(1);
    XCTAssertTrue([client.state.pairingFlowState.message containsString:@"Requesting"]);

}

- (void)testOnSpiConnectionStatusChanged_Disconnected {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.state.pairingFlowState = [SPIPairingFlowState new];
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.type = SPITransactionTypeReversal;
    
    [client onSpiConnectionStatusChanged: SPIConnectionStateDisconnected];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"middle"]);

}

- (void)testHandleGetTransactionResponse_gtr01 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"TRANSACTION_IN_PROGRESS_AWAITING_SIGNATURE\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": false\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"don't have receipt"]);
}

- (void)testHandleGetTransactionResponse_gtr02 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"TRANSACTION_IN_PROGRESS_AWAITING_PHONE_AUTH_CODE\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": false\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Phone-For-Auth"]);
}

- (void)testHandleGetTransactionResponse_gtr04 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"POS_REF_ID_NOT_FOUND\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": false\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"not found for"]);
}

- (void)testHandleGetTransactionResponse_gtr05 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"INVALID_ARGUMENTS\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": false\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"invalid"]);
}

- (void)testHandleGetTransactionResponse_gtr06 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"MISSING_ARGUMENTS\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": false\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"missing"]);
}

- (void)testHandleGetTransactionResponse_gtr08 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"UNKNOWN\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": false\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Get Transaction failed"]);
}

- (void)testHandleGetTransactionResponse_gtr10 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    client.state.txFlowState.type = SPITransactionTypeGetTransaction;
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"UNKNOWN\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": true\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Transaction Retrieved"]);
}

- (void)testHandleGetTransactionResponse_gtr11 {
    SPIClient *client = [[SPIClient alloc] init];
    client.state.txFlowState = [SPITransactionFlowState new];
    client.deviceApiKey = @"RamenPOS";
    client.state.flow = SPIFlowTransaction;
    client.state.status = SPIStatusPairedConnected;
    client.state.txFlowState.isAwaitingPhoneForAuth = NO;
    client.state.txFlowState.isAwaitingGtResponse = YES;
    client.state.txFlowState.isFinished = NO;
    client.state.txFlowState.gtRequestId = @"test";
    
    SPIMessage *m = [SPIMessage fromJson:@"{\r\n  \"message\": {\r\n    \"data\": {\r\n      \"error_detail\": \"Payment interface is busy, cannot process operation at this time\",\r\n      \"error_reason\": \"UNKNOWN\",\r\n      \"pos_ref_id\": \"gt-2000-01-01T00:00:00.000Z\",\r\n      \"success\": true\r\n    },\r\n    \"datetime\": \"2000-01-01T00:00:00.000\",\r\n    \"event\": \"get_transaction_response\",\r\n    \"id\": \"test\"\r\n  }\r\n}" secrets:nil];
    
    [client handleGetTransactionResponse: m];
    
    sleep(1);
    XCTAssertTrue([client.state.txFlowState.displayMessage containsString:@"Transaction Recovered"]);
}

@end
