class Filter {
  final String name;
  final int id;
  final String group;
  final List<int>? includedIds;

  Filter({
    required this.name,
    required this.id,
    required this.group,
    this.includedIds,
  });
}
