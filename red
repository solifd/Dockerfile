CentOS

CentOS Linux 是一个由社群支持的发行版本，它是由 Red Hat 公开的 Red Hat 企业级 Linux（RHEL）源代码所衍生出来的。因此，CentOS Linux 以兼容 RHEL 的功能为目标。CentOS 计划对组件的修改主要是去除上游提供者的商标及美工图。CentOS Linux 是免费的及可自由派发的。每个 CentOS 版本均获得长达十年的维护（通过安全更新 —— 支持期的长短取决于 Red Hat 发行的源代码的更改）。新版本的 CentOS 大约每两年发行一次，而每个版本的 CentOS 更会定期（大概每六个月）更新一次，以便支持新的硬件。这最终构建了一个安全的、低维护的、稳定的、高预测性的、高重复性的 Linux 环境。

来自 wiki.centos.org

如何使用 CentOS 镜像

该镜像使用 CentOS 官方镜像制作，推荐最小规格为微小型。

小版本标签及 Dockerfile

所有镜像均安装了 openssh-server 以提供 ssh 登录功能。

6.5

FROM centos6.5:base2
MAINTAINER netease

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum install -y glibc openssh-server
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN echo "RSAAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
RUN yum clean all    

EXPOSE 22    

CMD ["/usr/sbin/sshd", "-D"]
6.7

FROM centos:6.7-base
MAINTAINER netease

RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum install -y openssh-server && yum clean all
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config    

EXPOSE 22    

CMD ["/usr/sbin/sshd", "-D"]
7-command

yum 源更换为网易源，并安装了常用软件 openssh-server、vim、tar、wget、curl、rsync、bzip2、iptables、tcpdump、less、telnet、net-tools、lsof。

FROM hub.c.163.com/netease_comb/centos:7
MAINTAINER netease

# 更新yum源
RUN yum makecache fast && yum -y update glibc    

# 安装常用软件
RUN yum install -y openssh-server vim tar wget curl rsync bzip2 iptables tcpdump less telnet net-tools lsof
# 初始化ssh登陆
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
RUN echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config    

RUN yum clean all

# 启动sshd服务并且暴露22端口
RUN mkdir /var/run/sshd    

EXPOSE 22    

CMD ["/usr/sbin/sshd", "-D"]
7.0 & 7.2.1511

yum 源更换为网易源。

FROM scratch
MAINTAINER netease
ADD centos-7-docker.tar.xz /    

LABEL name="CentOS Base Image" \
    vendor="CentOS" \
    license="GPLv2" \
    build-date="20160701"    

ADD CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo
# 安装常用软件
RUN yum install -y openssh-server
# 初始化ssh登陆
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
RUN ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
RUN echo "RSAAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config    

RUN yum clean all

# 启动sshd服务并且暴露22端口
RUN mkdir /var/run/sshd    

EXPOSE 22    

CMD ["/usr/sbin/sshd", "-D"]
