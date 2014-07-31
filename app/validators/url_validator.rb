class UrlValidator < ActiveModel::EachValidator

  # @see https://www.owasp.org/index.php/OWASP_Validation_Regex_Repository
  URL_REGEXP = %r[^((((https?|ftps?|gopher|telnet|nntp)://)|(mailto:|news:))(%[0-9A-Fa-f]{2}|[-()_.!~*';/?:@&=+$,A-Za-z0-9])+)([).!';/?:,][[:blank:]])?$]

  def validate_each(record, attribute, value)
    unless value =~ URL_REGEXP
      record.errors.add attribute, options[:message] || :invalid_url
    end
  end

end
