require 'chefspec'

describe 'rails_app::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge 'rails_app::default' }
end
