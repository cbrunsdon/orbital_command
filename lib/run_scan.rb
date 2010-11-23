#!/usr/bin/ruby
require "rubygems"
require "bundler/setup"
require 'nmap/program'
require 'nmap/xml'
require 'orbital_command'

OrbitalCommand::Scan.new
