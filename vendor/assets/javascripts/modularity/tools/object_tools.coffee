# Returns an object that contains only the attributes 
# that are different between obj_1 and obj_2.
# Only looks for changed attributes, not missing attributes.
modularity.object_diff = (obj_1, obj_2) ->
  result = {}
  for own key, value_2 of obj_2
    do (key, value_2) ->
      value_1 = obj_1[key]
      result[key] = value_2 if value_1 != value_2
  result


modularity.object_length = (obj) ->
  # NOTE(KG): This doesn't work in IE8.
  Object.keys(obj).length
