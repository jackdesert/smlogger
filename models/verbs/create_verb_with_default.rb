class CreateVerbWithDefault < Verb

  def process
    respond '3 miles entered'
    self.class
  end

  private
  def successor
    RenameVerb
  end

  def appropriate?
    return false unless words.length == 4
    return false unless words.first == 'create'
    return false unless words.second.match AT_LEAST_ONE_LETTER
    return false unless words.third == 'default'
    return false unless words.fourth.match ALL_NUMBERS
    true
  end
end