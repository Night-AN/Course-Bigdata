package top.shaw.bigdata;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IOUtils;

import java.io.*;


public class UploadFile {
    //方便编写代码，直接抛出所有异常
    public static void main(String[] args) throws Exception {
        //1.创建上传所用的文件
        File file = new File("202208764233.txt");
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(file));
        bufferedWriter.write("202208764233");
        bufferedWriter.newLine();
        bufferedWriter.flush();

        //2.编写hdfs的configuration
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS", "hdfs://localhost:9000/");

        //3.将这个文件上传到hdfs
        FileSystem fileSystem = FileSystem.get(configuration);
        //测试用，自动删除文件
        fileSystem.delete(new Path("/mytestdir/" + "202208764233.txt"),true);
        FileInputStream fileInputStream = new FileInputStream(file);
        FSDataOutputStream fsDataOutputStream = fileSystem.create(new Path("/mytestdir/"+"202208764233.txt"));
        IOUtils.copyBytes(fileInputStream, fsDataOutputStream, 4096, true);

        //4.将这个文件从hdfs下载到根路径
        FSDataInputStream fsDataInputStream=fileSystem.open(new Path("/mytestdir/"+"202208764233.txt"));
        FileOutputStream fileOutputStream=new FileOutputStream("/202208764233.txt");
        IOUtils.copyBytes(fsDataInputStream, fileOutputStream, 4096, true);
        bufferedWriter.close();
    }
}
