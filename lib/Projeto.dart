import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(Projeto());
}

class Projeto extends StatelessWidget {
  const Projeto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ofertas da Porcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OfertaScreen(),
    );
  }
}

class OfertaScreen extends StatefulWidget {
  @override
  _OfertaScreenState createState() => _OfertaScreenState();
}

class _OfertaScreenState extends State<OfertaScreen> {
  late Database db;

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  // Função para inicializar o banco de dados
  Future<void> _initDB() async {
    db = await initializeDB();
    setState(() {});
  }

  // Inicializa o banco de dados
  Future<Database> initializeDB() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'ofertas_porcher.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ofertas(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, preco_original REAL, preco_com_desconto REAL, descricao TEXT, imagem_url TEXT)",
        );
      },
      version: 1,
    );
  }

  // Função para inserir uma nova oferta
  Future<void> insertOferta(Oferta oferta) async {
    await db.insert(
      'ofertas',
      oferta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {}); // Recarrega as ofertas na tela
  }

  // Função para consultar todas as ofertas
  Future<List<Oferta>> getOfertas() async {
    final List<Map<String, dynamic>> maps = await db.query('ofertas');
    return List.generate(maps.length, (i) {
      return Oferta.fromMap(maps[i]);
    });
  }

  // Função para excluir uma oferta
  Future<void> deleteOferta(int id) async {
    await db.delete(
      'ofertas',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ofertas Porcher'),
      ),
      body: FutureBuilder<List<Oferta>>(
        future: getOfertas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar ofertas.'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma oferta encontrada.'));
          }

          List<Oferta> ofertas = snapshot.data!;
          return ListView.builder(
            itemCount: ofertas.length,
            itemBuilder: (context, index) {
              final oferta = ofertas[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        oferta.imagemUrl,
                        fit: BoxFit.cover,
                        height: 200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            oferta.nome,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            oferta.descricao,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'De R\$ ${oferta.precoOriginal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Por R\$ ${oferta.precoComDesconto.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Oferta adquirida!')),
                              );
                            },
                            child: Text('Comprar Agora', style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                          ),
                          SizedBox(height: 10),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteOferta(oferta.id);
                            },
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Exemplo de como adicionar uma oferta manualmente
          final oferta = Oferta(
            nome: 'Porcher 718',
            precoOriginal: 34999.99,
            precoComDesconto: 29999.99,
            descricao: 'Esportivo de entrada, perfeito para o dia a dia.',
            imagemUrl: 'https://via.placeholder.com/600x300',
          );
          await insertOferta(oferta);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Oferta {
  final int? id;
  final String nome;
  final double precoOriginal;
  final double precoComDesconto;
  final String descricao;
  final String imagemUrl;

  Oferta({
    this.id,
    required this.nome,
    required this.precoOriginal,
    required this.precoComDesconto,
    required this.descricao,
    required this.imagemUrl,
  });

  // Converte a oferta em um mapa para ser armazenado no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco_original': precoOriginal,
      'preco_com_desconto': precoComDesconto,
      'descricao': descricao,
      'imagem_url': imagemUrl,
    };
  }

  // Constrói uma oferta a partir de um mapa do banco de dados
  factory Oferta.fromMap(Map<String, dynamic> map) {
    return Oferta(
      id: map['id'],
      nome: map['nome'],
      precoOriginal: map['preco_original'],
      precoComDesconto: map['preco_com_desconto'],
      descricao: map['descricao'],
      imagemUrl: map['imagem_url'],
    );
  }
}
