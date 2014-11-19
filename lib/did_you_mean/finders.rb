require "did_you_mean/word_collection"

module DidYouMean
  module BaseFinder
    def did_you_mean?
      return if DidYouMean.disabled? || suggestions.empty?

      output = "\n\n"
      output << "    Did you mean? #{format(suggestions.first)}\n"
      output << suggestions.drop(1).map{|word| "#{' ' * 18}#{format(word)}\n" }.join
      output << " " # for pry
    end

    def suggestions
      @suggestions ||= WordCollection.new(words).similar_to(target_word)
    end
  end

  class NullFinder
    def initialize(*); end
    def did_you_mean?; end
  end

  def self.finders
    @@finders ||= Hash.new(NullFinder)
  end
end

require 'did_you_mean/finders/name_error_finders'
require 'did_you_mean/finders/similar_attribute_finder'
require 'did_you_mean/finders/similar_method_finder'
