//
//  SPIPurchase.h
//  SPIClient-iOS
//
//  Created by Yoo-Jin Lee on 2017-11-29.
//  Copyright © 2017 Assembly Payments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIMessage.h"

@class SPIMessage;
@class SPIConfig;
@interface SPIPurchaseRequest : NSObject
@property (nonatomic, readonly, copy) NSString *purchaseId DEPRECATED_MSG_ATTRIBUTE("Id is deprecated. Use PosRefId instead.");
@property (nonatomic, readonly, copy) NSString *posRefId;
@property (nonatomic, readonly) NSInteger      amountCents DEPRECATED_MSG_ATTRIBUTE("AmountCents is deprecated. Use PurchaseAmount instead.");
@property (nonatomic, readonly) NSInteger      purchaseAmount;
@property (nonatomic) NSInteger                tipAmount;
@property (nonatomic) NSInteger                cashoutAmount;
@property (nonatomic) BOOL                     promptForCashout;
@property(nonatomic,retain)  SPIConfig *config;

- (instancetype)initWithAmountCents:(NSInteger)amountCents
                       posRefId:(NSString *)posRefId;
- (SPIMessage *)toMessage;
- (NSString *)amountSummary;
@end


@interface SPIPurchaseResponse : NSObject
@property (nonatomic, readonly) BOOL               isSuccess;
@property (nonatomic, readonly, copy) NSString     *requestid;
@property (nonatomic, readonly, copy) NSString     *schemeName;
@property (nonatomic,retain) NSString              *posRefId;
@property (nonatomic, readonly, strong) SPIMessage *message;

- (instancetype)initWithMessage:(SPIMessage *)message;

- (NSString *)getRRN;

- (NSString *)getCustomerReceipt;

- (NSInteger)getPurchaseAmount;

- (NSInteger)getTipAmount;

- (NSInteger)getCashoutAmount;

- (NSInteger)getBankNonCashAmount;

- (NSInteger)getBankCashAmount;

- (NSString *)getResponseText;

- (NSString *)getResponseCode;

- (NSString *)getTerminalReferenceId;

- (NSString *)getResponseValueWithAttribute:(NSString *)attribute;

- (NSString *)hostResponseText;

-(NSDictionary *)toPaymentSummary;

- (NSDate *)getSettlementDate;


@end

@interface SPICancelTransactionRequest : NSObject
- (SPIMessage *)toMessage;
@end

@interface SPIGetLastTransactionRequest : NSObject
- (SPIMessage *)toMessage;
@end

@interface SPIGetLastTransactionResponse : NSObject
@property (nonatomic, strong) SPIMessage       *message;
@property (nonatomic, copy, readonly) NSString *bankDateTimeString;
@property (nonatomic, copy, readonly) NSDate   *bankDate;
@property (nonatomic) SPIMessageSuccessState   successState;

- (instancetype)initWithMessage:(SPIMessage *)message;

- (BOOL)wasRetrievedSuccessfully;

- (BOOL)wasOperationInProgressError;

- (BOOL)isWaitingForSignatureResponse;

- (BOOL)isWaitingForAuthCode;

- (BOOL)isStillInProgress:(NSString *) posRefId;

- (SPIMessageSuccessState *)getSuccessState;

- (BOOL)wasSuccessfulTx;

- (NSString *)getTxType;

- (NSString *)getPosRefId;

- (NSString *)getSchemeApp;

- (NSString *)getSchemeName;

- (NSInteger)getAmount;

- (NSInteger)getTransactionAmount;

- (NSString *)getBankDateTimeString;

- (NSString *)getRRN;

- (NSString *)getResponseText;

- (NSString *)getResponseCode;

- (void)copyMerchantReceiptToCustomerReceipt;

@end

@interface SPIRefundRequest : NSObject
@property (nonatomic, readonly, copy) NSString *refundId DEPRECATED_ATTRIBUTE;
@property (nonatomic, readonly) NSInteger      amountCents;
@property (nonatomic, readonly, copy) NSString *posRefId;
@property (nonatomic, retain) SPIConfig *config;

- (instancetype)initWithPosRefId:(NSString *)posRefId amountCents:(NSInteger)amountCents;

- (SPIMessage *)toMessage;
@end

@interface SPIRefundResponse : NSObject
@property (nonatomic, readonly, copy) NSString     *requestId;
@property (nonatomic, readonly) BOOL               isSuccess;
@property (nonatomic, readonly, copy) NSString     *schemeName;
@property (nonatomic, readonly, strong) SPIMessage *message;

- (instancetype)initWithMessage:(SPIMessage *)message;

- (NSString *)getRRN;

- (NSString *)getCustomerReceipt;

- (NSString *)getMerchantReceipt;

- (NSString *)getResponseText;

- (NSString *)getResponseValue:(NSString *)attribute;

- (NSDate *)getSettlementDate;
@end

@interface SPISignatureRequired : NSObject
@property (nonatomic, readonly, copy) NSString     *requestId;
@property (nonatomic, readonly, copy) NSString     *posRefId;
@property (nonatomic, readonly, strong) SPIMessage *message;

- (instancetype)initWithMessage:(SPIMessage *)message;
- (instancetype)initWithPosRefId:(NSString *)posRefId
                       requestId:(NSString *)requestId
                       receiptToSign:(NSString *)receiptToSign;
- (NSString *)getMerchantReceipt;
@end

@interface SPISignatureDecline : NSObject
@property (nonatomic, readonly, copy) NSString *signatureRequiredRequestId;
- (instancetype)initWithSignatureRequiredRequestId:(NSString *)signatureRequiredRequestId;
- (SPIMessage *)toMessage;
@end

@interface SPISignatureAccept : NSObject
@property (nonatomic, readonly, copy) NSString *signatureRequiredRequestId;
- (instancetype)initWithSignatureRequiredRequestId:(NSString *)signatureRequiredRequestId;

- (SPIMessage *)toMessage;
@end
@interface SPIMotoPurchaseRequest:NSObject
- (instancetype)initWithAmountCents:(NSInteger)amountCents posRefId:(NSString *)posRefId;

@property (nonatomic, readonly) NSInteger          purchaseAmount;
@property (nonatomic, readonly, copy) NSString     *posRefId;
@property(nonatomic,retain)  SPIConfig *config;
- (SPIMessage *) toMessage;

@end

@interface SPIMotoPurchaseResponse:NSObject
- (instancetype)initWithMessage:(SPIMessage *)message;
@property (nonatomic, readonly, copy) NSString                *posRefId;
@property (nonatomic, readonly, copy) SPIPurchaseResponse     *purchaseResponse;
@end

@interface SPIPhoneForAuthRequired:NSObject
- (instancetype)initWithMessage:(SPIMessage *)message;
- (instancetype)initWithPosRefId:(NSString *)posRefId requestId:(NSString *)requestId phoneNumber:(NSString *)phoneNumber merchantId:(NSString *)merchantId;
@property (nonatomic, readonly, copy) NSString     *requestId;
@property (nonatomic, readonly, copy) NSString     *posRefId;
-(NSString *)getPhoneNumber;
-(NSString *)getMerchantId;
@end

@interface SPIAuthCodeAdvice:NSObject
- (instancetype)initWithPosRefId:(NSString *)posRefId authCode:(NSString *)authCode;
@property (nonatomic, readonly, copy) NSString     *authCode;
@property (nonatomic, readonly, copy) NSString     *posRefId;
- (SPIMessage *) toMessage;
@end
