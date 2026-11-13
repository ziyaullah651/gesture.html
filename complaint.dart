enum ComplaintStatus { submitted, acknowledged, inProgress, resolved, rejected }

class Complaint {
  final String id;
  final String title;
  final String category;
  final String location;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;

  const Complaint({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  String get statusLabel => switch (status) {
    ComplaintStatus.submitted => 'Submitted',
    ComplaintStatus.acknowledged => 'Acknowledged',
    ComplaintStatus.inProgress => 'In progress',
    ComplaintStatus.resolved => 'Resolved',
    ComplaintStatus.rejected => 'Needs review',
  };
}
