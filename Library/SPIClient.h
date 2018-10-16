//
//  SPIClient.h
//  SPIClient-iOS
//
//  Created by Yoo-Jin Lee on 2017-11-28.
//  Copyright © 2017 Assembly Payments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIConnection.h"
#import "SPIModels.h"
#import "SPITransaction.h"
#import "SPISettlement.h"

@class SPIClient;
@class SPIPreAuth;
@class SPIPayAtTable;

typedef void (^SPICompletionTxResult)(SPIInitiateTxResult *result);
typedef void (^SPIAuthCodeSubmitCompletionResult)(SPISubmitAuthCodeResult *result);

/**
 Completion handler.
 
 @param alreadyMovedToIdleState True means we have moved back to the Idle state. false means current flow was not finished yet.
 @param state Current state.
 */
typedef void (^SPICompletionState)(BOOL alreadyMovedToIdleState, SPIState *state);

@protocol SPIDelegate <NSObject>

@optional

/**
 Subscribe to this event to know when the status changes.
 */
- (void)spi:(SPIClient *)spi statusChanged:(SPIState *)state;


/**
 Subscribe to this event to know when pairing flow changes.
 */
- (void)spi:(SPIClient *)spi pairingFlowStateChanged:(SPIState *)state;

/**
 When CurrentFlow==Transaction, this represents the state of the transaction process.
 */
- (void)spi:(SPIClient *)spi transactionFlowStateChanged:(SPIState *)state;

/**
 Subscribe to this event to know when the Secrets change, such as at the end
 of the pairing process, or everytime that the keys are periodicaly rolled.
 You then need to persist the secrets safely so you can instantiate SPI with
 them next time around.
 */
- (void)spi:(SPIClient *)spi secretsChanged:(SPISecrets *)secrets state:(SPIState *)state;

@end

/**
 SPI integration client, used to manage connection to the terminal.
 */
@interface SPIClient : NSObject

/**
 The current state of the client.
 */
@property (nonatomic, readonly) SPIState *state;

/**
 The IP address of the target EFTPOS. Automatically prepends ws://
 Allows you to set the PIN pad address. Sometimes the PIN pad might change IP
 address (we recommend reserving static IPs if possible). Either way you need
 to allow your User to enter the IP address of the PIN pad.
 */
@property (nonatomic, copy) NSString *eftposAddress;

/**
 Uppercase AlphaNumeric string that Indentifies your POS instance. This value
 is displayed on the EFTPOS screen. Can only be called set in the Unpaired
 state.
 */
@property (nonatomic, copy) NSString *posId;

/**
 Vendor identifier of the POS itself. This value is used to identify the POS software
 to the EFTPOS terminal. Must be set before starting!
 */
@property (nonatomic, copy) NSString *posVendorId;

/**
 Version string of the POS itself. This value is used to identify the POS software
 to the EFTPOS terminal. Must be set before starting!
 */
@property (nonatomic, copy) NSString *posVersion;

@property (nonatomic, weak) id<SPIDelegate> delegate;

@property (nonatomic, readonly) SPIConfig *config;

/**
 If you provide secrets, it will start in PairedConnecting status; Otherwise
 it will start in Unpaired status.
 
 @return YES if needs to pair, else NO.
 */
- (BOOL)start;

/**
 * Returns the SDK version.
 */
+ (NSString *)getVersion;

/**
 Set the pairing secrets.
 
 @param encKey Encryption key.
 @param hmacKey HMAC key.
 */
- (void)setSecretEncKey:(NSString *)encKey hmacKey:(NSString *)hmacKey;

/**
 Call this one when a flow is finished and you want to go back to idle state.
 Typically when your user clicks the "OK" bubtton to acknowldge that pairing
 is finished, or that transaction is finished. When true, you can dismiss the
 flow screen and show back the idle screen.
 
 @param completion Completion handler.
 */
- (void)ackFlowEndedAndBackToIdle:(SPICompletionState)completion;

/**
 This will connect to the EFTPOS and start the pairing process.
 Only call this if you are in the Unpaired state.
 Subscribe to the PairingFlowStateChanged event to get updates on the pairing process.
 */
- (void)pair;

/**
 Call this when your user clicks yes to confirm the pairing code on your
 screen matches the one on the EFTPOS.
 */
- (void)pairingConfirmCode;

/**
 Call this if your user clicks CANCEL or NO during the pairing process.
 */
- (void)pairingCancel;

/**
 Call this when your uses clicks the Unpair button.
 This will disconnect from the EFTPOS and forget the secrets.
 The CurrentState is then changed to Unpaired.
 Call this only if you are not yet in the Unpaired state.
 */
- (BOOL)unpair;

/**
 Initiates a purchase transaction. Be subscribed to TxFlowStateChanged event
 to get updates on the process.
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents NSInteger
 @param completion SPICompletionTxResult
 */
