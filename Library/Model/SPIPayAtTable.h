//
//  SPIPayAtTable.h
//  SPIClient-iOS
//
//  Created by Amir Kamali on 20/5/18.
//  Copyright © 2018 Assembly Payments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIMessage.h"
#import "SPIPurchase.h"

typedef NS_ENUM (NSUInteger, SPIBillRetrievalResult) {
    BillRetrievalResultSuccess,
    BillRetrievalResultInvalidTableId,
    BillRetrievalResultInvalidBillId,
    BillRetrievalResultInvalidOperatorId,
};
typedef NS_ENUM (NSUInteger, SPIPaymentType) {
    PaymentTypeCard,
    PaymentTypeCash,
};

@interface SPIPaymentHistoryEntry:NSObject
@property (nonatomic,readonly) NSString* paymentType;
@property (nonatomic,readonly) NSDictionary* paymentSummary;
- init:(NSDictionary *) fromJson;
- (NSDictionary *)toJsonObject;
- (NSString *)getTerminalRefId;
@end


@interface SPIPayAtTable : NSObject
@end
/**
 * This class represents the BillDetails that the POS will be asked for throughout a PayAtTable flow.
 */
@interface SPIBillStatusResponse : NSObject

//Set this Error accordingly if you are not able to return the BillDetails that were asked from you.
@property (nonatomic) SPIBillRetrievalResult result;

//This is a unique identifier that you assign to each bill. It migt be for example, the timestamp of when the cover was opened.
@property (nonatomic, readonly, copy) NSString *billId;

// This is the table id that this bill was for.
// The waiter will enter it on the Eftpos at the start of the PayAtTable flow and the Eftpos will
// retrieve the bill using the table id.
@property (nonatomic, readonly, copy) NSString *tableId; //

// Your POS is required to persist some state on behalf of the Eftpos so the Eftpos can recover state.
// It is just a piece of string that you save against your billId.
// WHenever you're asked for BillDetails, make sure you return this piece of data if you have it.
@property (nonatomic, readonly, copy) NSString *billData;

// The Total Amount on this bill, in cents.
@property (nonatomic,readonly) NSInteger totalAmount;

// The currently outsanding amount on this bill, in cents.
@property (nonatomic,readonly) NSInteger outstandingAmount;
- (NSArray<SPIPaymentHistoryEntry *> *)getBillPaymentHistory;
+ (NSString *)toBillData:(NSArray<SPIPaymentHistoryEntry *>*) ph;
- (SPIMessage *)toMessage:(NSString *)messageId;

@end

@interface SPIBillPayment:NSObject
- (instancetype)initWithMessage:(SPIMessage *)message;
@property (nonatomic, retain) NSString *billId;
@property (nonatomic, retain) NSString *tableId;
@property (nonatomic, retain) NSString *operatorId;

@property (nonatomic) SPIPaymentType paymentType;

@property (nonatomic) NSInteger purchaseAmount;
@property (nonatomic) NSInteger TipAmount;

@property (nonatomic, readonly, copy) SPIPurchaseResponse *purchaseResponse;

@end

@interface SPIPayAtTableConfig:NSObject
@property (nonatomic) BOOL operatorIdEnabled;
@property (nonatomic) BOOL splitByAmountEnabled;
@property (nonatomic) BOOL equalSplitEnabled;
@property (nonatomic) BOOL tippingEnabled;
@property (nonatomic) BOOL summaryReportEnabled;
@property (nonatomic,readonly,copy) NSString *labelPayButton;
@property (nonatomic,readonly,copy) NSString *labelOperatorId;
@property (nonatomic,readonly,copy) NSString *labelTableId;
@property (nonatomic,readonly,copy) NSArray<NSString *> *allowedOperatorIds;
- (SPIMessage *)toMessage:(NSString *)messageId;
+ (SPIMessage *)featureDisableMessage:(NSString *)messageId;
@end
