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

- (void)testInitiateAccountVerifyTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateAccountVerifyTx:@"test" completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateOpenTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateOpenTx:@"test" amountCents:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateOpenTx_withOptions {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateOpenTx:@"test" amountCents:10 options:nil completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateTopupTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateTopupTx:@"test" preauthId:@"12345678" amountCents:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateTopupTx_withOptions {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateTopupTx:@"test" preauthId:@"12345678" amountCents:10 options:nil completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiatePartialCancellationTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiatePartialCancellationTx:@"test" preauthId:@"12345678" amountCents:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiatePartialCancellationTx_withOptions {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiatePartialCancellationTx:@"test" preauthId:@"12345678" amountCents:10 options:nil completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateExtendTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateExtendTx:@"test" preauthId:@"12345678" completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateExtendTx_withOptions {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateExtendTx:@"test" preauthId:@"12345678" options:nil completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCompletionTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateCompletionTx:@"test" preauthId:@"12345678" amountCents:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCompletionTx_withSurchargeAmount {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateCompletionTx:@"test" preauthId:@"12345678" amountCents:10 surchargeAmount:10 completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCompletionTx_withOptions {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateCompletionTx:@"test" preauthId:@"12345678" amountCents:10 surchargeAmount:10 options:nil completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCancelTx {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateCancelTx:@"test" preauthId:@"12345678" completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testInitiateCancelTx_withOptions {
    SPIClient *client = [SPITestUtils clientWithTestSecrets];
    
    client.state.status = SPIStatusPairedConnected;
    SPIPreAuth *spiPreauth = [client enablePreauth];
    [spiPreauth initiateCancelTx:@"test" preauthId:@"12345678" options:nil completion:^(SPIInitiateTxResult *result) {
        XCTAssertNotNil(result);
    }];
}

- (void)testAccountVerifyRequest {
    SPIAccountVerifyRequest *request = [[SPIAccountVerifyRequest alloc] initWithPosRefId:@"test"];
    SPIMessage *msg = [request toMessage];
    
    XCTAssertTrue([msg.eventName isEqualToString:@"account_verify"]);
    XCTAssertTrue([[request posRefId] isEqualToString:@"test"]);
}

@end
