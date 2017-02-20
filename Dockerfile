# Basic image
FROM centos:7.3.1611

# Configuration variables
ENV CONFLUENCE_VERSION	5.10.8
ENV CONFLUENCE_INSTALL	/opt/atlassian/
ENV CONFLUENCE_HOME  	/var/atlassian/application-data/
ENV JDK_VERSION		8u112
ENV JDK_BUILD		b15

# Add necessary files
ADD 	install-confluence/ /root/install-confluence/
ADD 	docker-scripts/ /root/docker-scripts/

# Run commands
	# General preparation
RUN 	yum update -y && \
 	adduser confluenceuser && \
	yum install -y python-setuptools && \
	easy_install supervisor && \
 	yum install -y wget && \
	# Install Java
	cd /root && \
	wget --no-cookies \
	--no-check-certificate \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" \
	"http://download.oracle.com/otn-pub/java/jdk/${JDK_VERSION}-${JDK_BUILD}/jdk-${JDK_VERSION}-linux-x64.rpm" && \
	yum install -y jdk-${JDK_VERSION}-linux-x64.rpm && \
	export JAVA_HOME=/usr/bin/java && \
	# Get the Confluence binary
 	cd /root/install-confluence && \
	wget "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONFLUENCE_VERSION}-x64.bin" && \
	# Install Confluence
	chmod 755 atlassian-confluence-${CONFLUENCE_VERSION}-x64.bin && \
	./atlassian-confluence-${CONFLUENCE_VERSION}-x64.bin -q -varfile response.varfile && \
	# Do configuration
 	chmod 777 /root/docker-scripts/docker-entrypoint.sh && \
	chown -R confluence:confluence $CONFLUENCE_INSTALL && \
	chown -R confluence:confluence $CONFLUENCE_HOME && \
	# Do some clean up
	cd /root && \
 	rm -rf /root/install-confluence && \
 	yum clean all -y

# Do configuration
COPY	conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME 	["$CONFLUENCE_INSTALL", "$CONFLUENCE_HOME"]
EXPOSE 	8090 8091
ENTRYPOINT ["/root/docker-scripts/docker-entrypoint.sh"]
CMD	["/bin/bash"]

