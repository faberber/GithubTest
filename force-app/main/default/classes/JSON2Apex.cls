public class JSON2Apex {

	public Integer count;
	public List<Entries> entries;

	public class Entries {
		public String API;
		public String Description;
		public String Auth;
		public Boolean HTTPS;
		public String Cors;
		public String Link;
		public String Category;
	}

	
	public static JSON2Apex parse(String json) {
		return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
	}
}