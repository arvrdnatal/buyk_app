import 'package:buyk_app/app/pages/mercadinho/mercadinho_controller.dart';
import 'package:flutter/material.dart';

class Mercadinho extends StatefulWidget {
  const Mercadinho({Key? key}) : super(key: key);

  @override
  _MercadinhoState createState() => _MercadinhoState();
}

class _MercadinhoState extends State<Mercadinho> {
  final _controller = MercadinhoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mercadinho'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.account_circle_rounded), onPressed: () => _controller.meuPerfil(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => _controller.adicionarObra(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tituloRecentes(),
          _livrosRecentes(),
        ],
      ),
    );
  }

  Widget _tituloRecentes() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Text('Veja as novidades:', style: Theme.of(context).textTheme.headline3),
    );
  }

  Widget _livrosRecentes() {
    return Expanded(
      child: GridView.count(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 3,
        padding: const EdgeInsets.only(right: 20, left: 20),
        childAspectRatio: (512 * 0.25) / (800 * 0.25),
        children: const [
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.amber),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.blue),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.deepOrange),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.teal),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.pink),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.lightGreen),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.redAccent),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.orange),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.indigo),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.red),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.deepPurple),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.amber),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.blue),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.deepOrange),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.teal),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.pink),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.lightGreen),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.redAccent),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.orange),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.indigo),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.red),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
          DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadiusDirectional.all(Radius.circular(2)), color: Colors.deepPurple),
            child: SizedBox(height: 800 * 0.25, width: 512 * 0.25),
          ),
        ],
      ),
    );
  }
}
