module MovieCache

  PREFIX = "hbizzle_#{Rails.env}_"

  def self.set_map_cache(name, hash)
    $redis.mapped_hmset "#{PREFIX}#{name}", hash
  end

  def self.get_cached_map_value(name, field)
    $redis.hgetall("#{PREFIX}#{name}")[field.to_f.to_s].to_i
  end

  def self.get_cached_map(name)
    $redis.hgetall("#{PREFIX}#{name}")
  end

end