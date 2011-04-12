require 'rubyamf/rails/action_controller'
require 'rubyamf/rails/request_processor'
require 'rubyamf/rails/routing'

# Hook up rendering
ActionController::Renderers.add :amf do |amf, options|
  @amf_response = amf
  @mapping_scope = options[:class_mapping_scope] || options[:mapping_scope] || nil
  self.content_type ||= Mime::AMF
  self.response_body = " "
end

class RubyAMF::Railtie < Rails::Railtie
  config.rubyamf = RubyAMF.configuration

  initializer "rubyamf.configured" do
    RubyAMF.bootstrap
  end

  initializer "rubyamf.middleware" do
    config.app_middleware.use RubyAMF::RequestParser
    config.app_middleware.use RubyAMF::Rails::RequestProcessor
  end
end