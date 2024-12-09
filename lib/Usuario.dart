import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Usuario{
  static Usuario? _Usuario;

  // Nome da tabela de usuários
  static const String tableName = 'usuarios';

  // Nome do banco de dados
  static const String dbName = 'app_data.db';

  // Conectar ao banco de dados
  Future<Database> get Usuarioasync {
    if (_Usuario != null) return _Usuario!;

    _Usuario = await _initUsuario();
    return _Usuario!;
  }

  // Inicializar o banco de dados
  Future<Database> _initUsuario() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          telefone TEXT,
          email TEXT NOT NULL UNIQUE,
          senha TEXT NOT NULL,
          data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
    });
  }

  // Inserir um novo usuário no banco
  Future<int> inserirUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert(tableName, usuario);
  }

  // Buscar todos os usuários
  Future<List<Map<String, dynamic>>> buscarUsuarios() async {
    final db = await database;
    return await db.query(tableName);
  }

  // Buscar um usuário pelo ID
  Future<Map<String, dynamic>?> buscarUsuarioPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Atualizar um usuário
  Future<int> atualizarUsuario(int id, Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.update(
      tableName,
      usuario,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Deletar um usuário
  Future<int> deletarUsuario(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}