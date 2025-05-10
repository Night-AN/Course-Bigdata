package top.shaw.bigdata;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class RationalReducer extends Reducer<Text,IntWritable,Text,NullWritable> {
    protected void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {
        int count = 0;
        for(IntWritable value:values){
            ++count;
        }
        if(count == 2)
            context.write(key, NullWritable.get());
    }
}
