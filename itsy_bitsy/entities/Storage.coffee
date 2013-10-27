class Storage extends Entity #Move to normal classes
  @data: {}

  @save: (key,value) ->
    Storage.data[key] = value
    return false

  @load: (key) ->
    return Storage.data[key]


