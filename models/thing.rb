
class Thing < Sequel::Model

  DISPLAY_NAME = 'category'
  DISPLAY_NAME_PLURAL = 'categories'

  one_to_many :occurrences
  many_to_one :human

#  attr_accessor :name, :occurrences, :default_value, :thing_id
#  def initialize(hash={})
#    super
#    @occurrences ||= []
#    @default_value ||= 0
#  end

#  def save
#    if output = super
#      @occurrences.each do |occurrence|
##        occurrence.values[:thing_id] = id
##        add_occurrence(occurrence)
#      end
#    end
#    output
#  end

  def generate_default_occurrence_for_date(date)
    raise "Thing '#{name}' already has occurrence(s) for #{date.to_s}" if occurrence_exists_for_date(date)
    add_occurrence(value:default_value, date: date)
  end

  def total_value_for_date(date)
    occurrences_dataset.where(date: date).select_append{sum(value).as(total_for_date)}.first.values[:total_for_date] || 0
  end

  def create_todays_default_occurrence
    add_occurrence(value: default_value)
  end

  private

  def occurrence_exists_for_date(date)
    occurrences.any? { |f| f.date == date }
  end

  class << self

    def totals_for_human_on_date(human, date)
      output = {}
      relation = where(human_id: human.id).join(:occurrences, thing_id: :id).where(date: date).select_append{sum(value).as(total_for_date)}.group(:thing_id).order(:name)
      relation.each do |tuple|
        output[tuple.name] = tuple.values[:total_for_date]
      end
      output
    end
  end

end
