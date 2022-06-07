global class AggregateResultIterable implements Iterable<AggregateResult> {
  private String query;

  global AggregateResultIterable(String soql){
    query = soql;
    String test;
  }

  global Iterator<AggregateResult> Iterator(){
    return new AggregateResultIterator(query);
  }
}