class_name Set extends Enumerable

var data_dict: Dictionary


func _init(data: Array = []):
	self.data_dict = {}
	for elem in data:
		self.data_dict[elem] = null


func _get_data() -> Array:
	return self.data_dict.keys()


func _to_string() -> String:
	return "{" + ", ".join(self._get_data()) + "}"


func has(key) -> bool:
	return data_dict.has(key)


func union(other: Set) -> Set:
	var result = self.data_dict.duplicate()
	result.merge(other.data_dict)
	return Set.new(result.keys())


func intersect(other: Set) -> Set:
	return self.where(func(x): return other.has(x)).to_set()
