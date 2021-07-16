FROM amazoncorretto:8

ENV PDI_VERSION=9.0 PDI_BUILD=9.0.0.0-423

# Download from http://downloads.sourceforge.net/project/pentaho/Data%20Integration/client-tools
COPY install/pdi-ce-${PDI_BUILD}.zip .

RUN yum install -y unzip

RUN unzip -q pdi-ce-${PDI_BUILD}.zip \
	&& rm pdi-ce-${PDI_BUILD}.zip

# Multistage build to get rid of the cruft
FROM amazoncorretto:8

COPY --from=0 /data-integration /data-integration

RUN yum install -y unzip jq

# install the aws cli and a script to download from S3 into the inputs folder
RUN yum install -y python3-pip && pip3 install pip --upgrade && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    aws --version

COPY aws-s3-download.sh /

# Run a test job to verify the install works
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/bin/aws:/data-integration \
    KETTLE_HOME=/data-integration

RUN ls -l ./

# Aditional Drivers
WORKDIR $KETTLE_HOME

# First time run
RUN pan.sh -file ./plugins/platform-utils-plugin/samples/showPlatformVersion.ktr \
	&& kitchen.sh -file samples/transformations/files/test-job.kjb

ENV KETTLE_HOME=/jobs
WORKDIR $KETTLE_HOME

# Intentionally commented out, LEFT IN FOR TESTING.  Normally we want a random ID
# COPY ecs-example.json /

COPY pentaho.sh /
RUN chmod +x /pentaho.sh /aws-s3-download.sh

ENTRYPOINT ["sh", "/pentaho.sh"]
CMD ["help"]