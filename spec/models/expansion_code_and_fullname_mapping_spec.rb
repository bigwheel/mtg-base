require 'spec_helper'

describe 'ExpansionCodeAndFullnameMapping Model' do
  subject { ExpansionCodeAndFullnameMapping }

  describe '.code_to_fullname' do
    it 'if it given valid code, return matching expansion name' do
      subject.code_to_fullname('AVR').should == 'Avacyn Restored'
    end

    it 'if it given invalid code, return nil' do
      subject.code_to_fullname('XXX').should == nil
    end
  end
end
