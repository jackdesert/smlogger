require 'spec_helper'

describe TodayVerb do
  before do
    # Make sure Date.today is not used to initialize anything, since it 
    # really should be using Util.current_date_in_california
    mock(Date).today.never
  end

  describe '#appropriate?' do
    yesses = [
      ['today'],
    ]
        
    verify_appropriateness_of(yesses, described_class)
  end 


  describe '#process' do

    let(:today) { Time.now.to_date }
    let(:yesterday) { today - 1 }
    let(:ran_this_morning) { Occurrence.new(date: today, value: 1) }
    let(:ran_this_afternoon) { Occurrence.new(date: today, value: 17) }
    let(:ran_yesterday) { Occurrence.new(date: yesterday, value: 3) }
    let(:walked_today) { Occurrence.new(date: today, value: 5) }
    let(:walked_yesterday) { Occurrence.new(date: yesterday, value: 7) }
    let(:thing1) { Thing.new(name: 'run', default_value: 6) }
    let(:thing2) { Thing.new(name: 'walk', default_value: 2) }
    let(:human) { create(:human) }
    subject { described_class.new('anything', human) }

    before do
      human.add_thing(thing2)
      human.add_thing(thing1)
      stub(human).backfill
    end

    context 'when things have been logged today' do

      before do
        thing1.add_occurrence(ran_this_morning)
        thing1.add_occurrence(ran_this_afternoon)
        thing1.add_occurrence(ran_yesterday)
        thing2.add_occurrence(walked_today)
        thing2.add_occurrence(walked_yesterday)
      end

      it 'returns totals in alphabetical order' do
        subject.send(:process).should == "Today's totals:\nRun: 18\nWalk: 5"
      end

    end
    context 'when nothing has been logged today' do

      before do
        thing1.add_occurrence(ran_yesterday)
        thing2.add_occurrence(walked_yesterday)
      end

      it 'returns a message' do
        subject.send(:process).should == "You have not logged anything today."
      end
    end

  end

end

