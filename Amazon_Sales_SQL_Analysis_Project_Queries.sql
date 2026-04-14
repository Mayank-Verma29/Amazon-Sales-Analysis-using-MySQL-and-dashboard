Use amazon_sales;
select * from amazondata;

#Checking for the null values in the data set.
select * from amazondata
where Total_Sales is null;
#So, There is no Null values in the data set.

#Now performing EDA(EXPLORATORY DATA ANALYSIS)
# 1) Total Revenue
Select Sum(Total_Sales) as Total_Revenue
from amazondata;

# 2) Top 10 Customers
Select Customer_Name,Total_Spent,rnk as ranking
from (
	select Customer_Name,Sum(Total_Sales) as Total_Spent,
    row_number() over (order by sum(Total_Sales) desc) as rnk
    from amazondata
    group by Customer_Name
)t
where rnk<=10;

#3) Top Products
select Product, Total_Expenditure,rnk as ranking
from (
	select Product,sum(Total_Sales) as Total_Expenditure,
    row_number() over (order by sum(Total_Sales) desc) as rnk
    from amazondata
    group by Product
)t
where rnk<=10;

#4) Category-Wise Sales
select Category,sum(Total_Sales) as Total_Revenue
from amazondata
group by Category
Order by Total_Revenue desc;

#5) Monthly Sales Trend
Select MonthName(STR_TO_DATE(Date,"%d-%m-%y")) as Monthname,
sum(Total_Sales) as Revenue
from amazondata
group by MonthName(STR_TO_DATE(Date,"%d-%m-%y")),
		Month(STR_TO_DATE(Date,"%d-%m-%y"))
order by Month(STR_TO_DATE(Date,"%d-%m-%y"));

#Now ranking the Customer 
Select Customer_Name,
sum(Total_Sales) as Total_Revenue,
rank() over (order by sum(Total_Sales) desc) as rnk
from amazondata
group by Customer_Name;

#Running Total 
#to show the revenue gaining over the days
select Date,
sum(Total_Sales) over (order by Date) as Running_Total
from amazondata;

#Top product in each category
select Category, Product, Category_Revenue
from (
	select Category, Product, sum(Total_Sales) as Category_Revenue,
    rank() over (partition by Category order by sum(Total_Sales) desc) as rnk
    from amazondata
    group by Category,Product
)t
where rnk = 1
order by Category_Revenue desc;
