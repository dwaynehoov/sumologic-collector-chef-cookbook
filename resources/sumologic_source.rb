require 'json'

resource_name :sumologic_source
# for detailed source settings: https://service.sumologic.com/help/Using_JSON_to_configure_Sources.htm
property :name, String, name_property: true
property :source_json, String, required: true
property :syncsource_path, String, default: node['sumologic']['sumo_json_path']

def validate_source(source)
  s = JSON.parse(source)
  fail 'source_json requires api.version' unless s.key?('api.version')
  fail 'source_json requires source hash' unless s.key?('source')
  fail 'source_json.source requires sourceType' unless s['source'].key?('sourceType')
  valid_sourcetypes = %w(LocalFile RemoteFile LocalWindowsEventLog RemoteWindowsEventLog Syslog Script)
  fail "invalid sourceType #{s['source']['sourceType']}" unless valid_sourcetypes.include? s['source']['sourceType']
end

action :create do
  validate_source(source_json)

  file "#{syncsource_path}/#{name}.json" do
    content source_json
    action :create
  end
end

action :delete do
  file "#{syncsource_path}/#{name}.json" do
    action :delete
  end
end
