class DomainConstraint
  attr_reader :domain_prefixes

  def initialize(*domain_prefixes)
    @domain_prefixes = domain_prefixes
  end

  def matches?(request)
    # return true unless Rails.configuration.x.real_db?
    @domain_prefixes.any? { |x| request.host.start_with?(x) }
  end

end