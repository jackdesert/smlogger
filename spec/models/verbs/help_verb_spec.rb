require 'spec_helper'

describe HelpVerb do
  describe '#appropriate?' do
    yesses = [
      ['help'],
    ]
        
    verify_appropriateness_of(yesses, described_class)
  end 

  describe '#process' do
    let(:thing1) { Thing.new(name: 'run', default_value: 6) }
    let(:thing2) { Thing.new(name: 'eat', default_value: 2) }
    let(:human) { Human.new(phone_number: '1111111111', things: [thing1, thing2]) }
    subject { described_class.new('', human) }
    it 'returns a message' do
      expected = "Available commands:
HELP
LIST
TODAY
YESTERDAY
CREATE <thing> [DEFAULT <number>]
RENAME <thing_name> <new_name>
DELETE <thing>

Full docs: http://sm.sunni.ru/docs"
      subject.send(:process).should == expected
    end
  end
end

