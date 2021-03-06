FROM alpine:latest

VOLUME ["/hdfs"]
RUN HBASE_BRANCH=1.2 \
 && URL="https://codeload.github.com/apache/hbase/zip/branch-$HBASE_BRANCH" \

 && apk --update add --no-cache maven wget openssh bash openjdk8 \
 &&	wget -t 10 --max-redirect 1 --retry-connrefused -O "/root/hbase-branch-$HBASE_BRANCH.zip" "$URL" \ 
 && apk del wget \
 
 && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
 && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
 && ssh-keygen -A \
 && ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' \

 && unzip -x -q /root/hbase-branch-$HBASE_BRANCH.zip / && cd hbase-branch-$HBASE_BRANCH && mvn -DskipTests package assembly:single && cd ../ \
 && cp /hbase-branch-$HBASE_BRANCH/hbase-assembly/target/*-bin.tar.gz /root/ \
 && cd /root/ && tar -zcf m2.tar.gz .m2/ \
 && apk del maven && rm -rf /usr/share/java/maven-* /root/.m2 /root/.wget* /root/hbase-branch-$HBASE_BRANCH \
 
 && echo -e '#!/bin/sh\n'\
'echo "root:${ROOT_PASSWORD}" | chpasswd\n'\
'exec /usr/sbin/sshd -D '\
'\n'\
>/usr/local/bin/entrypoint.sh \
 && chmod -v +x /usr/local/bin/entrypoint.sh \
 
 && rm -rf /var/cache/apk/* /tmp/*
 

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 22