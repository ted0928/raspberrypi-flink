###############################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

FROM ubuntu

# Install dependencies
RUN set -ex; \
  apt-get update;

RUN set -ex; \
  apt-get -y install openjdk-8-jre wget libsnappy1v5 gettext-base vim; \
  rm -rf /var/lib/apt/lists/*

# Configure Flink version
ENV FLINK_VERSION=1.9.2 \
    SCALA_VERSION=2.11

# Prepare environment
ENV FLINK_HOME=/opt/flink
ENV PATH=$FLINK_HOME/bin:$PATH
RUN groupadd --system --gid=9999 flink && \
    useradd --system --home-dir $FLINK_HOME --uid=9999 --gid=flink flink
WORKDIR $FLINK_HOME

ENV FLINK_URL_FILE_PATH=flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_${SCALA_VERSION}.tgz
# Not all mirrors have the .asc files
ENV FLINK_TGZ_URL=http://mirrors.tuna.tsinghua.edu.cn/apache/${FLINK_URL_FILE_PATH}

# Install Flink
RUN set -ex; \
  wget -nv -O flink.tgz "$FLINK_TGZ_URL"; \
  tar -xf flink.tgz --strip-components=1; \
  chown -R flink:flink .;

# Replace MaxDirectMem
RUN sed 's#8388607T#128M#g' -i  bin/taskmanager.sh

# System Conf
RUN echo "Asia/Shanghai" > /etc/timezone

# Copy flink console shell
COPY flink-console.sh bin/flink-console.sh
RUN chown flink:flink bin/flink-console.sh

# Configure container
COPY docker-entrypoint.sh /
RUN chown flink:flink /docker-entrypoint.sh
EXPOSE 6123 6124 6125 8081
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]
