require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting ERMA plugin for DEN'

Redmine::Plugin.register :erma do
  name 'DEN ERMA plugin'
  author 'Exist DEN Team'
  description 'This is an ERMA plugin for DEN'
  version '0.1.0'
end