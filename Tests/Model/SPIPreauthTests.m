//
//  SPIPreauthTests.m
//  Tests
//
//  Created by Metin Avci on 18/7/19.
//  Copyright © 2019 Assembly Payments. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPIClient.h"
#import "SPIClient+Internal.h"
#import "SPIPreauth.h"
#import "SPITestUtils.h"

@interface SPIPreauthTests : XCTestCase

@end

@implementation SPIPreauthTests

- (void)testInitiateAccountVerifyTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    //act
    [spiPreauth initiateAccountVerifyTx:posRefId completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateOpenTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSUInteger amountCents = 10;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateOpenTx:posRefId amountCents:amountCents completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateOpenTx_ValidRequestWithOptions_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSUInteger amountCents = 10;
    SPITransactionOptions *options = nil;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateOpenTx:posRefId amountCents:amountCents options:options completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateTopupTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateTopupTx:posRefId preauthId:preauthId amountCents:amountCents completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateTopupTx_ValidRequestWithOptions_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    SPITransactionOptions *options = nil;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateTopupTx:posRefId preauthId:preauthId amountCents:amountCents options:options completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiatePartialCancellationTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiatePartialCancellationTx:posRefId preauthId:preauthId amountCents:amountCents completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiatePartialCancellationTx_ValidRequestWithOptions_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    SPITransactionOptions *options = nil;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiatePartialCancellationTx:posRefId preauthId:preauthId amountCents:amountCents options:options completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateExtendTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateExtendTx:posRefId preauthId:preauthId completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateExtendTx_ValidRequestWithOptions_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    SPITransactionOptions *options = nil;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateExtendTx:posRefId preauthId:preauthId options:options completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCompletionTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateCompletionTx:posRefId preauthId:preauthId amountCents:amountCents completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCompletionTx_ValidRequestWithSurchargeAmount_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    static NSUInteger surchargeAmount = 10;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateCompletionTx:posRefId preauthId:preauthId amountCents:amountCents surchargeAmount:surchargeAmount completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCompletionTx_ValidRequestWithOptions_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    static NSUInteger amountCents = 10;
    static NSUInteger surchargeAmount = 10;
    SPITransactionOptions *options = nil;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateCompletionTx:posRefId preauthId:preauthId amountCents:amountCents surchargeAmount:surchargeAmount options:options completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCancelTx_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateCancelTx:posRefId preauthId:preauthId completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCancelTx_ValidRequestWithOptions_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    static NSString *preauthId =@"12345678";
    SPITransactionOptions *options = nil;
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    
    // act
    [spiPreauth initiateCancelTx:posRefId preauthId:preauthId options:options completion:^(SPIInitiateTxResult *result) {
        
        // assert
        XCTAssertNotNil(result);
    }];
}

- (void)testAccountVerifyRequest_ValidRequest_ReturnResult {
    // arrange
    static NSString *posRefId =@"test";
    SPIAccountVerifyRequest *request = [[SPIAccountVerifyRequest alloc] initWithPosRefId:posRefId];
    
    // act
    SPIMessage *msg = [request toMessage];
    
    // assert
    XCTAssertTrue([msg.eventName isEqualToString:@"account_verify"]);
    XCTAssertTrue([posRefId isEqualToString:[request posRefId]]);
}

@end
