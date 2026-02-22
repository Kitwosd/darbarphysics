part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class InitializePaymentEvent extends PaymentEvent {
  final int courseId;

  const InitializePaymentEvent({required this.courseId});
}

class VerifyPaymentEvent extends PaymentEvent {
  final String pidx;
  const VerifyPaymentEvent({required this.pidx});
}

class ResetStatesEvent extends PaymentEvent{
  
}