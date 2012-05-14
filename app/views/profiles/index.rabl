collection @profiles, :object_root => :profile
attributes :id, :name, :created_at
child :commands do
  attributes :id, :ordering_number, :job_name, :create_media, :update_media
  child :options do
    attributes :key, :params_key_name
  end
end
