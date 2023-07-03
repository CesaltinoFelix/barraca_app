class OnboardContent {
  String? image;
  String? title;
  String? discription;

  OnboardContent({this.image, this.title, this.discription});
}

List<OnboardContent> contents = [
  OnboardContent(
      title: 'Bem-vindo ao "Barraca"! ',
      image: 'assets/images/barraca-splash-screen.json',
      discription:
          "Um aplicativo de faturação intuitivo para ajudar você a gerenciar suas vendas e finanças."),
  OnboardContent(
      title: 'Simplicidade',
      image: 'assets/images/easy.json',
      discription:
          "Barraca é a solução perfeita para empreendedores e pequenas empresas que desejam uma gestão financeira eficiente e sem complicações. "),
  OnboardContent(
      title: 'Interface amigável',
      image: 'assets/images/friendly.json',
      discription:
          "Com uma interface simples e amigável, o Barraca permite que você acompanhe suas vendas, emita faturas, e tenha uma visão clara das suas finanças.  "
          "Tudo de forma fácil e intuitiva. "),
];
