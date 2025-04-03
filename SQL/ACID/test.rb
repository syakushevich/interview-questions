# Дан массив из элементов найти k-й (пусть будет 3-й элемент) самый повторяющийся элемент
# [1,5,7,4,1,1,1,1,5,5,5,7]
# в данном примере 3-й самый повторяющийся элемент это 7 

arr = [1,5,5]
def find_max_kth_el(arr)
  repeat_number = 3
  aggregate_sum_hash = arr.each_with_object(Hash.new(0)) { |number, hash| hash[number] += 1 }

  if aggregate_sum_hash.size < repeat_number
    return nil
  end

  aggregate_sum_hash.sort_by { |key, _| key }[repeat_number][0]
end