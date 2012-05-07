object @media
attributes :id, :location, :type
node(:meta_info) do |n|
  n.meta_info.attributes unless n.meta_info.nil?
end