import java.util.Arrays;
import java.util.Iterator;
import java.util.List;


//A list of ranges, ie [(1,4),(5,6),(7,12)]
public class RangeList implements Iterable<Integer>{
	private List<Range> ranges;
	
	@Override public String toString(){
		return ranges.toString();
	}
	public static final RangeList DEFAULT = new RangeList(Arrays.asList(new Range(0,1)));
	public RangeList(List<Range> ranges){
		this.ranges = ranges;
	}
	
	@Override
	public Iterator<Integer> iterator() {
		return new Iterator<Integer>(){
			int ri = 0;
			int i = ranges.get(ri).start;
			@Override
			public boolean hasNext() {
				return !ranges.isEmpty();
			}

			@Override
			public Integer next() {
				if(i >= ranges.get(ri).end){
					ri++;
					if(ri >= ranges.size()){
						ri = 0;
					}
					i = ranges.get(ri).start;
				}
				return i++;
			}

			@Override
			public void remove() {
				throw new UnsupportedOperationException();
			}
			
		};
	}
	

}
