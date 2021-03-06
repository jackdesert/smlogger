require 'spec_helper'

describe Verb  do
  reusable_hash = {
      "" => [''],
      "  3       miles    \t" => ['3', 'miles'],
      "blAther" => ['blather'],
      "\t twenty MINUTES\tbefore  dawn\t  " => ['twenty', 'minutes', 'before', 'dawn'],
      ['1', '2', '3'] => ['1', '2', '3'],
    }


  describe '#single_word_commands' do
    subject { Verb::SINGLE_WORD_COMMANDS }
    it { should =~ [:y, :menu, :list, :today, :yesterday, :note, :last, :create, :rename, :delete, :update] }
  end

  describe '#numbers_as_words' do
    subject { Verb::NUMBERS_AS_WORDS }
    it { should =~ [:one, :two, :three, :four, :five, :six, :seven, :eight, :nine, :ten, :eleven] }
  end


  describe '#convert_to_array' do
    let(:verb) { described_class.new('anything', Human.new) }
    reusable_hash.each_pair do |string, expected_array|
      it "turns #{string} into #{expected_array}" do
        verb.send(:convert_to_array, string).should == expected_array
      end
    end
  end

  describe '#initialize' do
    reusable_hash.each_pair do |argument, expected_words|
      it "turns #{argument} into #{expected_words}" do
        verb = Verb.new(argument, Human.new)
        verb.send(:words).should == expected_words
      end
    end
  end

  describe '#process' do
    let(:human) { create(:human) }
    subject { Verb.new('', human) }
    it 'makes a call to backfill' do
      mock(human).backfill
      mock(subject).process
      subject.response
    end
  end

  hash = {
          'sex' => ActionVerb,
          '3 miles' => ActionVerb,
          'y 3 miles' => ActionVerb,
          'menu' => MenuVerb,
          'list' => ListVerb,
          'today' => TodayVerb,
          'yesterday' => YesterdayVerb,
          'note worthy' => NoteVerb,
          'last miles' => LastVerb,
          'history' => HistoryVerb,
          'create miles' => CreateVerb,
          'create miles default 30' => CreateVerbWithDefault,
          'rename miles run' => RenameVerb,
          'delete run' => DeleteVerb,
          'update run default 30' => UpdateDefaultVerb,
          'nonsense' => NonsenseVerb,
          '' => NonsenseVerb,
        }

  hash.each_pair do |string, verb_subclass|
    it "returns #{verb_subclass} when receives '#{string}'" do
      human = Human.new
      stub(human).thing_names { ['sex'] }
      responder = Verb.new(string, human).responder
      responder.should be_a verb_subclass
    end
  end

end