- (void)initiatePurchaseTx:(NSString *)posRefId
               amountCents:(NSInteger)amountCents
                completion:(SPICompletionTxResult)completion DEPRECATED_MSG_ATTRIBUTE("Use initiatePurchaseTx:purchaseAmount:tipAmount:cashoutAmount:promptForCash:completion instead.");

/**
 Initiates a purchase transaction. Be subscribed to TxFlowStateChanged event to
 get updates on the process.
 
 NOTE: Tip and cashout are not allowed simultaneously.
 
 @param posRefId The unique identifier for the transaction.
 @param purchaseAmount The purchase amount in cents.
 @param tipAmount The tip amount in cents.
 @param cashoutAmount The cashout amount in cents.
 @param promptForCashout Whether to prompt your customer for cashout on the EFTPOS.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */

- (void)initiatePurchaseTx:(NSString *)posRefId
            purchaseAmount:(NSInteger)purchaseAmount
                 tipAmount:(NSInteger)tipAmount
             cashoutAmount:(NSInteger)cashoutAmount
          promptForCashout:(BOOL)promptForCashout
                completion:(SPICompletionTxResult)completion;

/**
 Initiates a purchase transaction. Be subscribed to TxFlowStateChanged event to
 get updates on the process.
 
 NOTE: Tip and cashout are not allowed simultaneously.
 
 @param posRefId The unique identifier for the transaction.
 @param purchaseAmount The purchase amount in cents.
 @param tipAmount The tip amount in cents.
 @param cashoutAmount The cashout amount in cents.
 @param promptForCashout Whether to prompt your customer for cashout on the EFTPOS.
 @param options Additional options applied on per-transaction basis.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiatePurchaseTx:(NSString *)posRefId
            purchaseAmount:(NSInteger)purchaseAmount
                 tipAmount:(NSInteger)tipAmount
             cashoutAmount:(NSInteger)cashoutAmount
          promptForCashout:(BOOL)promptForCashout
                   options:(SPITransactionOptions *)options
                completion:(SPICompletionTxResult)completion;

/**
 Initiates a purchase transaction. Be subscribed to TxFlowStateChanged event to
 get updates on the process.
 
 NOTE: Tip and cashout are not allowed simultaneously.
 
 @param posRefId The unique identifier for the transaction.
 @param purchaseAmount The purchase amount in cents.
 @param tipAmount The tip amount in cents.
 @param cashoutAmount The cashout amount in cents.
 @param promptForCashout Whether to prompt your customer for cashout on the EFTPOS.
 @param surchargeAmount The surcharge amount in cents
 @param options Additional options applied on per-transaction basis.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiatePurchaseTx:(NSString *)posRefId
            purchaseAmount:(NSInteger)purchaseAmount
                 tipAmount:(NSInteger)tipAmount
             cashoutAmount:(NSInteger)cashoutAmount
          promptForCashout:(BOOL)promptForCashout
           surchargeAmount:(NSInteger)surchargeAmount
                   options:(SPITransactionOptions *)options
                completion:(SPICompletionTxResult)completion;

/**
 Initiates a refund transaction. Be subscribed to TxFlowStateChanged event to
 get updates on the process.
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents The refund amount in cents.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateRefundTx:(NSString *)posRefId
             amountCents:(NSInteger)amountCents
              completion:(SPICompletionTxResult)completion;

/**
 Initiates a refund transaction. Be subscribed to TxFlowStateChanged event to
 get updates on the process.
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents The refund amount in cents.
 @param isSuppressMerchantPassword Ability to suppress Merchant Password from POS.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateRefundTx:(NSString *)posRefId
             amountCents:(NSInteger)amountCents
isSuppressMerchantPassword:(BOOL)isSuppressMerchantPassword
              completion:(SPICompletionTxResult)completion;

/**
 Initiates a Mail Order / Telephone Order Purchase Transaction
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents The purchase amount in cents.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateMotoPurchaseTx:(NSString *)posRefId
                   amountCents:(NSInteger)amountCents
                    completion:(SPICompletionTxResult)completion;

/**
 Initiates a Mail Order / Telephone Order Purchase Transaction
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents The purchase amount in cents.
 @param surchargeAmount The surcharge amount in cents
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateMotoPurchaseTx:(NSString *)posRefId
                   amountCents:(NSInteger)amountCents
               surchargeAmount:(NSInteger)surchargeAmount
                    completion:(SPICompletionTxResult)completion;

/**
 Initiates a cashout only transaction. Be subscribed to TxFlowStateChanged
 event to get updates on the process.
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents The cashout amount in cents.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateCashoutOnlyTx:(NSString *)posRefId
                  amountCents:(NSInteger)amountCents
                   completion:(SPICompletionTxResult)completion;

/**
 Initiates a cashout only transaction. Be subscribed to TxFlowStateChanged
 event to get updates on the process.
 
 @param posRefId The unique identifier for the transaction.
 @param amountCents The cashout amount in cents.
 @param surchargeAmount The surcharge amount in cents
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateCashoutOnlyTx:(NSString *)posRefId
                  amountCents:(NSInteger)amountCents
              surchargeAmount:(NSInteger)surchargeAmount
                   completion:(SPICompletionTxResult)completion;

/**
 Let the EFTPOS know whether merchant accepted or declined the signature.
 
 @param accepted YES if merchant accepted the signature from customer or NO otherwise.
 */
