import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class SignInUseCase implements UseCase<Either, SignInUserReq> {
  @override
  Future<Either> call({SignInUserReq? params}) {
    return sl<AuthRepository>().signin(params!);
  }
}
