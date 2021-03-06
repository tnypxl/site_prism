# frozen_string_literal: true

require 'site_prism/error'
require 'addressable/template'

module SitePrism
  autoload :AddressableUrlMatcher, 'site_prism/addressable_url_matcher'
  autoload :DSL, 'site_prism/dsl'
  autoload :Deprecator, 'site_prism/deprecator'
  autoload :ElementChecker, 'site_prism/element_checker'
  autoload :Loadable, 'site_prism/loadable'
  autoload :Logger, 'site_prism/logger'
  autoload :Page, 'site_prism/page'
  autoload :RecursionChecker, 'site_prism/recursion_checker'
  autoload :RspecMatchers, 'site_prism/rspec_matchers'
  autoload :Section, 'site_prism/section'
  autoload :Timer, 'site_prism/timer'
  autoload :Waiter, 'site_prism/waiter'

  class << self
    attr_reader :use_all_there_gem

    def configure
      yield self
    end

    # The SitePrism logger object - This is called automatically in several
    # locations and will log messages according to the normal Ruby protocol
    # To alter (or check), the log level; call .log_level= or .log_level
    #
    # This logger object can also be used to manually log messages
    #
    # To Manually log a message
    #   SitePrism.logger.info('Information')
    #   SitePrism.logger.debug('Input debug message')
    #
    # By default the logger will output all messages to $stdout, but can be
    # altered to log to a file or another IO location by calling `.log_path=`
    def logger
      @logger ||= SitePrism::Logger.new.create
    end

    # `Logger#reopen` was added in Ruby 2.3 - Which is now the minimum version
    # for the site_prism gem
    #
    # This writer method allows you to configure where you want the output of
    # the site_prism logs to go (Default is $stdout)
    #
    # example: SitePrism.log_path = 'site_prism.log' would save all
    # log messages to `./site_prism.log`
    def log_path=(logdev)
      logger.reopen(logdev)
    end

    # To enable full logging (This uses the Ruby API, so can accept any of a
    # Symbol / String / Integer as an input
    #   SitePrism.log_level = :DEBUG
    #   SitePrism.log_level = 'DEBUG'
    #   SitePrism.log_level = 0
    #
    # To disable all logging (Done by default)
    #   SitePrism.log_level = :UNKNOWN
    def log_level=(value)
      logger.level = value
    end

    # To query what level is being logged
    #   SitePrism.log_level
    #   => :UNKNOWN # By default
    def log_level
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][logger.level]
    end

    # Whether you wish to use the new experimental all_there dependent gem
    #   This will be enforced from site_prism v4 onwards as this is where
    #   the development of this functionality will be focused
    def use_all_there_gem=(value)
      logger.debug("Setting use_all_there_gem to #{value}")
      @use_all_there_gem = value
    end
  end
end
