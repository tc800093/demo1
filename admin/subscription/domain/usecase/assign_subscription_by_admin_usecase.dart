import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/repository/subscription_repository.dart';

class AssignSubscriptionByAdminUsecase
    implements UseCase<String, AssignSubscriptionParams> {
  final SubscriptionRepository repository;
  AssignSubscriptionByAdminUsecase({required this.repository});
  @override
  Future<Either<Failure, String>> call(AssignSubscriptionParams params) async {
    return await repository.assingPlanToUserRepo(params: params);
  }
}

class AssignSubscriptionParams {
  final String userId;
  final String planId;
  final DateTime startDate;
  final DateTime expiryDate;
  final DateTime paymentDate;
  final String status;
  final String paymentType;
  final String paymentMode;
  final String transactionId;
  final double amount;
  final String remarks;

  AssignSubscriptionParams({
    required this.amount,
    required this.expiryDate,
    required this.paymentDate,
    required this.paymentMode,
    required this.paymentType,
    required this.planId,
    required this.remarks,
    required this.startDate,
    required this.status,
    required this.transactionId,
    required this.userId,
  });
}
