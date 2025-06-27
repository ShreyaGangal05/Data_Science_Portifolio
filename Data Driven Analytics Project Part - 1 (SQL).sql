use modelcarsdb;

/* Task 1.1*/
select customerName, creditLimit from customers order by creditLimit desc limit 10;
-- Interpretation: These are the the top 10 customers whose credit limit are high.

-- Task 1.2--
select avg(creditlimit) as 'avg_creditLimit', country from customers group by country;
-- Interpretation: The avg credit limit of customers each country wise is displyed.

-- Task 1.3--
select count(customerName) as 'Number_of_customers', state from customers group by state;
-- Interpretation: The number of customers in each state is displayed.

-- Task 1.4--
select customers.customerName, orders.orderNumber from customers left outer join orders 
 on customers.customerNumber=orders.customerNumber where orders.orderNumber is null;
-- Interpretation: These are the customers who haven't placed their orders.

-- Task 1.5--
 select orders.customerNumber, sum(orderdetails.quantityordered * orderdetails.priceeach) as 'total sales' from customers join orders
 on customers.customerNumber= orders.customerNumber
 join orderdetails on orders.orderNumber=orderdetails.ordernumber group by customers.customerNumber
 order by 'total sales' asc;
-- Interpretation: These are the total sales for each customer.

-- Task 1.6--
select customers.customerNumber, employees.jobTitle from customers join offices 
on customers.postalcode=offices.postalcode
join employees on offices.officeCode=employees.officeCode  where employees.jobTitle = 'sales Rep';
-- Interpretation: These are the customers who is working as sales sales representatives.

-- Task 1.7--
select customers.customerName, customers.customerNumber, customers.city, customers.phone, payments.paymentDate from customers
join payments on customers.customerNumber=payments.customerNumber order by paymentdate desc limit 15;
-- Interpretation: These are the customers details with recent payment details.(15 customers of recent payment details are displayed.)

-- Task 1.8--
SELECT  c.creditLimit, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName, c.creditLimit
HAVING totalSales > c.creditLimit;
-- Interpretation: These are the customers who have exceeded their creditlimit.

-- Task 1.9--
select customers.customerName from customers join orders 
on customers.customerNumber=orders.orderNumber join orderdetails on orders.orderNumber=orderdetails.orderNumber 
join products on orderdetails.productcode=products.productcode where products.productline='Motorcycles';
-- interpretation: The names of the customers who have placed an order for spectice product line are displayed.

-- Task 1.10--
select customers.customerName, orderdetails.priceeach from customers join orders on customers.customerNumber=orders.customerNumber
join orderdetails on orders.orderNumber=orderdetails.ordernumber 
join products on orderdetails.productcode=products.productcode
where orderdetails.priceeach=(select max(priceeach) from orderdetails);
-- Interpretation: These are the three customers who have placed an order for most expensive product.


/* Task 2.1*/
select offices.officecode, count(employees.employeenumber) as 'No of Emp' from employees join 
offices on employees.officecode=offices.officecode group by offices.officecode;
-- Interpretation: The count of employees in each office is displayed.

-- Task 2.2--
select offices.officecode, count(employees.employeenumber) as 'Num_Emp' from offices join
employees on employees.officecode=offices.officecode group by offices.officecode having count(employees.employeenumber)<5;
-- Interpretation: These are the records of less than 5 employees in each office.

-- Task 2.3--
select Officecode, Territory from offices;
-- Interpretation: The codes are displayed along with their territories.

-- Task 2.4--
select offices.officecode, employees.employeenumber from offices left join employees
on employees.officecode= offices.officecode;
-- Interpretation: No offices are null here all offices are assigned with employees.

-- Task 2.5--
select offices.officeCode, sum(orderdetails.quantityOrdered) as total_sales from orderdetails
 join orders on orders.orderNumber = orderdetails.orderNumber
 join customers on customers.customerNumber = orders.customerNumber
 join offices on offices.postalCode = customers.postalCode
 group by offices.officeCode order by total_sales desc;
