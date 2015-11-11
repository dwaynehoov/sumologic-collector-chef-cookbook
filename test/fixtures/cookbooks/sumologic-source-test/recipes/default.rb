#
# Cookbook Name:: sumologic-source-test
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
node.default['sumologic']['use_json_path_dir'] = true

include_recipe 'sumologic-collector::sumoconf'
include_recipe 'sumologic-collector::sumojsondir'

if platform_family? 'windows'
  sumologic_source 'Windos Event Logs' do
    source_json '{
      "api.version": "v1",
      "source":
        {
          "name": "Windows Event Logs",
          "sourceType": "LocalWindowsEventLog",
          "logNames": [ "Application", "System" ],
          "category": "OS/Windows/Events"
        }
      }'
  end
else
  sumologic_source 'messages' do
    source_json '{
      "api.version": "v1",
      "source":
        {
          "name": "Messages",
          "sourceType": "LocalFile",
          "automaticDateParsing": true,
          "multilineProcessingEnabled": false,
          "useAutolineMatching": true,
          "forceTimeZone": false,
          "timeZone": "UTC",
          "category": "OS/Linux/System",
          "pathExpression": "/var/log/messages"
        }
      }'
  end

  sumologic_source 'secure' do
    source_json '{
      "api.version": "v1",
      "source":
        {
          "name": "Secure",
          "sourceType": "LocalFile",
          "automaticDateParsing": true,
          "multilineProcessingEnabled": false,
          "useAutolineMatching": true,
          "forceTimeZone": false,
          "timeZone": "UTC",
          "category": "OS/Linux/Security",
          "pathExpression": "/var/log/secure"
        }
      }'
  end

end

include_recipe 'sumologic-collector::install'
