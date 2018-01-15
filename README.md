### Basic Usage
```
$ docker run --rm \
--publish=222:22 \
--env ROOT_PASSWORD=123 \
registry.cn-shenzhen.aliyuncs.com/xuybin/hbase-build
```

After the container is up you are able to ssh in it as root with the in --env provided password for "root"-user.
```
$ ssh root@IP -p 222