import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Cores
const corNavBar = Color(0xffffffff);
const corAppBar = Color(0xffa9def9);
const splashBackgorund = Color(0xffffffff);
const backgroundNavBar = Color(0xffa9def9);
const corIconenaoselecionado = Color(0xff565f81);

// Configuração AppBar
const appBarAtivo = true;
const appBarPagina = 1;
const appBarTexto = 'Digite algo para pesquisar...';
const appBarUrlPesquisa = 'https://www.papelariaunicornio.com.br/loja/?pesquisar-por=';
const appBarIcone = Icon(Icons.search);

// OneSignal
const signalId = 'a85a44ad-1276-461b-a5c5-653671a7e97e';
const signalAdicional = 'url';

// Urls
const List<String> urlsList = [
'https://www.papelariaunicornio.com.br',
'https://www.papelariaunicornio.com.br/caixasurpresa?utm_source=app&utm_medium=umcliquedigital',
'https://www.papelariaunicornio.com.br/loja/redirect_cart_service.php?loja=847325&utm_source=app&utm_medium=umcliquedigital',
'https://www.clubeunibox.com.br/?utm_source=app&utm_medium=umcliquedigital',
'https://app.umcliquedigital.com.br/unicornio-mais?utm_source=app&utm_medium=umcliquedigital'
];
final urlPermitidas = ['https://www.papelariaunicornio.com.br','https://app.umcliquedigital.com.br','https://avali.ar','https://google.com','https://widget.fidelizarmais.com','https://www.google.com','https://i-goal.com.br','https://www.i-goal.com.br','https://cliente.i-goal.com.br','https://snapwidget.com','https://www.clubeunibox.com.br','https://ct.pinterest.com','https://www.youtube.com'];
const urlInicial = 'https://www.papelariaunicornio.com.br';
const urlAnterior = 'https://www.papelariaunicornio.com.br';
const urlAtual = 'https://www.papelariaunicornio.com.br';
const urlDiferenteDe = 'https://www.papelariaunicornio.com.br';//->>> Abrir url em navegador externo, as url diferente de

//Textos
const textoOff = 'Você está desconectado!';
//Textos navBar
const textoNav0 = "Início";
const textoNav1 = "Caixa Surpresa";
const textoNav2 = "Carrinho";
const textoNav3 = "Clube";
const textoNav4 = "Mais";

// Imagens
const imageSplash = 'assets/splash.png';
const imageDisconnect = 'assets/disconected.png';
//Imagens navBar
const imageNav0 = 'assets/icons/home.png';
const imageNav1 = 'assets/icons/box.png';
const imageNav2 = 'assets/icons/cart.png';
const imageNav3 = 'assets/icons/heart.png';
const imageNav4 = 'assets/icons/more.png';

// Webview
const userAgente = 'UmCliqueDigital';




