# encoding: utf-8
if defined?(ChefSpec)
  # cookbook:: database
  def create_mysql_database(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:mysql_database, :create, resource_name)
  end # def

  # cookbook:: database
  def drop_mysql_database(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:mysql_database, :drop, resource_name)
  end # def

  # cookbook:: database
  def grant_mysql_database_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:mysql_database_user, :grant, resource_name)
  end # def

end # if
