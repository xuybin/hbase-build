### Basic Usage
```
docker run -d  -p 222:22 -e ROOT_PASSWORD=123 registry.cn-shenzhen.aliyuncs.com/xuybin/hbase-build
```

After the container is up you are able to ssh in it as root with the in --env provided password for "root"-user.
```
ssh root@IP -p 222
sftp root@IP -p 222