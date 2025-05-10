package top.shaw.bigdata;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FSDataInputStream;
import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class DownloadFile {
    public static void main(String[] args) {
        // HDFS文件路径
        String hdfsFilePath = "hdfs://master:9000/foo/bar.txt";
        // 本地文件路径
        String localFilePath = "/foo/bar.txt";

        Configuration conf = new Configuration();
        conf.set("fs.defaultFS", "hdfs://master:9000");

        try (FileSystem fs = FileSystem.get(conf)) {
            // 检查HDFS文件是否存在
            Path hdfsPath = new Path(hdfsFilePath);
            if (!fs.exists(hdfsPath)) {
                System.out.println("HDFS文件不存在: " + hdfsFilePath);
                return;
            }

            // 创建输入流读取HDFS文件
            try (FSDataInputStream inputStream = fs.open(hdfsPath);
                 BufferedInputStream bufferedInputStream = new BufferedInputStream(inputStream);
                 FileOutputStream outputStream = new FileOutputStream(localFilePath)) {

                byte[] buffer = new byte[4096];
                int bytesRead;
                // 读取HDFS文件并写入本地文件
                while ((bytesRead = bufferedInputStream.read(buffer)) > 0) {
                    outputStream.write(buffer, 0, bytesRead);
                }

                System.out.println("文件下载完成: " + localFilePath);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
