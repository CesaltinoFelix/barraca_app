String gerarCodigoFatura() {
  DateTime dataAtual = DateTime.now();

  // Obtendo os valores da data e hora
  String dia = dataAtual.day.toString().padLeft(2, '0');
  String mes = dataAtual.month.toString().padLeft(2, '0');
  String ano = dataAtual.year.toString();
  String hora = dataAtual.hour.toString().padLeft(2, '0');
  String minutos = dataAtual.minute.toString().padLeft(2, '0');
  String segundos = dataAtual.second.toString().padLeft(2, '0');
  String milissegundos = dataAtual.millisecond.toString().padLeft(3, '0');

  // Construindo o código único da fatura
  String codigoFatura = '$ano$mes$dia$hora$minutos$segundos$milissegundos';

  return codigoFatura;
}
