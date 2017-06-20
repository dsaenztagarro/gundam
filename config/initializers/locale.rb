require 'i18n'

load_path = File.expand_path("../../locales/en.yml", __FILE__)

I18n.load_path << load_path

I18n.default_locale = :en
