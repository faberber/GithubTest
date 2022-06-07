global class AggregateResultIterable implements Iterable<AggregateResult> {
  private String query;

  global AggregateResultIterable(String soql){
    query = soql;
    String test;
    String test3;
    String test4;
  }

  global Iterator<AggregateResult> Iterator(){
    return new AggregateResultIterator(query);
  }
}