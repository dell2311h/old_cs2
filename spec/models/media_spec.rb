require 'spec_helper'

describe "Media Model" do
  let(:media) { Media.new }
  it 'can be created' do
    media.should_not be_nil
  end
end
