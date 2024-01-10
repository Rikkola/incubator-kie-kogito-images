#!/usr/bin/env bash
set -e

properties_add_spot="<\/version>\n\s*<properties>"
dependencies_add_spot="<\/dependencies>\n\s*<build>"
plugins_add_spot="    <plugins>"

insertable_dependency="  <dependency>\n\
      <groupId>org.webjars.npm</groupId>\n\
      <artifactId>sonataflow-deployment-webapp</artifactId>\n\
      <version>\${sonataFlowDeploymentWebapp.version}</version>\n\
    </dependency>\n\
  </dependencies>\n\
  <build>"

plugin_xml="      <plugin>\n\
          <groupId>org.apache.maven.plugins</groupId>\n\
          <artifactId>maven-dependency-plugin</artifactId>\n\
          <executions>\n\
              <execution>\n\
                  <id>unpack-sonataflow-deployment-webapp</id>\n\
                  <phase>process-resources</phase>\n\
                  <goals>\n\
                      <goal>unpack</goal>\n\
                  </goals>\n\
                  <configuration>\n\
                      <artifactItems>\n\
                          <artifactItem>\n\
                              <groupId>org.webjars.npm</groupId>\n\
                              <artifactId>sonataflow-deployment-webapp</artifactId>\n\
                              <version>\${sonataFlowDeploymentWebapp.version}</version>\n\
                              <outputDirectory>\${project.build.directory}/sonataflow-deployment-webapp</outputDirectory>\n\
                          </artifactItem>\n\
                      </artifactItems>\n\
                      <overWriteReleases>false</overWriteReleases>\n\
                      <overWriteSnapshots>true</overWriteSnapshots>\n\
                  </configuration>\n\
              </execution>\n\
          </executions>\n\
      </plugin>\n\
      <plugin>\n\
          <artifactId>maven-resources-plugin</artifactId>\n\
          <executions>\n\
              <execution>\n\
                  <id>copy-sonataflow-deployment-webapp-resources</id>\n\
                  <phase>process-resources</phase>\n\
                  <goals>\n\
                      <goal>copy-resources</goal>\n\
                  </goals>\n\
                  <configuration>\n\
                      <outputDirectory>\${project.basedir}/src/main/resources/META-INF/resources</outputDirectory>\n\
                      <overwrite>true</overwrite>\n\
                      <resources>\n\
                          <resource>\n\
                              <directory>\${project.build.directory}/sonataflow-deployment-webapp/META-INF/resources/webjars/sonataflow-deployment-webapp/\${sonataFlowDeploymentWebapp.version}/dist</directory>\n\
                                <includes>**/*</includes>\n\
                          </resource>\n\
                      </resources>\n\
            </configuration>\n\
          </execution>\n\
        </executions>\n\
      </plugin>\n"

insertable_plugin_xml="${plugins_add_spot}\n${plugin_xml}"

insertable_property="<\/version>\n  <properties>\n    <sonataFlowDeploymentWebapp.version>0.32.0</sonataFlowDeploymentWebapp.version>"

sed -i.bak -e "N;N;s|$properties_add_spot|$insertable_property|" pom.xml
sed -i.bak -e "N;N;s|$dependencies_add_spot|$insertable_dependency|" pom.xml
sed -i.bak -e "N;N;s|$plugins_add_spot|$insertable_plugin_xml|" pom.xml
