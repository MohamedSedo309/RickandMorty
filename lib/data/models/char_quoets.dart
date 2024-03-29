// This is a random quote
class Char_Quote {
  late String quote;

  Char_Quote.fromjson(Map<String, dynamic> json) {
    quote = json["content"];
  }
}
