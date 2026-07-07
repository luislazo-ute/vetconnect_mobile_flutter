/// Par de tokens JWT devueltos por el login.
class TokensAuth {
  final String access;
  final String refresh;

  const TokensAuth({required this.access, required this.refresh});
}
