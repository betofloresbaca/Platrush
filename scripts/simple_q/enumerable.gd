class_name Enumerable extends Object

var _data: Array


static func empty():
	return Enumerable.new()


func _init(data: Array = [], duplicate: bool = true):
	if duplicate:
		self._data = data.duplicate()
	else:
		self._data = data


func _get_data() -> Array:
	return self._data


func _to_string() -> String:
	return str(self._get_data())


func at(index: int):
	return self._get_data()[index]


func select(select_function: Callable) -> Enumerable:
	var selected = self._get_data().map(select_function)
	return Enumerable.new(selected, false)


func where(where_function: Callable) -> Enumerable:
	var filtered_data = self._get_data().filter(where_function)
	return Enumerable.new(filtered_data, false)


func take(num_elems: int):
	var took_elemns = []
	for i in range(min(_get_data().size(), num_elems)):
		took_elemns.append(_get_data()[i])
	return Enumerable.new(took_elemns, false)


func skip(num_elems: int):
	var took_elemns = []
	for i in range(num_elems, _get_data().size()):
		took_elemns.append(_get_data()[i])
	return Enumerable.new(took_elemns, false)


func count():
	return _get_data().size()


func first():
	return _get_data()[0]


func first_or_default():
	if _get_data().size() < 1:
		return null
	return self.first()


func last():
	return _get_data()[-1]


func last_or_default():
	if _get_data().size() < 1:
		return null
	return self.last()


func any(any_function: Callable) -> bool:
	return _get_data().any(any_function)


func all(all_function: Callable) -> bool:
	return _get_data().all(all_function)


func join(other: Enumerable, self_selector: Callable, other_selector: Callable):
	var result = []
	var self_keys = self.select(self_selector)
	var other_keys = other.select(other_selector)
	for self_i in range(self.count()):
		for other_i in range(other.count()):
			if self_keys.at(self_i) == other_keys.at(other_i):
				result.append(Enumerable.new([self.at(self_i), other.at(other_i)], false))
	return Enumerable.new(result)


func shuffled() -> Enumerable:
	var clone = to_enumerable()
	clone._get_data().shuffle()
	return clone


func apply(operation: Callable):
	for i in range(self.count()):
		operation.call(self.at(i))


func to_enumerable() -> Enumerable:
	return Enumerable.new(self._get_data())


func to_set() -> Set:
	return Set.new(self._get_data())


func to_array() -> Array:
	return _get_data().duplicate()
