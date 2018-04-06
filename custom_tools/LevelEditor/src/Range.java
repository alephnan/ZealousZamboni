
public class Range {
	public final int start;
	public final int end;
	public Range(int s, int e){
		start = s;
		end = e;
	}
	
	@Override public String toString(){
		return "("+start+"-"+end+")";
	}
}
