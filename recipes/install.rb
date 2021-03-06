#
# Author:: Ben Newton (<ben@sumologic.com>)
# Cookbook Name:: sumologic-collector
# Recipe:: Install Sumo Logic Collector
#
#
# Copyright 2013, Sumo Logic
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install Steps:
# 1. Download collector installer
# 2. Do a quiet install
#
# Quiet install looks for /etc/sumo.conf file for automated activation
#
# Sumo Logic Help Links
# https://service.sumologic.com/ui/help/Default.htm#Unattended_Installation_from_a_Linux_Script_using_the_Collector_Management_API.htm
# https://service.sumologic.com/ui/help/Default.htm#Using_sumo.conf.htm
# https://service.sumologic.com/ui/help/Default.htm#JSON_Source_Configuration.htm
#

Chef::Log.info "Starting Installation."

Chef::Log.info "  Creating Sumo Logic director at #{node['sumologic']['installDir']}"

case node[:platform]
when 'redhat', 'centos'
  remote_file "/tmp/sumocollector_19.127-3_amd64.rpm" do
    source node['sumologic']['collectorRPMUrl']
    mode 0644
  end

  rpm_package "sumocollector" do
    source "/tmp/sumocollector_19.127-3_amd64.rpm"
    action :install
  end
when 'ubuntu', 'debian'
  remote_file "/tmp/sumocollector_19.127-3_amd64.deb" do
    source node['sumologic']['collectorDEBUrl']
    mode 0644
  end

  dpkg_package "sumocollector" do
    source "/tmp/sumocollector_19.127-3_amd64.deb"
    action :install
  end
when 'windows'
  remote_file "#{node['sumologic']['installDir']}/#{node['sumologic']['installerName']}" do
    source node['sumologic']['downloadURL']
    notifies :run, 'execute[run-installer]'
  end

  Chef::Log.info "  Installing Sumo Logic director at #{node['sumologic']['installDir']}"

  execute "run-installer" do
    command node['sumologic']['installerCmd']
    cwd node['sumologic']['installDir']
    action :nothing
  end
end
