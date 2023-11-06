import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.consentRequired(true);
  OneSignal.consentGiven(true);
  OneSignalPushSubscription();
  OneSignal.Notifications.requestPermission(true);
  OneSignal.initialize(signalId);

  runApp(MyApp(
  ));
}


// -------> Inicializa o App com o SplashScreen
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  void _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Tempo da splash screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => WebViewScreen()), // Tela principal
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashBackgorund, // Cor de fundo da splash screen
      body:

        Center(
          child:
          Image.asset(imageSplash, width: 250,), // Imagem da Splash
        ),

    );
  }
}
//-------> Classe principal

class WebViewScreen extends StatefulWidget {

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  late WebViewController _webViewController;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String currentUrl = urlAtual;
  String previousUrl = urlAnterior;

  String initialUrl = urlInicial;
  int _previousIndex = 0;


  int _selectedIndex = 0;

  bool _isConnected = true;
  TextEditingController _searchController = TextEditingController();

// Essa é uma lista de url para o seu nav, se usar menos ou mais nav, precisa ter o mesmo tamanho da lista abaixo.
//   final List<String> bottomNavUrls = [
//     'https://locacao027.com.br/',
//     'https://locacao027.com.br/Shoppingcart/checkout',
//     'https://locacao027.com.br/shop/featured',
//     'https://lp.locacao027.com.br/podcast2/',
//     'https://locacao027.com.br/shop/my_account'
//   ];
  bool isUrlAllowed(String url) {
    urlPermitidas;

    for (final allowedUrl in urlPermitidas) {
      if (url.startsWith(allowedUrl)) {
        return true;
      }
    }

    return false;
  }

