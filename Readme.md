#大数据核心技术文档

lab是实验的代码和文档

Dockerfile为特权容器的Dockerfile
Dockerfile-unprivilege为非特权容器的Dockerfile
自行构建

lab的app中使用maven进行fatjar打包

进入app
键入
```shell
mvn package
```
即可打包各个实验的jar包
