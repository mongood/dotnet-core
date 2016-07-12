以debian:latest为基础镜像构建.NET Core环境，Dockerfile文件内容如下：

    FROM debian:latest
    MAINTAINER Mongo <willem@xcloudbiz.com>

    RUN apt-get update \
        && apt-get -y install curl libunwind8 gettext libicu52 \
        && cd /opt \
        && curl -sSL -o dotnet.tar.gz https://go.microsoft.com/fwlink/?LinkID=809130 \
        && mkdir -p /opt/dotnet \
        && tar zxf dotnet.tar.gz -C /opt/dotnet \
        && ln -s /opt/dotnet/dotnet /usr/local/bin \
        && apt-get -y autoremove --purge curl gettext \
        && rm -rf dotnet.tar.gz /var/lib/apt/lists/* \
        && apt-get autoclean

在Dockerfile文件相同目录下构建镜像：

    docker build -t dotnet-core .

部署的demo文件：下载链接( http://pan.baidu.com/s/1nuIESFv )；
要发布的文件也在当前目录下，文件夹名称为demo:

    docker run --rm -ti -p 11001:5000 -v $(pwd)/virgo-api-demo:/apidemo dotnet-core

在启动容器后需要运行应用（注意修改对应的运行dll文件）：

    cd /apidemo
    dotnet Virgo.WebApi.dll --server.urls http://*:5000

然后在其他主机上用浏览器访问：

    http://hostip:11001/api/values

如果返回结果如下则正常：

    ["value1","value2"]

如果想要以后台的方式运行最好在进行一步构建操作，Dockerfile文件内容如下：

    FROM dotnet-core
    MAINTAINER Mongo <willem@xcloudbiz.com>
    
    EXPOSE 5000 
    ADD virgo-api-demo /apidemo
    WORKDIR /apidemo
    CMD dotnet Virgo.WebApi.dll --server.urls http://*:5000

构建镜像：

    docker build -t core-api .

启动容器：

    docker run -d -p 11002:5000 --name coreapi --restart always core-api

接下来的访问操作和结果同上。
