# Basic image
FROM centos:7.3.1611

# Configuration variables
ENV CONFLUENCE_VERSION	5.10.8
ENV CONFLUENCE_INSTALL	/opt/atlassian/confluence/
ENV CONFLUENCE_HOME  	/var/atlassian/application-data/confluence/

# Add necessary files
ADD 	install-confluence/ /root/install-confluence/
ADD 	docker-scripts/ /root/docker-scripts/

# Run commands
	# General preparation
RUN 	yum update && \
 	adduser confluenceuser && \ 
	# Get the Confluence binary
 	yum install -y wget && \
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
 	yum clean all 

# Do configuration
VOLUME 	["$CONFLUENCE_INSTALL", "$CONFLUENCE_HOME"]
EXPOSE 	8090
ENTRYPOINT ["/root/docker-scripts/docker-entrypoint.sh"]
CMD	["/bin/bash"]

