require 'spec_helper'

describe "MetaInfo Model" do
  let(:meta_info) { MetaInfo.new }
  it 'can be created' do
    meta_info.should_not be_nil
  end
end
