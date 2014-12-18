class FrontendConstraint
  def self.matches?(request)
    reserved_words = ['backend', 'stylesheets', 'assets']
    !reserved_words.include?(request.path_parameters.values[2])

    # raise "#{request.path_parameters.values[2]}"
  end
end