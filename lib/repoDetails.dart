class repoDetails{
  final List items;
  repoDetails({required this.items});

  factory repoDetails.fromJson(Map<String, dynamic> json) {
    return repoDetails(
      items: json['items'],
    );
  }
}