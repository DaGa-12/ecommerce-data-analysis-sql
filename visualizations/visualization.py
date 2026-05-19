import matplotlib.pyplot as plt

months = ["January", "February", "March"]
sales = [840, 300, 1600]

plt.bar(months, sales)

plt.title("Sales by Month")
plt.xlabel("Month")
plt.ylabel("Total Sales")

plt.grid(True)

plt.show()