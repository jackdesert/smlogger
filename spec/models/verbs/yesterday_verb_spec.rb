require 'spec_helper'

describe YesterdayVerb do

  describe '#process' do
    let(:ran_today) { Occurrence.new(date: 1, value: 1) }
    let(:ran_yesterday) { Occurrence.new(date: 2, value: 3) }
    let(:walked_today) { Occurrence.new(date: 1, value: 5) }
    let(:walked_yesterday) { Occurrence.new(date: 2, value: 7) }
    let(:thing1) { Thing.new(name: 'run', default_value: 6, occurrences: [ran_today, ran_yesterday]) }
    let(:thing2) { Thing.new(name: 'walk', default_value: 2, occurrences: [walked_today, walked_yesterday]) }
    let(:human) { Human.new(phone_number: '1111111111', things: [thing1, thing2]) }
    subject { described_class.new('rename run miles', human) }
    it 'returns a message' do
      mock(subject).respond("Yesterday's totals:\n3 run\n7 walk")
      subject.send(:process)
    end
  end

  describe '#appropriate?' do
    yesses = [
      ['yesterday'],
    ]
        
    verify_appropriateness_of(yesses, described_class)
  end 
end
