import '../entities/tokens_auth.dart';
import '../repositories/i_auth_repository.dart';

class RefrescarTokenUc {
  final IAuthRepository _repo;
  RefrescarTokenUc(this._repo);

  Future<TokensAuth> call(String refresh) => _repo.refrescarToken(refresh);
}