- (void)acceptSignature:(BOOL)accepted;

/**
 Submit the code obtained by your user when phoning for auth.
 It will return immediately to tell you whether the code has a valid format or
 not. If valid==true is returned, no need to do anything else. Expect updates
 via standard callback. If valid==false is returned, you can show your user
 the accompanying message, and invite them to enter another code.
 
 @param authCode The alphanumeric 6-character code obtained by your customer from the merchant call centre.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)submitAuthCode:(NSString *)authCode completion:(SPIAuthCodeSubmitCompletionResult)completion;

/**
 Attempts to cancel a transaction.
 Be subscribed to TxFlowStateChanged event to see how it goes.
 Wait for the transaction to be finished and then see whether cancellation was
 successful or not.
 */
- (void)cancelTransaction;

/**
 Initiates a settlement transaction.
 Be subscribed to TxFlowStateChanged event to get updates on the process.
 
 @param posRefId The unique identifier for the transaction.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateSettleTx:(NSString *)posRefId completion:(SPICompletionTxResult)completion;

/**
 Initiates a Mail Order / Telephone Order purchase transaction.
 
 @param posRefId The unique identifier for the transaction.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateSettlementEnquiry:(NSString *)posRefId
                       completion:(SPICompletionTxResult)completion;

/**
 Initiates a get last transaction operation.
 Use this when you want to retrieve the most recent transaction that was
 processed by the EFTPOS. Be subscribed to TxFlowStateChanged to get updates
 on the process.
 */
- (void)initiateGetLastTxWithCompletion:(SPICompletionTxResult)completion;

/**
 This is useful to recover from your POS crashing in the middle of a
 transaction. When you restart your POS, if you had saved enough state, you
 the posRefId that you passed in with the original transaction, and the
 transaction type. This method will return immediately whether recovery has
 started or not. If recovery has started, you need to bring up the transaction
 modal to your user a be listening to TxFlowStateChanged.
 
 @param posRefId The unique identifier for the transaction to be recovered.
 @param txType The transaction type.
 @param completion The completion block returning SPICompletionTxResult asynchronously.
 */
- (void)initiateRecovery:(NSString *)posRefId
         transactionType:(SPITransactionType)txType
              completion:(SPICompletionTxResult)completion;

/**
 Attempts to conclude whether a gltResponse matches an expected transaction
 and returns the outcome. If Success/Failed is returned, it means that the GTL
 response did match, and that transaction was successful/failed. If Unknown is
 returned, it means that the gltResponse does not match the expected
 transaction.
 
 @param gltResponse The gltResponse message to check.
 @param expectedType The expected type (e.g. Purchase, Refund).
 @param expectedAmount The expected amount in cents.
 @param requestDate The time you made your request.
 @param posRefId The reference ID that you passed in with the original request. Currently not used.
 */
- (SPIMessageSuccessState)gltMatch:(SPIGetLastTransactionResponse *)gltResponse
                      expectedType:(SPITransactionType)expectedType
                    expectedAmount:(NSInteger)expectedAmount
                       requestDate:(NSDate *)requestDate
                          posRefId:(NSString *)posRefId DEPRECATED_MSG_ATTRIBUTE("Use gltMatch:gltResponse:posRefId instead.");

/**
 Attempts to conclude whether a gltResponse matches an expected transaction
 and returns the outcome. If Success/Failed is returned, it means that the GTL
 response did match, and that transaction was successful/failed. If Unknown is
 returned, it means that the gltResponse does not match the expected
 transaction.
 
 @param posRefId The reference ID that you passed in with the original request.
 */
- (SPIMessageSuccessState)gltMatch:(SPIGetLastTransactionResponse *)gltResponse posRefId:(NSString *)posRefId;

/**
 Enables Pay-at-Table feature and returns the configuration object.
 
 @return Configuration object handling table and bill requests and responses.
 */
- (SPIPayAtTable *)enablePayAtTable;

/**
 Enables Preauth feature and returns the configuration object.
 
 @return Configuration object handling the dispatch queue.
 */
- (SPIPreAuth *)enablePreauth;

@end
