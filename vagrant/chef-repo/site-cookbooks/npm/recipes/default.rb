#
# Cookbook Name:: npm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute 'rpm update' do
  command 'npm update -g npm'
end