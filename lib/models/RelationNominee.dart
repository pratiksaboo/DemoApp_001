class RelationNominee {
  final int id;
  final String name;


  const RelationNominee(this.id, this.name);


}

const List<RelationNominee> getLanguages = <RelationNominee>[
  RelationNominee(1, 'Parent'),
  RelationNominee(2, 'Spouse'),
  RelationNominee(3, 'Children'),
  RelationNominee(4, 'Sibling'),
  RelationNominee(5, 'Partner'),
  RelationNominee(6, 'Friend'),
  RelationNominee(7, 'Other'),

];