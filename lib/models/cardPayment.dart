class CardPayment {
  final double amount;
  final String country;
  final String currency;
  final String email;
  final String firstName;
  final String lastName;
  final String narration;
  final String txRef;
  final String acceptMpesaPayments;
  final String acceptAccountPayments;
  final String acceptCardPayments;
  final String acceptAchPayments;
  final String acceptGHMobileMoneyPayments;
  final String acceptUgMobileMoneyPayments;
  final String displayEmail;
  final String displayAmount;
  final String staging;
  final String isPreAuth;
  final String displayFee;

  CardPayment(
      this.amount,
      this.country,
      this.currency,
      this.email,
      this.firstName,
      this.lastName,
      this.narration,
      this.txRef,
      this.acceptMpesaPayments,
      this.acceptAccountPayments,
      this.acceptCardPayments,
      this.acceptAchPayments,
      this.acceptGHMobileMoneyPayments,
      this.acceptUgMobileMoneyPayments,
      this.displayEmail,
      this.displayAmount,
      this.staging,
      this.isPreAuth,
      this.displayFee);
}
