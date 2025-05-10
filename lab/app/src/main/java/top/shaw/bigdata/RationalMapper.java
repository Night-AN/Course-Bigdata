package top.shaw.bigdata;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

public class RationalMapper extends Mapper<LongWritable,Text,Text,IntWritable> {

    public void map(LongWritable key,Text value,Context context)
            throws IOException,InterruptedException{
        String[] strs = value.toString().split(",");
        if(strs.length==3){
            context.write(value, new IntWritable(1));
        }
    }
}
