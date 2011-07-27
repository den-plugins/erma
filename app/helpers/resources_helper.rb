module ResourcesHelper

  def sort_resources(resources)
    resources.sort{|a,b| a.user <=> b.user}
  end
end