  void onTabTapped(int index) {
    setState(() {
      if (index != _selectedIndex) {
        if (urlsList.contains(currentUrl)) {
          setState(() {
            _previousIndex = _selectedIndex;
            updateSelectedIndex(index); // Update _selectedIndex
            _selectedIndex = index;
            print(_selectedIndex);
            print('Está na navUrls');
          });
        }
        // Atualiza _selectedIndex com o novo índice
        _selectedIndex = index;
        previousUrl = currentUrl;
        currentUrl = urlsList[index];
        _webViewController.loadUrl(currentUrl);
        print(currentUrl);
      }
    });
  }
  _launchURL(String _url) async {
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });

    OneSignal.Notifications.addClickListener((notification) {
      var urlPush = notification.notification.additionalData?[signalAdicional];
      print(urlPush);
      _webViewController.loadUrl(urlPush);
    });
  }
  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      print("selected $_selectedIndex");
      print(index);
    });
  }

  bool _isInitialIndex() {
    return _selectedIndex == 0;
  }


  @override
  void dispose() {
    // Libere o controlador ao sair do widget.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_isConnected) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
          children: [
            Center(
              child: Image.asset(imageDisconnect, width: 200, height: 200),
            ),
            const Text(textoOff),
          ],
        ),
      );
    }

    return WillPopScope(
        onWillPop: () async {
      // Verifique se o WebView pode voltar
      if (_webViewController != null && await _webViewController.canGoBack()) {
    // Se o WebView puder voltar, faça isso e atualize a variável de estado.
    _webViewController.goBack();
    //currentUrl = previousUrl;
    if (_selectedIndex != _previousIndex) {
      // If not at the previous index, go back to the previous index
      setState(() {
        _selectedIndex = _previousIndex;
      });
    } else {
      return false;
    }

    return false; // Não deixe o Flutter voltar para a tela anterior.
    }
    return true; // Deixe o Flutter controlar o comportamento padrão de voltar.
    },
    child: Scaffold(

      appBar: PreferredSize(
    preferredSize: const Size.fromHeight(appBarTamanho), // altura
    child: appBarAtivo == true && _selectedIndex == appBarPagina
          ? AppBar(
        centerTitle: true,
        backgroundColor: corAppBar, // Cor de fundo do AppBar
        elevation: 0, // Sem sombra
        title: Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Padding para o campo de pesquisa
          decoration: BoxDecoration(
            color: Colors.grey[200], // Cor de fundo do campo de pesquisa
            borderRadius: BorderRadius.circular(9.0), // Borda arredondada
          ),
          child: Row(
            children: [
               appBarIcone, // Ícone de pesquisa à direita
              const SizedBox(width: 8.0), // Espaço entre o ícone e o campo de pesquisa
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) {
                    // Quando o usuário pressionar Enter, faça algo com o valor inserido
                    // Por exemplo, construa a URL e carregue-a no WebView
                    final url = '$appBarUrlPesquisa$value';
                    _webViewController.loadUrl(url);
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none, // Sem borda
                    hintText: appBarTexto,
                  ),
                ),
              ),
            ],
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.clear), // Ícone para limpar o campo de pesquisa
        //     onPressed: () {
        //       // Limpe o campo de pesquisa
        //       _searchController.clear();
        //     },
        //   ),
        // ],
      )
          : AppBar(
        centerTitle: true,
        backgroundColor: corAppBar, // Cor de fundo do AppBar
        elevation: 0, // Sem sombra
      ),
      ),
      bottomNavigationBar:BottomNavigationBar(
        backgroundColor: backgroundNavBar,
        onTap: onTabTapped,
        selectedItemColor: corNavBar,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[


          BottomNavigationBarItem(
            icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,  // nova cor
                  BlendMode.color,
                ),child: ImageIcon(AssetImage(imageNav0), color:navBarIconCor)),// -> Icone
            label: textoNav0, // -> Descrição
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,  // nova cor
                  BlendMode.color,
                ),child: ImageIcon(AssetImage(imageNav1), color:navBarIconCor)),
            label: textoNav1,
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,  // nova cor
                  BlendMode.color,
                ),child: ImageIcon(AssetImage(imageNav2), color:navBarIconCor)),
            label: textoNav2,
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,  // nova cor
                  BlendMode.color,
                ),child: ImageIcon(AssetImage(imageNav3), color:navBarIconCor)),
            label: textoNav3,
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.transparent,  // nova cor
                  BlendMode.color,
                ),child: ImageIcon(AssetImage(imageNav4), color:navBarIconCor)),
            label: textoNav4,
          ),
        ],
      ),
      body: SafeArea(
        child: WebView(
          onWebResourceError: (WebResourceError error) {
            if (error.errorType == WebResourceErrorType.connect) {
              setState(() {
                _isConnected = false;
              });
            }
          },
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: false,
          //definindo o userAgent
          userAgent: '$userAgente Mozilla/5.0 (Linux; Android 10; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Mobile Safari/537.36',
          onWebViewCreated: (controller) {
            _webViewController = controller;

          },
          onPageFinished: (url) {
            _webViewController.evaluateJavascript(
                "document.body.style.zoom = '95%'");
            previousUrl = currentUrl;
            currentUrl = url;
            print(url);
            _webViewController.evaluateJavascript("""
var selectorsToHide = [
    '.banner--extra6',
    'footer',
    '#msg_especial',
    '.header_logo_image'
];

selectorsToHide.forEach(function(selector) {
    var elements = document.querySelectorAll(selector);
    for (var i = 0; i < elements.length; i++) {
        elements[i].style.display = 'none';
    }
});

var headerElements = document.querySelectorAll('.header');
for (var i = 0; i < headerElements.length; i++) {
    headerElements[i].style.position = 'absolute';
}

var corpoElement = document.getElementById('corpo');
if (corpoElement) {
    corpoElement.style.marginTop = '60px';
    corpoElement.style.paddingTop = '0px';
}
        """);

          },
          gestureNavigationEnabled: true,
          navigationDelegate: (NavigationRequest request) {
            final url = request.url;
            if (isUrlAllowed(url)) {
              print("XXXXXXXXXXXXXXXXXXXXXXXXXXXX$_selectedIndex");
              print('CURRENT > $currentUrl');
              print('URL > $url');
              if (urlsList.contains(url)) {
                setState(() {
                    updateSelectedIndex(urlsList.indexOf(url));
                    print(">>>>>>>>>>>>>>>>>>>>>>CONTEM");
                });
              } else {
                print(">>>>>>>>>>>>>>>>>>NAO CONTEM");
              }
              return NavigationDecision.navigate;
            } else {
              if (url != url.startsWith(urlDiferenteDe) || url.startsWith('https://api.whatsapp.com/') || url.startsWith('http://google.com.br/')) {
                // URLs externas acima ou lista
                _launchURL(url); // Abra a URL em um navegador externo.
                return NavigationDecision.prevent;
              } else {
                // URLs que não começam com "http" ou "https", como URLs locais.
                return NavigationDecision.navigate;
              }
            }
          },
        ),

      ),
    ),
    );
  }

}
