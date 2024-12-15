import 'package:api/src/common/config/env.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:stormberry/stormberry.dart';

Future<Connection>? _connection;

  final env = Env();

Middleware databaseProvider(){
  final endpoint = Endpoint(
    database: env.pgDatabase,
    host: env.pgHost,
    password: env.pgPassword,
    port: int.parse(env.pgPort),
    username: env.pgUser,
  );
  _connection ??= Connection.open(endpoint);
 return (handler) {
    return handler.use(provider<Future<Connection>>((_) async {
        final conn = await _connection;
        if (!(conn?.isOpen ?? false) || conn == null) {
          await conn?.close();
          _connection = null;
          return _connection = Connection.open(endpoint);
        }
        return conn;
      }),
    );
  };
}
