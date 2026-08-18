enum TenderStatus { active, closed }

class Tender {
  const Tender({
    required this.id,
    required this.title,
    required this.status,
    required this.amountInTiyin,
  });

  final int id;
  final String title;
  final TenderStatus status;
  final int amountInTiyin;
}
