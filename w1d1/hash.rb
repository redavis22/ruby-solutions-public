def set_add_el(set, el)
  set[el] = true
end

def set_remove_el(set, el)
  set.delete(el)
end

def set_list_els(set)
  set.keys
end

def set_member?(set, el)
  set[el].nil?
end

def set_union(set1, set2)
  # I had this one create a new set rather than modify either.
  set1.merge(set2)
end

def set_intersection(set1, set2)
  # Ooh, `delete_if` is fancy; didn't know that one!
  # And I used `dup` to avoid modifying set1.
  set1.dup.delete_if { |key| not set2.has_key?(key) }
end

def set_minus(set1, set2)
  set1.dup.delete_if { |key| set2.has_key?(key) }
end
