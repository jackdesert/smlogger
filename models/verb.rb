class Verb

  attr_accessor :words

  def initialize(arg)
    @words = parse_to_array(arg)
  end

  def receive
    return no_thanks unless appropriate?
    process
  end

  private
  def successor
    ActionVerb
  end

  def appropriate?
    false
  end

  def respond(message)
  end

  def no_thanks
    if successor
      successor.new(words).receive
    else
      raise 'no successor found'
    end
  end

  def parse_to_array(input)
    return input if input.kind_of? Array
    input.strip.gsub(/\t+/, ' ').split
  end
end