-- Interpretation: Office 3 is the most proffitable based on total sales.ss

-- Task 2.6--
select offices.officecode, count(employees.employeenumber) as 'NO_OF_EMP' from employees
join offices on employees.officecode=offices.officecode group by offices.officecode order by count(employees.employeenumber)
desc limit 1;
-- Interpretation: Office 1 has highest number of employees.

-- Task 2.7--
select offices.officecode, avg(customers.creditlimit) as 'Avg Creditlimit' from offices 
join customers on customers.city=offices.city group by offices.officecode order by offices.officecode asc;
-- Interpretation: The avg creditlimit for each office is specified.

-- Task 2.8--
select offices.country, count(offices.officecode) as 'Num of offices' from offices
group by offices.country;
-- Interpretation: The number of offices in each country is displayed.


/* Task 3.1*/
select productlines.productline, count(products.productcode) as 'Num of Products'
from products join productlines on products.productline=productlines.productline 
group by productlines.productline order by count(products.productcode) asc;
-- Interpretation: The number of products in each productline is displayed.

-- Task 3.2--
select productline, Avg(buyprice) as 'Highest Product Price' from products 
group by productline order by avg(buyprice) desc limit 1;
-- Interpretation: Classic cars has a highest avg product price.

-- Task 3.3--
select productcode, buyprice, MSRP from products where MSRP between 50 and 100;
-- Interpretation: The productcode, buyprice and MSRP are displayed according to MSRP between 50 and 100.

-- Task 3.4--
select products.productline,  sum(orderdetails.quantityordered * orderdetails.priceeach) as 'Total Sales'from products
join orderdetails on products.productcode=orderdetails.productcode group by products.productline;
-- Interpretation: The total sales is displyed for each productline.

-- Task 3.5--
select productName, quantityinstock from products where quantityinstock<'10';
-- Interpretation: There are no products having inventory levels less than 10.

-- Task 3.6--
select productname, max(MSRP) as 'Highest MSRP' from products group by productname order by max(MSRP) desc limit 1;
-- Interpretation: The product with highest MSRP is displayed.
-- OR--
select productcode, productname, MSRP from products order by MSRP desc limit 1;
-- Interpretation: The product with highest MSRP is displayed.


-- Task 3.7--
select products.productname, sum(orderdetails.quantityordered * orderdetails.priceeach) as 'Total Sales' 
from products join orderdetails on products.productcode=orderdetails.productcode group by products.productName
order by sum(orderdetails.quantityordered * orderdetails.priceeach); 
-- Interpretation: The total sales for each product is displayed.

-- Task 3.8--
DELIMITER $$
CREATE PROCEDURE TopsellingProducts (in top_n int)
BEGIN
select products.productCode, products.productName, 
sum(quantityOrdered) as total_quantity from products
join orderdetails on products.productCode = orderdetails.productCode
group by products.productCode, products.productName
order by total_quantity desc limit top_n;
END $$
DELIMITER ;
call modelcarsdb.TopsellingProducts(1);
-- Interpretation: The top selling product based on total quantity ordered is 1992 Ferrari 360 spider red.

-- Task 3.9--
select productName, productline, quantityinstock from products where quantityinstock<'10'
and productline In('classic cars', 'motorcycles');
-- Interpretation: In classic cars and motorcycle they dont have a products with inventory level less than 10.

-- Task 3.10--
select products.productName from products join orderdetails on products.productcode=orderdetails.productcode
join orders on orders.orderNumber=orderdetails.orderNumber group by products.productName
having count(distinct orders.customerNumber)>10;
-- Interpretation: These are the products orderd by more than 10 customers.

-- Task 3.11--
select products.productcode, products.productname from products join orderdetails on 
products.productcode=orderdetails.productcode group by products.productcode having 
sum(quantityordered)>avg(quantityordered);
-- Interpretation: These are the products have ordered more than avg number of orders in each productline.



