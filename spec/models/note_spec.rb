require 'spec_helper'

describe Note do
  let(:today) { Util.current_date_in_california }
  describe '#initialize' do

    let(:body) { 'iron' }

    subject { described_class.new(body: body) }
    it 'returns a Note' do
      subject.should be_an described_class
    end
    it 'saves the body in the new action' do
      subject.valid?
      subject.body.should == body
      subject.date.should == today
    end
  end

  context 'validations' do
    let(:note) { described_class.new }
    context 'when body is present' do
      it 'is invalid' do
        note.body = 'hi'
        note.should_not have_error_on(:body)
      end
    end
    context 'when body is blank' do
      it 'is invalid' do
        note.body = nil
        note.should have_error_on(:body)
      end
    end
    context 'when date is blank' do
      it 'sets the date' do
        note.date = nil
        note.valid?
        note.date.should be_a(Date)
      end
    end
    context 'when date is a Date' do
      it 'is valid' do
        note.date = today
        note.should_not have_error_on(:date)
      end
    end
    context 'when date is a number' do
      it 'is invalid' do
        note.date = 1
        note.should have_error_on(:date)
      end
    end
  end


end












