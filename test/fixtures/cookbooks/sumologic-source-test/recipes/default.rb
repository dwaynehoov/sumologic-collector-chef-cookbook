#
# Cookbook Name:: sumologic-source-test
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
node.default['sumologic']['use_json_path_dir'] = true

include_recipe 'sumologic-collector::sumoconf'
include_recipe 'sumologic-collector::sumojsondir'

case node['platform_family']
when 'windows'
  sumologic_source 'Windos Event Logs' do
    source_json '{
      "api.version": "v1",
      "source":
        {
          "name": "Windows Event Logs",
          "sourceType": "LocalWindowsEventLog",
          "logNames": [ "Application", "System" ]
        }
      }'
  end
when 'rhel'
  sumologic_source 'messages' do
    source_json '{
      "api.version": "v1",
      "source":
        {
          "name": "Messages",
          "sourceType": "LocalFile",
          "pathExpression": "/var/log/messages"
        }
      }'
  end
when 'debian'
  sumologic_source 'messages' do
    source_json '{
      "api.version": "v1",
      "source":
        {
          "name": "Messages",
          "sourceType": "LocalFile",
          "pathExpression": "/var/log/syslog"
        }
      }'
  end
end

include_recipe 'sumologic-collector::install'
