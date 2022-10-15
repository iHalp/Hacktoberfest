# binary search!
def binary_search():
    list = [1,2,3,4,5,6,7,8,9,10]
    print("Enter the number you want to search")
    num = int(input())
    low = 0
    high = len(list)-1
    while low <= high:
        mid = (low+high)//2
        if list[mid] == num:
            print("Found at position", mid)
            break
        elif list[mid] < num:
            low = mid+1
        else:
            high = mid-1
    else:
        print("Not found")
