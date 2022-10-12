def merge_sort(lst):
    if len(lst) <= 1:
        return lst
    else:
        mid = len(lst) // 2
        left = merge_sort(lst[:mid])
        right = merge_sort(lst[mid:])
        return merge(left, right)
    
print(merge_sort([1, 40, 25, 30, 9, 5]))
