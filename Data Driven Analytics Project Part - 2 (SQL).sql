Use modelcarsdb;

-- Task 1.1--
select count(employeeNumber) as 'Num of Emps' from employees;
-- Interpretation: The count of total number of employees is 23.

-- Task 1.2--
select employeeNumber, concat(firstName, ' ', LastName) as 'Emp_Name', email, jobtitle from employees;
-- Interpretation: The basic information like EmployeeNumber, Name, Email and job title are displayed.

-- Task 1.3--
select jobtitle, count(*) as 'Emp_Count' from employees group by jobtitle;
-- Interpretation: Count of employees holding each jobtitle are listed.

-- Task 1.4--
select employeeNumber, reportsto from employees where reportsto is null;
-- Interpretation: EmployeeNumber 1002 don't have manager.

-- Task 1.5--
select customers.salesrepemployeenumber as 'Sales_Rep_Empno', sum(quantityordered*priceeach) as 'Total Sales' from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber
join customers on orders.customerNumber=customers.customerNumber group by customers.salesrepemployeenumber;
-- Interpretation: Calculated total sales for each sales representative.

-- Task 1.6--
select customers.salesrepemployeenumber as sales_Rep_Empno, sum(quantityordered*priceeach) as 'Total Sales'
from orderdetails join orders on orderdetails.orderNumber=orders.orderNumber join customers on orders.customerNumber=customers.customerNumber 
group by customers.salesrepemployeenumber order by sum(quantityordered*priceeach) desc limit 1;
-- Interpretation: The sales rep employee number '1370' is most profitable sales representative based on total sales.

-- Task 1.7--


-- Tak 2.1--
select customers.customernumber, avg(orderdetails.priceeach) as 'Avg_order_Price' from customers join orders
on customers.customerNumber=orders.customerNumber join orderdetails on orders.ordernumber=
orderdetails.ordernumber group by customers.customernumber;
-- Interpretation: The avg order amount for each customer is displayed.

-- Task 2.2--
select month(orders.shippeddate) as 'Month', count(*) as 'order count' from orders
group by month(orders.shippeddate);
-- Interpretation: Number of orders placed in each month is displayed.

-- Task 2.3--
select ordernumber, status from orders where status = 'pending';
-- Interpretation: None of the orders are still pending.

-- Task 2.4--
select customers.customernumber, customers.customername, customers.city, orders.ordernumber
from customers join orders on customers.customernumber=orders.customernumber;
-- Interpretation: The orders along with customer details are displayed.

-- Task 2.5--
select OrderNumber as 'Recent Order', Orderdate from orders order by ordernumber desc limit 1;
-- Interpretation: The order with order number 10425 is the most recent order.

-- Task 2.6--
select ordernumber, sum(quantityordered*priceeach) as 'Total Sales' from orderdetails
group by ordernumber;
-- Interpretation: The total sales for each order is displayed.

-- Task 2.7--
Select ordernumber, sum(quantityordered*priceeach) as 'Total Sales' from orderdetails 
group by ordernumber order by sum(quantityordered*priceeach) desc limit 1;
-- Interpretation: The The highest value order based on total sales is order 10165.

-- Task 2.8--
select orderdetails.ordernumber, orderdetails.productcode, sum(quantityordered*priceeach) as 'Total Sales' 
from orderdetails join orders on orders.ordernumber = orderdetails.ordernumber group by orderdetails.ordernumber, orderdetails.productcode
order by sum(quantityordered*priceeach);
-- Interpretation: Orders with their corresponding order details are listed.

-- Task 2.9--
select productcode, sum(quantityordered) as 'Total quantity orderd' from orderdetails group by productcode
order by sum(quantityordered) desc;
-- Interpretation: The most frequently orderd products are displayed.

-- Task 2.10--
select ordernumber, sum(quantityordered*priceeach) as 'total revenue' from orderdetails
group by ordernumber order by sum(quantityordered*priceeach);
-- Interpretation: The total revenue for each order is calculated.

-- Task 2.11--
select ordernumber, sum(quantityordered*priceeach) as 'total revenue' from orderdetails group by
ordernumber order by sum(quantityordered*priceeach) desc limit 1;
-- Interpretation: The most profitable order based on total revene is 10165.

-- Task 2.12--
select productname, productline, MSRP, ordernumber from products join orderdetails on orderdetails.productcode = 
products.productcode group by productname, productline, MSRP, ordernumber;
-- Interpretation: All the orders with product details are displayed.

-- Task 2.13--
select ordernumber, shippeddate, requireddate from orders where shippeddate>requireddate;
-- Interpretation: There is only one order is delayed.

-- Task 2.14--
select productname, count(*) as combination_count from orderdetails join products on orderdetails.productcode=
products.productcode join orders on orderdetails.ordernumber = orders.ordernumber group by productname order by combination_count
desc;
-- Interpretation: The most popular product combination within order is identified.

-- Task 2.15--
select ordernumber, sum(quantityordered*priceeach) as 'total revenue' from orderdetails group by
ordernumber order by sum(quantityordered*priceeach) desc limit 10;
-- Interpretation: The top 10 most profitable revenue for each order is displayed.

-- Task 2.16--
DELIMITER $$
CREATE TRIGGER update_credit_limit AFTER INSERT ON orderdetails FOR EACH ROW
BEGIN
update customers
set credit_limit = credit_limit - sum(orderdetails.quantityordered * orderDetails.priceEach)
where customers.productCode = orderdetails.productCode;
END$$
DELIMITER ;
-- INTERPRETATION: here the credit limits are automatically updated when the new orders are placed

-- Task 2.17--
DELIMITER $$
CREATE TRIGGER log_quantity_changes AFTER UPDATE ON orderdetails FOR EACH ROW
BEGIN
INSERT INTO productline (product_id, change_type, log_quantity, log_date)
VALUES (NEW.product_id,
CASE WHEN EXISTS (SELECT 1 FROM productline WHERE product_id = NEW.product_id AND change_type = 'UPDATE') THEN 'UPDATE'
ELSE 'INSERT'
END,
NEW.quantity,
NOW());
END$$
DELIMITER ;
-- INTERPRETATION: here the information of products gets changed whenever the orderdetails are inserted or updated.

