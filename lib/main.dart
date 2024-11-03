import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/transitions.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    // GoRoute(
    //     path: '/',
    // builder: (context, state) => const MyHomePage(child: SizedBox())),
    ShellRoute(
      pageBuilder: (context, state, widget) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: MyHomePage(state: state, child: widget),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      routes: [
        GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                noTransition(state.pageKey, Container(color: Colors.blue)),
            routes: [
              GoRoute(
                path: 'product',
                pageBuilder: (context, state) => pageTransition(state.pageKey, const ProductPage()),
                routes: [
                  GoRoute(
                    path: 'product2',
                    name: 'p2',
                    pageBuilder: (context, state) => pageTransition(state.pageKey, const ProductPage2()),
                  ),
                ]
              ),

            ]),
        GoRoute(
          path: '/a',
          pageBuilder: (context, state) =>
              noTransition(state.pageKey, Container(color: Colors.red)),
        ),
        GoRoute(
          path: '/b',
          pageBuilder: (context, state) =>
              noTransition(state.pageKey, Container(color: Colors.green)),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const MyHomePage({super.key, required this.child, required this.state});

  @override
  Widget build(BuildContext context) {
    // final contains = ['/', '/a', '/b'].any((e) => state.fullPath == e);
    final contains = context.isDesktop;
    return Scaffold(
      appBar: contains
          ? AppBar(
              title: const Text('GoRouter Test'),
            )
          : null,
      body: child,
      bottomNavigationBar: contains
          ? BottomNavigationBar(
              onTap: (index) {
                if (index == 0) {
                  context.go('/');
                } else if (index == 1) {
                  context.go('/a');
                } else if (index == 2) {
                  context.go('/b');
                }
              },
              items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.heart_broken), label: 'like'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.fire_truck), label: 'fire'),
                ])
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/product');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.heart_broken),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Product Page'),
            Text('Counter: $counter'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('p2');
        },
        tooltip: 'Switch Page',
        child: const Icon(Icons.baby_changing_station),
      ),
    );
  }
}

class ProductPage2 extends StatelessWidget {
  const ProductPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Product Page 2'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.fire_extinguisher),
      ),
    );
  }
}
