import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _cadastrarPressionado() async {
    if (_formKey.currentState!.validate()) {
      // Criar um mapa com os dados do usuário
      Map<String, dynamic> usuario = {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'email': _emailController.text,
        'senha': _senhaController.text,

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.inserirUsuario(usuario);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro Realizado Com Sucesso!!')),
      );


      _nomeController.clear();
      _telefoneController.clear();
      _emailController.clear();
      _senhaController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tela de Cadastro',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "BEM VINDO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "A LOJA VIRTUAL DA PORSCHE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  "assets/carro.png",
                  fit: BoxFit.contain,
                  width: 400,
                  height: 280,
                ),
                SizedBox(height: 20),
                Text(
                  "CRIE SUA CONTA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Campos de entrada
                _buildTextField(_nomeController, 'Nome', (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  return null;
                }),
                SizedBox(height: 10),
                _buildTextField(_telefoneController, 'Telefone', (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  return null;
                }),
                SizedBox(height: 10),
                _buildTextField(_emailController, 'Email', (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                      .hasMatch(value)) {
                    return 'Email inválido';
                  }
                  return null;
                }),
                SizedBox(height: 10),
                _buildTextField(_senhaController, 'Senha', (value) {
                  if (value!.isEmpty) return 'Campo obrigatório';
                  if (value.length < 6)
                    return 'Senha deve ter pelo menos 6 caracteres';
                  return null;
                }, obscureText: true),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _cadastrarPressionado,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    padding: EdgeInsets.symmetric(
                      vertical: 7.0,
                      horizontal: 20,
                    ),
                  ),
                  child: Text(
                    'CADASTRAR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String? Function(String?)? validator,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
      validator: validator,
    );
  }
}
