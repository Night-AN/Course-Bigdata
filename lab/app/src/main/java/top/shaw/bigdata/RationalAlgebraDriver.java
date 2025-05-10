package top.shaw.bigdata;


import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.Tool;

public class RationalAlgebraDriver{

    public static void main(String[] args)throws Exception {
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS", "hdfs://localhost:9000/");
        Job job=Job.getInstance(configuration,"RationalAlgebra");
        job.setJarByClass(RationalAlgebraDriver.class);
        FileInputFormat.addInputPath(job,new Path("hdfs://localhost:9000/test/S.txt"));
        FileInputFormat.addInputPath(job,new Path("hdfs://localhost:9000/test/R.txt"));
        job.setMapperClass(RationalMapper.class);
        job.setReducerClass(RationalReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(NullWritable.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);
        FileOutputFormat.setOutputPath(job, new Path("hdfs://localhost:9000/test_out"));
        if(!job.waitForCompletion(true))return;
    }
}