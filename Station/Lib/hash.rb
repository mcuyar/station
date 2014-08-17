class ::Hash
  # http://stackoverflow.com/questions/9381553/ruby-merge-nested-hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end

  def find?(key, default=nil)
    keys = key.split('.')
    if keys.length > 1
      key = keys.shift
      self.has_key?(key) ? self[key].find?(keys.join('.'), default) : default
    else
      self[key] || default
    end
  end

end